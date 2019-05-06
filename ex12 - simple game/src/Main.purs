module Main where

import Prelude

import Data.Maybe (maybe)
import Effect (Effect)
import Effect.Console (log)
import Graphics.Canvas as C
import Math (pi)

paintShip :: C.Context2D -> Number -> Number -> Number -> Effect Unit
paintShip ctx turns x y = do
    C.translate ctx { translateX: x, translateY: y }
    C.rotate ctx (turns * 2.0 * pi)
    C.beginPath ctx
    C.moveTo ctx 0.0 10.0
    C.lineTo ctx (-5.0) (-5.0)
    C.lineTo ctx 0.0 (-1.0)
    C.lineTo ctx 5.0 (-5.0)
    C.lineTo ctx 0.0 10.0
    C.setStrokeStyle ctx "#AAAAAA"
    C.stroke ctx
    C.setFillStyle ctx "#CCCCCC"
    C.fill ctx
    C.beginPath ctx
    C.setTransform ctx { m11: 1.0, m12: 0.0, m21: 0.0, m22: 1.0, m31: 0.0, m32: 0.0 }

main :: Effect Unit
main =
    C.getCanvasElementById "mycanvas" >>= maybe
        (log "Couldn't find canvas by id")
        (\canvas -> do
            { width, height } <- C.getCanvasDimensions canvas
            ctx <- C.getContext2D canvas
            C.clearRect ctx { x: 0.0, y: 0.0, width, height }
            paintShip ctx 0.1 600.0 250.0)
