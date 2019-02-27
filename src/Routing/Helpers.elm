module Routing.Helpers exposing (Route(..), parseUrl, reverseRoute, routeParser)

import Url
import Url.Parser


type Route
    = HomeRoute
    | ListingRoute
    | DetailsRoute
    | NotFoundRoute


reverseRoute : Route -> String
reverseRoute route =
    case Debug.log "reverseRoute " route of
        HomeRoute ->
            "/"

        ListingRoute ->
            "#/listing"

        DetailsRoute ->
            "#/details"

        NotFoundRoute ->
            "#/"


routeParser : Url.Parser.Parser (Route -> b) b
routeParser =
    Url.Parser.oneOf
        [ Url.Parser.map HomeRoute Url.Parser.top
        , Url.Parser.map ListingRoute (Url.Parser.s "listing")
        , Url.Parser.map DetailsRoute (Url.Parser.s "details")
        ]


parseUrl : Url.Url -> Route
parseUrl url =
    let
        _ =
            Debug.log "parseUrl" url
    in
    case url.fragment of
        Nothing ->
            HomeRoute

        Just fragment ->
            { url | path = fragment, fragment = Nothing }
                |> Url.Parser.parse routeParser
                |> Maybe.withDefault NotFoundRoute
