module Pages.Home exposing (Model, Msg, init, update, view)

import Browser.Navigation
import Html
import Html.Attributes
import Html.Events
import Routing.Helpers
import SharedState


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
view sharedState _ =
    Html.div []
        [ SharedState.view sharedState
        , Html.hr [] []
        , Html.h1 [] [ Html.text "This is the home page. " ]
        , Html.input
            [ Html.Attributes.type_ "button"
            , Html.Events.onClick (NavigateTo Routing.Helpers.ListingRoute)
            , Html.Attributes.value "Click this to go to listings."
            ]
            []
        ]
