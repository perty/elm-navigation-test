module Pages.Details exposing (Model, Msg(..), init, update, view)

import Html
import SharedState


type alias Model =
    {}


type Msg
    = NoOp


init : Model
init =
    {}


update : SharedState.SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedState.SharedStateUpdate )
update sharedState msg model =
    ( model, Cmd.none, SharedState.NoUpdate )


view : SharedState.SharedState -> Model -> Html.Html Msg
view sharedState model =
    Html.div []
        [ Html.h1 []
            [ Html.text "Here the details."
            ]
        ]
