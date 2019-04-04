module Pages.Details exposing (Model, Msg(..), init, initRoute, update, view)

import Browser.Navigation
import Data
import Html
import Html.Attributes
import Html.Events
import Process
import Routing.Helpers
import SharedState
import Task


type DetailsModel
    = Initial
    | NotFound
    | Loaded Data.Book


type alias Model =
    { details : DetailsModel
    }


type Msg
    = LoadBook (Maybe Int)
    | BookLoaded (Result String Data.Book)
    | NavigateToListing


init : Model
init =
    { details = Initial }


initRoute : Maybe Int -> Cmd Msg
initRoute n =
    Task.succeed (LoadBook n) |> Task.perform identity


update : SharedState.SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedState.SharedStateUpdate )
update sharedState msg model =
    case Debug.log "Detail msg: " msg of
        LoadBook n ->
            ( { model | details = Initial }, loadBook n BookLoaded, SharedState.NoUpdate )

        BookLoaded (Ok book) ->
            ( { model | details = Loaded book }, Cmd.none, SharedState.NoUpdate )

        BookLoaded (Err _) ->
            ( { model | details = NotFound }, Cmd.none, SharedState.NoUpdate )

        NavigateToListing ->
            ( model
            , Browser.Navigation.pushUrl sharedState.navKey (Routing.Helpers.routeToString Routing.Helpers.ListingRoute)
            , SharedState.NoUpdate
            )


loadBook : Maybe Int -> (Result String Data.Book -> Msg) -> Cmd Msg
loadBook maybeId msg =
    Task.perform msg <| slow <| Task.succeed (bookLoader maybeId)


slow : Task.Task x a -> Task.Task x a
slow task =
    Process.sleep 1000.0 |> Task.andThen (\_ -> task)


bookLoader : Maybe Int -> Result String Data.Book
bookLoader maybeId =
    case maybeId of
        Nothing ->
            Result.Err <| "No id given."

        Just id ->
            case Data.findById id of
                Nothing ->
                    Result.Err <| "Not found " ++ String.fromInt id

                Just book ->
                    Result.Ok book


view : SharedState.SharedState -> Model -> Html.Html Msg
view shared model =
    case model.details of
        Initial ->
            Html.div []
                [ Html.text "Loading book"
                ]

        NotFound ->
            Html.div []
                [ Html.text "Book not found."
                ]

        Loaded book ->
            Html.div []
                [ SharedState.view shared
                , Html.hr [] []
                , viewDetails book
                , Html.hr [] []
                , viewBottom
                ]


viewDetails : Data.Book -> Html.Html Msg
viewDetails book =
    Html.div []
        [ labelAndText "Author: " book.author.name
        , labelAndText "Title: " book.title
        , labelAndText "Synopsis: " book.synopsis
        , Html.div []
            [ boldSpan "Url: "
            , Html.a [ Html.Attributes.href book.url ]
                [ Html.text book.url
                ]
            ]
        ]


viewBottom : Html.Html Msg
viewBottom =
    Html.div []
        [ Html.input
            [ Html.Attributes.type_ "button"
            , Html.Events.onClick NavigateToListing
            , Html.Attributes.value "Back to listing"
            ]
            []
        ]


labelAndText : String -> String -> Html.Html Msg
labelAndText label s =
    Html.div []
        [ boldSpan label
        , Html.text s
        ]


boldSpan s =
    Html.span [ Html.Attributes.style "font-weight" "bold" ] [ Html.text s ]
