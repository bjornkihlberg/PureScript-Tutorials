module Main where

import Prelude

import Data.Either (Either(..), either)
import Data.Filterable (filter)
import Data.Maybe (maybe)
import Data.Set (Set, delete, empty, insert)
import Effect (Effect)
import Effect.Console (logShow)
import FRP.Event (class IsEvent, create, fold, subscribe, withLast)
import Web.Event.EventTarget (addEventListener, eventListener)
import Web.Event.Internal.Types (Event)
import Web.HTML (window)
import Web.HTML.Window (toEventTarget)
import Web.UIEvent.KeyboardEvent (fromEvent, key)
import Web.UIEvent.KeyboardEvent.EventTypes (keydown, keyup)

main :: Effect Unit
main = do
    { event, push } <- create
    
    onKeyDownEvent <- eventListener $ onKey (Right >>> push)
    onKeyUpEvent   <- eventListener $ onKey (Left  >>> push)

    window <#> toEventTarget >>= addEventListener keydown onKeyDownEvent false
    window <#> toEventTarget >>= addEventListener keyup   onKeyUpEvent   false

    let keyStates = event # mapKeyStates # filterRepeats

    subscribe keyStates logShow <#> const unit

    where
        onKey :: (String -> Effect Unit) -> Event -> Effect Unit
        onKey dispatch e = fromEvent e <#> key # maybe (pure unit) dispatch

        mapKeyStates :: forall e. IsEvent e => e (Either String String) -> e (Set String)
        mapKeyStates e = fold (either delete insert) e empty

        filterRepeats :: forall e. IsEvent e => e (Set String) -> e (Set String)
        filterRepeats e = withLast e # filter (\{ now, last } -> maybe true (_ /= now) last) <#> _.now
