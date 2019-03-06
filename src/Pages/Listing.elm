module Pages.Listing exposing (Model, Msg(..), init, update, view)

import Browser.Navigation
import Data
import Html
import Html.Attributes
import Html.Events
import Routing.Helpers
import SharedState


type alias Model =
    { books : List Data.Book
    }


type Msg
    = NavigateTo Int



{-
   For sake of simplicity, the list of books are here already. The Details page shows loading a book.
-}


init : Model
init =
    { books = Data.data
    }


update : SharedState.SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedState.SharedStateUpdate )
update sharedState msg model =
    case msg of
        NavigateTo id ->
            ( model
            , Browser.Navigation.pushUrl sharedState.navKey (Routing.Helpers.reverseRoute (Routing.Helpers.DetailsRoute (Just id)))
            , SharedState.AddVisitedBookId id
            )


view : SharedState.SharedState -> Model -> Html.Html Msg
view sharedState model =
    Html.div []
        ([ SharedState.view sharedState
         , Html.hr [] []
         , headline
         ]
            ++ List.map dataRow model.books
        )


headline =
    Html.h1 []
        [ Html.text "The Listings"
        ]


dataRow : Data.Book -> Html.Html Msg
dataRow data =
    Html.div []
        [ Html.div []
            [ Html.a
                [ Html.Attributes.href ("/details?id=" ++ String.fromInt data.id)
                ]
                [ Html.text data.author.name ]
            , Html.input
                [ Html.Attributes.type_ "button"
                , Html.Events.onClick (NavigateTo data.id)
                , Html.Attributes.value data.title
                ]
                []
            ]
        ]
