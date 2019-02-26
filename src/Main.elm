module Main exposing (Model, Msg(..), init, main)

import Browser exposing (UrlRequest(..))
import Browser.Navigation
import Html exposing (div)
import Platform exposing (Program)
import Routing.Router
import SharedState
import Time exposing (Posix)
import Url exposing (Url)


type Msg
    = UrlChange Url
    | LinkClicked Browser.UrlRequest
    | TimeChange Posix
    | RouterMsg Routing.Router.Msg


type alias Model =
    { navKey : Browser.Navigation.Key
    , url : Url
    , sharedState : SharedState.SharedState
    }


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , onUrlChange = UrlChange
        , onUrlRequest = LinkClicked
        , subscriptions = \_ -> Time.every 1000 TimeChange
        }


init : () -> Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ url navKey =
    ( { url = url
      , navKey = navKey
      , sharedState = SharedState.init
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TimeChange time ->
            updateTime model time

        UrlChange url ->
            updateRouter { model | url = url } (Routing.Router.UrlChange url)

        RouterMsg routerMsg ->
            updateRouter model routerMsg

        LinkClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model, Browser.Navigation.pushUrl model.navKey (Url.toString url) )

                External url ->
                    ( model, Browser.Navigation.load url )


updateTime : Model -> Posix -> ( Model, Cmd Msg )
updateTime model time =
    ( { model | sharedState = SharedState.update model.sharedState (SharedState.UpdateTime time) }
    , Cmd.none
    )


updateRouter : Model -> Routing.Router.Msg -> ( Model, Cmd Msg )
updateRouter model routerMsg =
    let
        nextSharedState =
            SharedState.update model.sharedState sharedStateUpdate

        ( nextRouterModel, routerCmd, sharedStateUpdate ) =
            Routing.Router.update model.sharedState routerMsg routerModel
    in
    ( { model | sharedState = nextSharedState nextRouterModel }
    , Cmd.map RouterMsg routerCmd
    )


view : Model -> Browser.Document Msg
view model =
    div []
        []
