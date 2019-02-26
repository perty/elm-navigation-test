module Pages.Home exposing (Model, Msg(..), update)


type alias Model =
    {}


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
