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
    myButtonClickEvent <- eventListener (\_ -> log "You clickedz!")
    maybe
        (log "given element could not be found or it was not a button")
        (addEventListener click myButtonClickEvent false)
        (maybeMyButtonElement >>= fromElement <#> toEventTarget)
