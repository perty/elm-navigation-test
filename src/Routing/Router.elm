module Routing.Router exposing (Model, Msg(..), init, newRouteCmd, update, view)

import Browser
import Html exposing (div)
import Pages.Details
import Pages.Home
import Pages.Listing
import Routing.Helpers exposing (Route(..))
import SharedState
import Url
import Url.Parser


type Page
    = HomePage Pages.Home.Model
    | ListingPage Pages.Listing.Model
    | DetailsPage Pages.Details.Model


type alias Model =
    { route : Routing.Helpers.Route
    , currentPage : Page
    }


init : Url.Url -> Model
init url =
    { route = Maybe.withDefault Routing.Helpers.HomeRoute (Url.Parser.parse Routing.Helpers.routeParser url)
    , currentPage = HomePage Pages.Home.init
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
update sharedState rmsg model =
    case Debug.log "Router page, message "( model.currentPage, rmsg ) of
        ( _, UrlChange location ) ->
            let
                route =
                    Routing.Helpers.parseUrl location
            in
            ( { model
                | currentPage = pageFromRoute route
              }
            , newRouteCmd route
            , SharedState.NoUpdate
            )

        ( HomePage pageModel, HomeMsg msg ) ->
            let
                ( nextModel, cmd, sharedStateUpdate ) =
                    Pages.Home.update sharedState msg pageModel
            in
            ( { model | currentPage = HomePage nextModel }
            , Cmd.map HomeMsg cmd
            , sharedStateUpdate
            )

        ( ListingPage pageModel, ListingMsg msg ) ->
            let
                ( nextModel, cmd, sharedStateUpdate ) =
                    Pages.Listing.update sharedState msg pageModel
            in
            ( { model | currentPage = ListingPage nextModel }
            , Cmd.map ListingMsg cmd
            , sharedStateUpdate
            )

        ( DetailsPage pageModel, DetailMsg msg ) ->
            let
                ( nextModel, cmd, sharedStateUpdate ) =
                    Pages.Details.update sharedState msg pageModel
            in
            ( { model | currentPage = DetailsPage nextModel }
            , Cmd.map DetailMsg cmd
            , sharedStateUpdate
            )

        ( _, _ ) ->
            ( model, Cmd.none, SharedState.NoUpdate )



{-
   updateHome : SharedState.SharedState -> Model -> Pages.Home.Msg -> ( Model, Cmd Msg, SharedState.SharedStateUpdate )
   updateHome sharedState model msg =
       let
           (HomePage pageModel) =
               model.currentPage

           ( nextModel, cmd, sharedStateUpdate ) =
               Pages.Home.update sharedState msg pageModel
       in
       ( { model | currentPage = HomePage nextModel }
       , Cmd.map HomeMsg cmd
       , sharedStateUpdate
       )


   updateListing : SharedState.SharedState -> Model -> Pages.Listing.Msg -> ( Model, Cmd Msg, SharedState.SharedStateUpdate )
   updateListing sharedState model msg =
       let
           (ListingPage pageModel) =
               model.currentPage

           ( nextModel, cmd, sharedStateUpdate ) =
               Pages.Listing.update sharedState msg pageModel
       in
       ( { model | currentPage = ListingPage nextModel }
       , Cmd.map ListingMsg cmd
       , sharedStateUpdate
       )


   updateDetails : SharedState.SharedState -> Model -> Pages.Details.Msg -> ( Model, Cmd Msg, SharedState.SharedStateUpdate )
   updateDetails sharedState model msg =
       let
           (DetailsPage pageModel) =
               model.currentPage

           ( nextModel, cmd, sharedStateUpdate ) =
               Pages.Details.update sharedState msg pageModel
       in
       ( { model | currentPage = DetailsPage nextModel }
       , Cmd.map DetailMsg cmd
       , sharedStateUpdate
       )

-}


pageFromRoute : Route -> Page
pageFromRoute route =
    case route of
        HomeRoute ->
            HomePage Pages.Home.init

        ListingRoute ->
            ListingPage Pages.Listing.init

        DetailsRoute _ ->
            DetailsPage Pages.Details.init

        NotFoundRoute ->
            HomePage Pages.Home.init


view : (Msg -> msg) -> SharedState.SharedState -> Model -> Browser.Document msg
view msgMapper sharedState model =
    let
        title =
            case model.currentPage of
                HomePage _ ->
                    "Home"

                ListingPage _ ->
                    "Listing"

                DetailsPage _ ->
                    "Details"

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
        [ case model.currentPage of
            HomePage pageModel ->
                Pages.Home.view sharedState pageModel |> Html.map HomeMsg

            ListingPage pageModel ->
                Pages.Listing.view sharedState pageModel |> Html.map ListingMsg

            DetailsPage pageModel ->
                Pages.Details.view sharedState pageModel |> Html.map DetailMsg
        ]
