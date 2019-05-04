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

    let keyStates = event # filterRepeats # mapKeyStates

    subscribe keyStates logShow <#> const unit

    where
        onKey :: (String -> Effect Unit) -> Event -> Effect Unit
        onKey dispatch e = fromEvent e <#> key # maybe (pure unit) dispatch

        mapKeyStates :: forall e a. IsEvent e => Ord a => e (Either a a) -> e (Set a)
        mapKeyStates e = fold (either delete insert) e empty

        filterRepeats :: forall e a. IsEvent e => Eq a => e a -> e a
        filterRepeats e = withLast e # filter (\{ now, last } -> maybe true (_ /= now) last) <#> _.now
