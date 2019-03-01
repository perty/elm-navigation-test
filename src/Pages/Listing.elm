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
    = NavigateTo Routing.Helpers.Route


init : Model
init =
    { books = Data.data
    }


update : SharedState.SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedState.SharedStateUpdate )
update sharedState msg model =
    case msg of
        NavigateTo route ->
            ( model
            , Browser.Navigation.pushUrl sharedState.navKey (Routing.Helpers.reverseRoute route)
            , SharedState.NoUpdate
            )


view : SharedState.SharedState -> Model -> Html.Html Msg
view _ model =
    Html.div []
        ([ Html.h1 []
            [ Html.text "The Listings"
            ]
         ]
            ++ List.map dataRow model.books
        )


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
                , Html.Events.onClick (NavigateTo (Routing.Helpers.DetailsRoute (Just data.id)))
                , Html.Attributes.value data.title
                ]
                []
            ]
        ]
