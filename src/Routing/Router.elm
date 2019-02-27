module Routing.Router exposing (Model, Msg(..), init, update, view)

import Browser
import Browser.Navigation
import Html exposing (div)
import Pages.Details
import Pages.Home
import Pages.Listing
import Routing.Helpers
import SharedState
import Url


type alias Model =
    { route : Routing.Helpers.Route
    , homeModel : Pages.Home.Model
    , listingModel : Pages.Listing.Model
    , detailsModel : Pages.Details.Model
    }


init : Model
init =
    { route = Routing.Helpers.HomeRoute
    , homeModel = Pages.Home.init
    , listingModel = Pages.Listing.init
    , detailsModel = Pages.Details.init
    }


type Msg
    = UrlChange Url.Url
    | NavigateTo Routing.Helpers.Route
    | HomeMsg Pages.Home.Msg
    | ListingMsg Pages.Listing.Msg
    | DetailMsg Pages.Details.Msg


update : SharedState.SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedState.SharedStateUpdate )
update sharedState msg model =
    case Debug.log "Router msg: " msg of
        UrlChange location ->
            ( { model | route = Routing.Helpers.parseUrl location }
            , Cmd.none
            , SharedState.NoUpdate
            )

        NavigateTo route ->
            Debug.log "Router navigate to "
                ( model
                , Browser.Navigation.pushUrl sharedState.navKey (Routing.Helpers.reverseRoute route)
                , SharedState.NoUpdate
                )

        HomeMsg homeMsg ->
            updateHome sharedState model homeMsg

        ListingMsg listingMsg ->
            updateListing sharedState model listingMsg

        DetailMsg detailMsg ->
            updateDetails sharedState model detailMsg


updateHome : SharedState.SharedState -> Model -> Pages.Home.Msg -> ( Model, Cmd Msg, SharedState.SharedStateUpdate )
updateHome sharedState model msg =
    let
        ( nextModel, cmd, sharedStateUpdate ) =
            Pages.Home.update sharedState msg model.homeModel
    in
    ( { model | homeModel = nextModel }
    , Cmd.map HomeMsg cmd
    , sharedStateUpdate
    )


updateListing : SharedState.SharedState -> Model -> Pages.Listing.Msg -> ( Model, Cmd Msg, SharedState.SharedStateUpdate )
updateListing sharedState model listingMsg =
    ( model, Cmd.none, SharedState.NoUpdate )


updateDetails : SharedState.SharedState -> Model -> Pages.Details.Msg -> ( Model, Cmd Msg, SharedState.SharedStateUpdate )
updateDetails sharedState model detailMsg =
    ( model, Cmd.none, SharedState.NoUpdate )


view : (Msg -> msg) -> SharedState.SharedState -> Model -> Browser.Document msg
view msgMapper sharedState model =
    let
        title =
            case model.route of
                Routing.Helpers.HomeRoute ->
                    "Home"

                Routing.Helpers.ListingRoute ->
                    "Listing"

                Routing.Helpers.DetailsRoute ->
                    "Details"

                Routing.Helpers.NotFoundRoute ->
                    "Not found"

        body =
            div []
                [ pageView sharedState model ]
    in
    { title = title
    , body =
        [ body
            |> Html.map msgMapper
        ]
    }


pageView : SharedState.SharedState -> Model -> Html.Html Msg
pageView sharedState model =
    Html.div []
        [ case model.route of
            Routing.Helpers.HomeRoute ->
                Pages.Home.view sharedState model.homeModel |> Html.map HomeMsg

            Routing.Helpers.ListingRoute ->
                Pages.Listing.view sharedState model.listingModel |> Html.map ListingMsg

            Routing.Helpers.DetailsRoute ->
                Pages.Details.view sharedState model.detailsModel |> Html.map DetailMsg

            Routing.Helpers.NotFoundRoute ->
                Html.h1 [] [ Html.text "404 :(" ]
        ]
