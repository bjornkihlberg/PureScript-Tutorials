## Description
### Canvas
We're producing this result with [HTML5 Canvas](https://www.w3schools.com/html/html5_canvas.asp).

![canvas01](https://user-images.githubusercontent.com/38290734/57141313-2eeadf80-6dba-11e9-8d24-ca4d3e78e55b.png)

*I'm keeping it simple because in the next tutorial we're animating it and control it with user input.*

The canvas is very stateful and imperative. It's important that we have the ability to work in this manner in a programming language and PureScript allows us to do it safely and segregate our harmful effects from our pure code.

We start by setting up the canvas in *index.html*
```html
<body>
    <canvas id="mycanvas" width="500" height="200"></canvas>
    <script src="bundle.js"></script>
</body>
```
*bundle.js* is our compiled PureScript program. Next we need to get a reference to the canvas in our application by using the canvas id. We use the function `getCanvasElementById :: String -> Effect (Maybe CanvasElement)`.
```purescript
main :: Effect Unit
main = do
    canvas <- getCanvasElementById "mycanvas"
    
    pure unit
```
*We invoke `pure unit` to make the code compile and allow us to build our code gradually. We will not include this line in the final result.*

Since `getCanvasElementById` returns a `Maybe` we need to match on the result.
```purescript
case canvas of
    Nothing -> log "Couldn't find canvas by id"
    Just canvas -> do
```
*I shadow the `canvas` name because I don't need the previous `canvas` reference any more. This could be cleaned up later using the `maybe :: forall a b. b -> (a -> b) -> Maybe a -> b`*

Next up we get the 2D rendering context so we can [draw stuff](https://www.w3schools.com/graphics/canvas_drawing.asp).
```purescript
Just canvas -> do
    ctx <- getContext2D canvas
    paintShip ctx 0.1 170.0 100.0
```
What is `paintShip :: Context2D -> Number -> Number -> Number -> Effect Unit`? It's a function that draws a little spaceship. I will not go into details because all you need to do is study the HTML5 Canvas API and you will understand what this stuff does. It's a very 1:1 interface to equivalent JavaScript implementation.
```purescript
paintShip :: Context2D -> Number -> Number -> Number -> Effect Unit
paintShip ctx turns x y = do
    translate ctx { translateX: x, translateY: y }
    rotate ctx (turns * 2.0 * pi)
    beginPath ctx
    moveTo ctx 0.0 10.0
    lineTo ctx (-5.0) (-5.0)
    lineTo ctx 0.0 (-1.0)
    lineTo ctx 5.0 (-5.0)
    lineTo ctx 0.0 10.0
    stroke ctx
    setFillStyle ctx "#FF0000"
    fill ctx
    beginPath ctx
    setTransform ctx { m11: 1.0, m12: 0.0, m21: 0.0, m22: 1.0, m31: 0.0, m32: 0.0 }
```
*Basically it draws a red little spaceship, rotated and positioned at given screen space coordinates.*

I've also implemented a function for clearing the screen which is not useful for this tutorial but I wanted to include it because I think it helps us understand how we think about working with the `canvas` reference in PureScript. *You can skip this bit if you like.*

We use `clearRect :: Context2D -> Rectangle -> Effect Unit` to clear the canvas in the specified rectangle area using a `type Rectangle = { x :: Number, y :: Number, width :: Number, height :: Number }` where `x` and `y` are the positions for the rectangle top left corner and `width` and `height` should be self explanatory. So we need the width and height of the canvas to clear all of it. To get the width and height we use `getCanvasDimensions :: CanvasElement -> Effect Dimensions`. The `type Dimensions = { width :: Number, height :: Number }` contains our desired canvas width and height.
```purescript
Just canvas -> do
    { width, height } <- getCanvasDimensions canvas
    ctx <- getContext2D canvas
    clearRect ctx { x: 0.0, y: 0.0, width, height }
    paintShip ctx 0.1 170.0 100.0
```
*I clear before drawing which isn't necessary because we only draw once but I wanted to include this anyway.*
## Instructions
### Setup
1. Install required packages
    ```
    npx psc-package install console
    npx psc-package install web-html
    npx psc-package install canvas
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