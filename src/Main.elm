module Main exposing (Model, Msg(..), init, main)

import Browser exposing (UrlRequest(..))
import Browser.Navigation
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
    , routerModel : Routing.Router.Model
    }


initialModel : Url -> Browser.Navigation.Key -> Model
initialModel url navKey =
    { navKey = navKey
    , url = url
    , sharedState = SharedState.init navKey
    , routerModel = Routing.Router.init url
    }


init : () -> Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ url navKey =
    let
        _ =
            Debug.log "init location" (Url.toString url)

        model =
            initialModel url navKey
    in
    ( model
    , Cmd.map RouterMsg <| Routing.Router.newRouteCmd model.routerModel.route
    )


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , onUrlChange = UrlChange
        , onUrlRequest = LinkClicked
        , subscriptions = \_ -> Time.every 10000 TimeChange
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Main msg: " msg of
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
        ( nextRouterModel, routerCmd, sharedStateUpdate ) =
            Routing.Router.update model.sharedState routerMsg model.routerModel

        nextSharedState =
            SharedState.update model.sharedState sharedStateUpdate
    in
    ( { model | sharedState = nextSharedState, routerModel = nextRouterModel }
    , Cmd.map RouterMsg routerCmd
    )


view : Model -> Browser.Document Msg
view model =
    Routing.Router.view RouterMsg model.sharedState model.routerModel
