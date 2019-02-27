module Pages.Home exposing (Model, Msg, init, update, view)

import Browser.Navigation
import Html
import Html.Attributes
import Html.Events
import Routing.Helpers
import SharedState
import Time


type alias Model =
    {}


type Msg
    = NavigateTo Routing.Helpers.Route


init : Model
init =
    {}


update : SharedState.SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedState.SharedStateUpdate )
update sharedState msg model =
    case msg of
        NavigateTo route ->
            Debug.log "Home navigate to "
                ( model
                , Browser.Navigation.pushUrl sharedState.navKey (Routing.Helpers.reverseRoute route)
                , SharedState.NoUpdate
                )


view : SharedState.SharedState -> Model -> Html.Html Msg
view sharedState model =
    Html.div []
        [ Html.text "This is the home page. "
        , case sharedState.currentTime of
            Nothing ->
                Html.text "No time yet."

            Just t ->
                Html.text
                    ("The time is now: "
                        ++ String.fromInt (Time.toHour Time.utc t)
                        ++ ":"
                        ++ String.fromInt (Time.toMinute Time.utc t)
                        ++ ":"
                        ++ String.fromInt (Time.toSecond Time.utc t)
                        ++ " UTC "
                    )
        , Html.input
            [ Html.Attributes.type_ "button"
            , Html.Events.onClick (NavigateTo Routing.Helpers.ListingRoute)
            , Html.Attributes.value "Click this to go to listings."
            ]
            []
        ]
