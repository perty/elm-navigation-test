module Routing.Router exposing (Model, Msg(..))

import Pages.Details
import Pages.Home
import Pages.Listing
import Routing.Helpers exposing (Route)
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
