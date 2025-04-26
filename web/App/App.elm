module App.App exposing (main)

import App.Views.ProductsList as AppProductsList
import Browser
import Html exposing (..)
import Html.Attributes exposing (class)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


type Msg
    = ProductsListMsg AppProductsList.Msg


type alias Model =
    { productsList : AppProductsList.Model
    }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        ( productsListModel, productsListCmd ) =
            AppProductsList.init
    in
    ( { productsList = productsListModel }
    , Cmd.map ProductsListMsg productsListCmd
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ProductsListMsg productListMsg ->
            ( { model | productsList = AppProductsList.update productListMsg model.productsList }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    div [ class "container p-4 mx-auto" ]
        [ h1
            [ class "text-4xl font-bold mb-8 container py-8 font-light" ]
            [ text "Shop All Products" ]
        , AppProductsList.view model.productsList
            |> Html.map ProductsListMsg
        ]
