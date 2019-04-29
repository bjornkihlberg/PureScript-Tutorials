## Description
### Interacting with the browser
#### Bundling
To start off we create regular old *index.html* with a `script` tag referring to *bundle.js*.
```html
<body>
    <script src="bundle.js"></script>
</body>
```
We bundle our application into the same folder as *index.html* and name it *bundle.js*.
```
pulp --psc-package --watch build --to bundle.js
```
This command minifies the output and only includes what's necessary from the PureScript packages as well as recompiles when there are changes to the source code. Default behaviour is for the entrypoint `main :: Effect Unit` to automatically be invoked when the script is loaded. It's possible to disable this but I keep it on for now.
```purescript
module Main where

import Prelude

import Effect (Effect)
import Effect.Console as Console

main :: Effect Unit
main = Console.log "Hello, world!"
```
*This will cause the browser to present `Hello, world!` in the console when loading index.html*
#### window, document, etc
We use the [web-html](https://pursuit.purescript.org/packages/purescript-web-html/2.0.1) package to do basic operations with the browser. Interacting with the `window` object and the DOM are effectful operations and need to be performed in a monadic `Effect` context. For example, to get the window object we invoke `window :: Effect Window` and to make an alert we invoke `alert :: String ->  Window -> Effect Unit`.
```purescript
main :: Effect Unit
main = do
    w <- window
    alert "Hello, world!" w
```
*Since Effect is a monad the above code can be refactored with `>>=`*
```purescript
main :: Effect Unit
main = window >>= alert "Hello, world!"
```
*This is called "point free style" because we just pipe the results through our functions without using temporary variables like `w`*

Let's include a button in our body and print to the console when it's clicked.
```html
<body>
    <button id="mybutton">Click me</button>
    <script src="bundle.js"></script>
</body>
```
Getting access to this element is not that hard but not completely straight forward. We need to do some detective work. We need to go to the documentation for [web-html](https://pursuit.purescript.org/packages/purescript-web-html/2.0.1) and [web-events](https://pursuit.purescript.org/packages/purescript-web-events/2.0.1) to find what we need and try to connect the types until we can go from what we have (`window`) to what we need (`addEventListener`).

Let's walk through this step by step.
1. We have a starting point.
    ```purescript
    window :: Effect Window
    ```
1. We know we need `addEventListener`.
    ```purescript
    -- from module Web.Event.EventTarget
    addEventListener :: EventType -> EventListener -> Boolean -> EventTarget -> Effect Unit
    ```
1. From this we can see we need a couple of things.
    ```purescript
    -- from module Web.Event.EventTarget
    eventListener :: forall a. (Event -> Effect a) -> Effect EventListener

    -- from module Web.HTML.Event.EventTypes
    click :: EventType

    -- from module Web.HTML.HTMLButtonElement
    toEventTarget :: HTMLButtonElement -> EventTarget
    ```
1. Let's look for `getElementById` and see if we can get `HTMLButtonElement` through that somehow.
    ```purescript
    -- from module Web.DOM.NonElementParentNode
    getElementById :: String -> NonElementParentNode -> Effect (Maybe Element)
    ```
1. Presumably we need something to convert `HTMLDocument` to `NonElementParentNode`
    ```purescript
    -- from module Web.HTML.HTMLDocument
    toNonElementParentNode :: HTMLDocument -> NonElementParentNode
    ```
1. Now we can get an `HTMLButtonElement`
    ```purescript
    -- from module Web.HTML.Window
    document :: Window -> Effect HTMLDocument
    -- from module Web.HTML.HTMLButtonElement
    fromElement :: Element -> Maybe HTMLButtonElement
    ```
I think that's it! Note that I just looked at the types and sort of guessed how this would work. We can see from the types how these should be connected. Let's string all of this together and see if it works! Again we do it step by step.
1. Start with getting access to `Window` and `HTMLDocument`. They're the easy ones.
    ```purescript
    main :: Effect Unit
    main = do
        w <- window
        d <- document w

        pure unit
    ```
    *The function is not finished yet so we put `pure unit` at the end so it compiles. `pure unit` will be removed later.*
1. We can invoke `toNonElementParentNode :: HTMLDocument -> NonElementParentNode`
    ```purescript
    let myButtonNode = toNonElementParentNode d
    ```
1. Now we try to get the element with `getElementById :: String -> NonElementParentNode -> Effect (Maybe Element)`
    ```purescript
    maybeMyButtonElement <- getElementById "mybutton" myButtonNode
    ```
1. Things get a little funky here because PureScript aims to be safe. If there is no element with id `mybutton`, we get a `Nothing` back. So we have to match against the case (We'll clean this up later).
    ```purescript
    case maybeMyButtonElement of
        Nothing -> log "could not find element by given id"
        Just myButtonElement -> -- do more stuff
    ```
1. Now we try to turn our `Element` to a `HTMLButtonElement` which can also fail in case the element is not a button.
    ```purescript
    Just myButtonElement -> 
        case fromElement myButtonElement of
            Nothing -> log "given element was not a button"
            Just myButton ->  -- do more stuff
    ```
1. Finally we define the click event function and attach it to the button.
    ```purescript
    Just myButton -> do
        let myButtonEventTarget = toEventTarget myButton
        myButtonClickEvent <- eventListener (\_ -> log "You clicked!")
        addEventListener click myButtonClickEvent false myButtonEventTarget
    ```
This is the result.
```purescript
module Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)
import Web.DOM.NonElementParentNode (getElementById)
import Web.Event.EventTarget (addEventListener, eventListener)
import Web.HTML (window)
import Web.HTML.Event.EventTypes (click)
import Web.HTML.HTMLButtonElement (fromElement, toEventTarget)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

main :: Effect Unit
main = do
    w <- window
    d <- document w
    let myButtonNode = toNonElementParentNode d
    maybeMyButtonElement <- getElementById "mybutton" myButtonNode
    case maybeMyButtonElement of
        Nothing -> log "could not find element by given id"
        Just myButtonElement -> 
            case fromElement myButtonElement of
                Nothing -> log "given element was not a button"
                Just myButton -> do
                    let myButtonEventTarget = toEventTarget myButton
                    myButtonClickEvent <- eventListener (\_ -> log "You clicked!")
                    addEventListener click myButtonClickEvent false myButtonEventTarget
```
Terrible. But it works! Clicking the button in the ui causes the browser to present `You clicked!` in the console. But let's clean this mess up, step by step.
1. `w` and `d` are only used once so we can do the following simplification.
    ```purescript
    w <- window
    d <- document w
    let myButtonNode = toNonElementParentNode d
    -- can be turned into
    myButtonNode <- window >>= document <#> toNonElementParentNode
    ```
1. Since `myButtonNode` is only used once, we can simplify further.
    ```purescript
    myButtonNode <- window >>= document <#> toNonElementParentNode
    maybeMyButtonElement <- getElementById "mybutton" myButtonNode
    ```
1. That should probably be put into its own function
    ```purescript
    documentGetElementById :: String -> Effect (Maybe Element)
    documentGetElementById id =
        window >>= document <#> toNonElementParentNode >>= getElementById id
    ```
    and referred in `main`.
    ```purescript
    maybeMyButtonElement <- documentGetElementById "mybutton"
    ```
1. We can simplify the `Maybe` logic with `>>=` if we're willing to give up the logs indicating what exactly went wrong. I am in this case!
    ```purescript
    case maybeMyButtonElement of
        Nothing -> log "could not find element by given id"
        Just myButtonElement -> 
            case fromElement myButtonElement of
                Nothing -> log "given element was not a button"
    -- can be turned into
    case maybeMyButtonElement >>= fromElement of
        Nothing -> log "given element could not be found or it was not a button"
    ```
1. Since `myButton` is only used once and directly mapped with `toEventTarget` we can simplify this even further.
    ```purescript
    case maybeMyButtonElement >>= fromElement of
        Nothing -> log "given element could not be found or it was not a button"
        Just myButton -> do
            let myButtonEventTarget = toEventTarget myButton
    -- can be turned into
    case maybeMyButtonElement >>= fromElement <#> toEventTarget of
        Nothing -> log "given element could not be found or it was not a button"
        Just myButtonEventTarget -> -- do stuff
    ```
1. `eventListener` doesn't depend on the previous results and can be moved outside the case expression into the main `do` body.
    ```purescript
    myButtonClickEvent <- eventListener (\_ -> log "You clicked!")
    ```
1. What we're left with can be simplified with the function `maybe :: forall a b. b -> (a -> b) -> Maybe a -> b`
    ```purescript
    myButtonClickEvent <- eventListener (\_ -> log "You clicked!")
    case maybeMyButtonElement >>= fromElement <#> toEventTarget of
        Nothing -> log "given element could not be found or it was not a button"
        Just myButtonEventTarget -> do
            addEventListener click myButtonClickEvent false myButtonEventTarget
    -- can be turned into
    myButtonClickEvent <- eventListener (\_ -> log "You clicked!")
    maybe
        (log "given element could not be found or it was not a button")
        (addEventListener click myButtonClickEvent false)
        (maybeMyButtonElement >>= fromElement <#> toEventTarget)
    ```
Finally we end up with this. A lot more neat and concise!
```purescript
module Main where

import Prelude

import Data.Maybe (Maybe, maybe)
import Effect (Effect)
import Effect.Console (log)
import Web.DOM (Element)
import Web.DOM.NonElementParentNode (getElementById)
import Web.Event.EventTarget (addEventListener, eventListener)
import Web.HTML (window)
import Web.HTML.Event.EventTypes (click)
import Web.HTML.HTMLButtonElement (fromElement, toEventTarget)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

documentGetElementById :: String -> Effect (Maybe Element)
documentGetElementById id =
    window >>= document <#> toNonElementParentNode >>= getElementById id

main :: Effect Unit
main = do
    maybeMyButtonElement <- documentGetElementById "mybutton"
    myButtonClickEvent <- eventListener (\_ -> log "You clicked!")
    maybe
        (log "given element could not be found or it was not a button")
        (addEventListener click myButtonClickEvent false)
        (maybeMyButtonElement >>= fromElement <#> toEventTarget)
```
That's decent! Gives a clear overview of what's going on! The type system helped me every step of the way. Very cool!
## Instructions
### Setup
1. Install required packages
    ```
    npx psc-package install console
    npx psc-package install web-html
    ```
1. Set up npm scripts in `package.json` for ease of use
    ```json
    "scripts": {
        "postinstall": "psc-package install",
        "build": "pulp --psc-package --watch build --to bundle.js"
    }
    ```
### Usage
1. Download and install all project dependencies
    ```
    npm install
    ```
1. Start the PureScript build process
    ```
    npm run build
    ```