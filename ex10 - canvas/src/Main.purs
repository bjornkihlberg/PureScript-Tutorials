module Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)
import Graphics.Canvas (Context2D, beginPath, clearRect, fill, getCanvasDimensions, getCanvasElementById, getContext2D, lineTo, moveTo, rotate, setFillStyle, setTransform, stroke, translate)
import Math (pi)

paintShip :: Context2D -> Number -> Number -> Number -> Effect Unit
paintShip ctx r x y = do
    translate ctx { translateX: x, translateY: y }
    rotate ctx (r * 2.0 * pi)
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
    setTransform ctx { m11: 1.0, m12: 0.0, m21: 0.0, m22: 1.0, m31: 0.0, m32: 0.0}

main :: Effect Unit
main = do
    canvas <- getCanvasElementById "mycanvas"
    case canvas of
        Nothing -> log "Couldn't find canvas by id"
        Just canvas -> do
            { width, height } <- getCanvasDimensions canvas
            ctx <- getContext2D canvas
            clearRect ctx { x: 0.0, y: 0.0, width, height }
            paintShip ctx 0.5 50.0 100.0
