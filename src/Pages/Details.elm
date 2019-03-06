module Pages.Details exposing (Model, Msg(..), init, update, view)

import Data
import Html
import Html.Attributes
import SharedState


type DetailsModel
    = Initial
    | NotFound
    | Loaded Data.Book


type alias Model =
    { details : DetailsModel }


type Msg
    = LoadBook (Maybe Int)


init : Model
init =
    { details = Initial }


update : SharedState.SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedState.SharedStateUpdate )
update _ msg model =
    let
        _ =
            Debug.log "Detail msg: " msg
    in
    case msg of
        LoadBook n ->
            ( { model | details = loadBook n }, Cmd.none, SharedState.NoUpdate )


loadBook : Maybe Int -> DetailsModel
loadBook maybeId =
    case maybeId of
        Nothing ->
            NotFound

        Just id ->
            case Data.findById id of
                Nothing ->
                    NotFound

                Just book ->
                    Loaded book


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


labelAndText : String -> String -> Html.Html Msg
labelAndText label s =
    Html.div []
        [ boldSpan label
        , Html.text s
        ]


boldSpan s =
    Html.span [ Html.Attributes.style "font-weight" "bold" ] [ Html.text s ]
