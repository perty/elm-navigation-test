module Pages.Listing exposing (Model, Msg(..), init, update, view)

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
            Debug.log "Listing navigate to "
                ( model
                , Browser.Navigation.pushUrl sharedState.navKey (Routing.Helpers.reverseRoute route)
                , SharedState.NoUpdate
                )


view : SharedState.SharedState -> Model -> Html.Html Msg
view sharedState model =
    Html.div []
        [ Html.input
            [ Html.Attributes.type_ "button"
            , Html.Events.onClick (NavigateTo Routing.Helpers.DetailsRoute)
            , Html.Attributes.value "Click this to go to details."
            ]
            []
        ]
