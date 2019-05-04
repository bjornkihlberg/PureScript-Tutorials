## Description
### Reactiveness
I've found modelling evolving state as composition of event streams to be intuitive and easy to manage. I do not yet have enough experience with this style of programming to know if it's maintainable or if it scales well.

In this example I'm creating a stream of states tracking which keyboard buttons are pressed down with no successive repeats of the same state. We'll learn some interesting things about PureScript and this style of programming along the way.

We start by creating a pair of an event stream and a function that push events onto that stream. To do this we use `create :: forall a. Effect { event :: Event a, push :: a -> Effect Unit }` from the [FRP.Event](https://pursuit.purescript.org/packages/purescript-event/1.2.4/docs/FRP.Event) module.
```purescript
main :: Effect Unit
main = do
    { event, push } <- create

    pure unit
```
*Note that we haven't told PureScript which types we want to work with. PureScript has a Hindley-Milner type system that infer the types by how we use `event` or `push`. We get the terseness of dynamic languages like Python but high reliability.*

*Further you should notice that this is very similar to [Redux](https://redux.js.org/). Actually, you can implement Redux in PureScript in one or two lines of code.*

Now we need to push keyboard presses into `event`. In order to track if a button is pressed or not we need to track when a key was pressed down and also when it's released. That way we can deduce whether a button is being pressed. I could create a sum type like `data KeyEvent a = Down a | Up a` which might be good for a larger project because it's more apparent what its purpose is but the [Either](https://pursuit.purescript.org/packages/purescript-either/4.1.1/docs/Data.Either#t:Either) type has a lot of useful utility functions that I want to use. We'll use `Left` for presses and `Right` for releses.
```purescript
main :: Effect Unit
main = do
    { event, push } <- create
    
    onKeyDownEvent <- eventListener $ onKey (Right >>> push)
    onKeyUpEvent   <- eventListener $ onKey (Left  >>> push)

    pure unit

    where
        onKey :: (String -> Effect Unit) -> Event -> Effect Unit
        onKey dispatch e = fromEvent e <#> key # maybe (pure unit) dispatch
```
A lot of stuff at once here but it's not as bas as it seems. The `onKey :: (String -> Effect Unit) -> Event -> Effect Unit` is a little juicy but splitting it up seems to make this example cluttered. `onKey` takes the `push` function and maps the [Event](https://pursuit.purescript.org/packages/purescript-web-events/2.0.1/docs/Web.Event.Internal.Types#t:Event) to the keyboard button value and invokes `push` with it.
## Instructions
### Setup
1. Install required packages
    ```
    npx psc-package install web-uievents
    npx psc-package install console
    npx psc-package install event
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