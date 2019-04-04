module Routing.Router exposing (Model, Msg(..), init, newRouteCmd, update, view)

import Browser
import Html exposing (div)
import Pages.Details
import Pages.Home
import Pages.Listing
import Routing.Helpers
import SharedState
import Url
import Url.Parser


type alias Model =
    { route : Routing.Helpers.Route
    , homeModel : Pages.Home.Model
    , listingModel : Pages.Listing.Model
    , detailsModel : Pages.Details.Model
    }


init : Url.Url -> Model
init url =
    { route = Maybe.withDefault Routing.Helpers.HomeRoute (Url.Parser.parse Routing.Helpers.routeParser url)
    , homeModel = Pages.Home.init
    , listingModel = Pages.Listing.init
    , detailsModel = Pages.Details.init
    }



{-
   A change of the route may require some tasks to be done, e.g. load a book given the id.
   Also called from the Main.init function so we can do what is needed when we land on an URL
   other than the top one. This makes it possible to bookmark a page.
-}


newRouteCmd : Routing.Helpers.Route -> Cmd Msg
newRouteCmd route =
    case route of
        Routing.Helpers.DetailsRoute n ->
            Cmd.map DetailMsg (Pages.Details.initRoute n)

        _ ->
            Cmd.none


type Msg
    = UrlChange Url.Url
    | HomeMsg Pages.Home.Msg
    | ListingMsg Pages.Listing.Msg
    | DetailMsg Pages.Details.Msg


update : SharedState.SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedState.SharedStateUpdate )
update sharedState msg model =
    case Debug.log "Router msg: " msg of
        UrlChange location ->
            let
                route =
                    Routing.Helpers.parseUrl location
            in
            ( { model | route = route }
            , newRouteCmd route
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
updateListing sharedState model msg =
    let
        ( nextModel, cmd, sharedStateUpdate ) =
            Pages.Listing.update sharedState msg model.listingModel
    in
    ( { model | listingModel = nextModel }
    , Cmd.map ListingMsg cmd
    , sharedStateUpdate
    )


updateDetails : SharedState.SharedState -> Model -> Pages.Details.Msg -> ( Model, Cmd Msg, SharedState.SharedStateUpdate )
updateDetails sharedState model msg =
    let
        ( nextModel, cmd, sharedStateUpdate ) =
            Pages.Details.update sharedState msg model.detailsModel
    in
    ( { model | detailsModel = nextModel }
    , Cmd.map DetailMsg cmd
    , sharedStateUpdate
    )


view : (Msg -> msg) -> SharedState.SharedState -> Model -> Browser.Document msg
view msgMapper sharedState model =
    let
        title =
            case model.route of
                Routing.Helpers.HomeRoute ->
                    "Home"

                Routing.Helpers.ListingRoute ->
                    "Listing"

                Routing.Helpers.DetailsRoute n ->
                    "Details for id " ++ String.fromInt (Maybe.withDefault 0 n)

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

            Routing.Helpers.DetailsRoute _ ->
                Pages.Details.view sharedState model.detailsModel |> Html.map DetailMsg

            Routing.Helpers.NotFoundRoute ->
                Html.h1 [] [ Html.text "Page not found." ]
        ]
