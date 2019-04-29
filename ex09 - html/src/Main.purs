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
