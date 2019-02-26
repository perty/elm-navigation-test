module SharedState exposing (SharedState, SharedStateUpdate(..), init, update)

import Time exposing (Posix)


type alias SharedState =
    { currentTime : Maybe Posix
    }


type SharedStateUpdate
    = NoUpdate
    | UpdateTime Posix


init =
    SharedState Nothing


update : SharedState -> SharedStateUpdate -> SharedState
update sharedState sharedStateUpdate =
    case sharedStateUpdate of
        UpdateTime time ->
            { sharedState | currentTime = Just time }

        NoUpdate ->
            sharedState
