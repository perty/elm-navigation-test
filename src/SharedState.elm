module SharedState exposing (SharedState, SharedStateUpdate(..), init, update)

import Browser.Navigation
import Time


type alias SharedState =
    { currentTime : Maybe Time.Posix
    , navKey : Browser.Navigation.Key
    }


type SharedStateUpdate
    = NoUpdate
    | UpdateTime Time.Posix


init : Browser.Navigation.Key -> SharedState
init navKey =
    { currentTime = Nothing
    , navKey = navKey
    }


update : SharedState -> SharedStateUpdate -> SharedState
update sharedState sharedStateUpdate =
    case sharedStateUpdate of
        UpdateTime time ->
            { sharedState | currentTime = Just time }

        NoUpdate ->
            sharedState
