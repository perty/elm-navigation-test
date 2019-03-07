module Routing.Helpers exposing (Route(..), parseUrl, routeParser, routeToString)

import Url
import Url.Parser exposing ((<?>))
import Url.Parser.Query


type Route
    = HomeRoute
    | ListingRoute
    | DetailsRoute (Maybe Int)
    | NotFoundRoute


routeToString : Route -> String
routeToString route =
    case Debug.log "reverseRoute " route of
        HomeRoute ->
            "/"

        ListingRoute ->
            "listing"

        DetailsRoute n ->
            "details?id=" ++ String.fromInt (Maybe.withDefault 0 n)

        NotFoundRoute ->
            "/"


routeParser : Url.Parser.Parser (Route -> b) b
routeParser =
    Url.Parser.oneOf
        [ Url.Parser.map HomeRoute Url.Parser.top
        , Url.Parser.map ListingRoute (Url.Parser.s "listing")
        , Url.Parser.map DetailsRoute detailsParser
        ]


detailsParser : Url.Parser.Parser (Maybe Int -> a) a
detailsParser =
    Url.Parser.s "details" <?> Url.Parser.Query.int "id"


parseUrl : Url.Url -> Route
parseUrl url =
    let
        _ =
            Debug.log "parseUrl" url
    in
    Url.Parser.parse routeParser url |> Maybe.withDefault NotFoundRoute
