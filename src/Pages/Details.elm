module Pages.Details exposing (Model, Msg(..), init, update, view)

import Data
import Html
import Html.Attributes
import SharedState


type alias Model =
    { id : Maybe Int }


type Msg
    = NoOp


init : Model
init =
    { id = Nothing }


update : SharedState.SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedState.SharedStateUpdate )
update _ msg model =
    let
        _ =
            Debug.log "Detail msg: " msg
    in
    ( model, Cmd.none, SharedState.NoUpdate )


view : SharedState.SharedState -> Model -> Html.Html Msg
view shared model =
    let
        book =
            Data.findById (Maybe.withDefault 0 model.id)
    in
    Html.div []
        [ SharedState.view shared
        , Html.hr [] []
        , case book of
            Nothing ->
                Html.text "Book not found."

            Just b ->
                viewDetails b
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
