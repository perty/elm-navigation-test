module Routing.Router exposing (Model, Msg(..), update)

import Browser.Navigation
import Pages.Details
import Pages.Home
import Pages.Listing
import Routing.Helpers exposing (Route)
import SharedState
import Url exposing (Url)


type alias Model =
    { homeModel : Pages.Home.Model
    , listingModel : Pages.Listing.Model
    , detailsModel : Pages.Details.Model
    , route : Route
    }


type Msg
    = UrlChange Url
    | NavigateTo Route
    | HomeMsg Pages.Home.Msg
    | ListingMsg Pages.Listing.Msg
    | DetailMsg Pages.Details.Msg


update : SharedState.SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedState.SharedStateUpdate )
update sharedState msg model =
    case msg of
        UrlChange location ->
            ( { model | route = Routing.Helpers.parseUrl location }
            , Cmd.none
            , SharedState.NoUpdate
            )

        NavigateTo route ->
            ( model
            , Browser.Navigation.pushUrl sharedState.navKey (Routing.Helpers.reverseRoute route)
            , SharedState.NoUpdate
            )

        HomeMsg homeMsg ->
            updateHome model homeMsg

        ListingMsg listingMsg ->
            updateListing model listingMsg

        DetailMsg detailMsg ->
            updateDetails model detailMsg


updateHome : Model -> Pages.Home.Msg -> ( Model, Cmd Msg, SharedState.SharedStateUpdate )
updateHome model homeMsg =
    let
        ( nextHomeModel, homeCmd ) =
            Pages.Home.update homeMsg model.homeModel
    in
    ( { model | homeModel = nextHomeModel }
    , Cmd.map HomeMsg homeCmd
    , SharedState.NoUpdate
    )


updateListing : Model -> Pages.Listing.Msg -> ( Model, Cmd Msg, SharedState.SharedStateUpdate )
updateListing model homeMsg =
    ( model, Cmd.none, SharedState.NoUpdate )


updateDetails : Model -> Pages.Details.Msg -> ( Model, Cmd Msg, SharedState.SharedStateUpdate )
updateDetails model detailMsg =
    ( model, Cmd.none, SharedState.NoUpdate )
