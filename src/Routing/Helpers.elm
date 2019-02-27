module Routing.Helpers exposing (Route(..), parseUrl, reverseRoute, routeParser)

import Url exposing (Url)
import Url.Parser


type Route
    = HomeRoute
    | ListingRoute
    | DetailsRoute
    | NotFoundRoute


reverseRoute : Route -> String
reverseRoute route =
    case route of
        ListingRoute ->
            "#/listing"

        _ ->
            "#/"


routeParser =
    Url.Parser.oneOf
        [ Url.Parser.map HomeRoute Url.Parser.top
        , Url.Parser.map ListingRoute (Url.Parser.s "listing")
        ]


parseUrl : Url -> Route
parseUrl url =
    case url.fragment of
        Nothing ->
            HomeRoute

        Just fragment ->
            { url | path = fragment, fragment = Nothing }
                |> Url.Parser.parse routeParser
                |> Maybe.withDefault NotFoundRoute
