module Main where

import Prelude

import Data.Maybe (Maybe(..))
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
    case maybeMyButtonElement >>= fromElement <#> toEventTarget of
        Nothing -> log "given element could not be found or it was not a button"
        Just myButtonEventTarget -> do
            myButtonClickEvent <- eventListener (\_ -> log "You clicked!")
            addEventListener click myButtonClickEvent false myButtonEventTarget
