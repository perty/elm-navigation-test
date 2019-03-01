module SharedState exposing (SharedState, SharedStateUpdate(..), init, update, view)

import Browser.Navigation
import Data
import Html exposing (Html)
import Time


type alias SharedState =
    { currentTime : Maybe Time.Posix
    , navKey : Browser.Navigation.Key
    , visitedBooks : List Int
    }


type SharedStateUpdate
    = NoUpdate
    | UpdateTime Time.Posix
    | AddBookId Int


init : Browser.Navigation.Key -> SharedState
init navKey =
    { currentTime = Nothing
    , navKey = navKey
    , visitedBooks = []
    }


update : SharedState -> SharedStateUpdate -> SharedState
update sharedState sharedStateUpdate =
    case Debug.log "Shared state msg: " sharedStateUpdate of
        UpdateTime time ->
            { sharedState | currentTime = Just time }

        AddBookId id ->
            { sharedState | visitedBooks = id :: sharedState.visitedBooks }

        NoUpdate ->
            sharedState


view : SharedState -> Html msg
view state =
    Html.div []
        [ viewTime state.currentTime
        , viewVisitedBooks state.visitedBooks
        ]


viewTime : Maybe Time.Posix -> Html msg
viewTime time =
    case time of
        Nothing ->
            Html.text "No time yet."

        Just t ->
            Html.text
                ("The time is now: "
                    ++ intToString (Time.toHour Time.utc t)
                    ++ ":"
                    ++ intToString (Time.toMinute Time.utc t)
                    ++ ":"
                    ++ intToString (Time.toSecond Time.utc t)
                    ++ " UTC "
                )


viewVisitedBooks : List Int -> Html msg
viewVisitedBooks bookIds =
    Html.div [] (List.map Data.findById bookIds |> List.map viewVisitedBook)


viewVisitedBook : Maybe Data.Book -> Html msg
viewVisitedBook book =
    Html.div []
        [ case book of
            Nothing ->
                Html.text "book not found"

            Just b ->
                Html.text b.title
        ]


intToString : Int -> String
intToString n =
    if n <= 9 then
        "0" ++ String.fromInt n

    else
        String.fromInt n
