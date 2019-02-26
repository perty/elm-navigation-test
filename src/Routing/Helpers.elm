module Routing.Helpers exposing (Route(..), parseUrl, reverseRoute, routeParser)

import Url.Parser


type Route
    = HomeRoute
    | SettingsRoute
    | NotFoundRoute


reverseRoute : Route -> String
reverseRoute route =
    case route of
        SettingsRoute ->
            "#/settings"

        _ ->
            "#/"


routeParser =
    Url.Parser.oneOf
        [ Url.Parser.map HomeRoute Url.Parser.top
        , Url.Parser.map SettingsRoute (Url.Parser.s "settings")
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
