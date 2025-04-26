module App.Views.ProductsList exposing
    ( Model
    , Msg(..)
    , init
    , update
    , view
    )

import App.Data.Product exposing (Product(..), ProductId, ProductList, getProducts)
import App.Views.Product as AppProduct exposing (Msg(..))
import Dict exposing (Dict)
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import RemoteData exposing (WebData)


type alias Model =
    { products : WebData ProductList
    , productsState : Dict ProductId AppProduct.Model
    }


init : ( Model, Cmd Msg )
init =
    ( { products = RemoteData.Loading
      , productsState = Dict.empty
      }
    , getProducts GotProducts
    )


type Msg
    = GotProducts (WebData ProductList)
    | ProductMsg ProductId AppProduct.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        ProductMsg productId productMsg ->
            let
                updatedProductState =
                    Dict.get productId model.productsState
                        |> Maybe.map (AppProduct.update productMsg)
                        |> Maybe.withDefault AppProduct.init
            in
            { model
                | productsState = Dict.insert productId updatedProductState model.productsState
            }

        GotProducts data ->
            { model
                | products = data
                , productsState =
                    RemoteData.withDefault [] data
                        |> List.foldl
                            (\(Product product) dict ->
                                Dict.insert product.id AppProduct.init dict
                            )
                            Dict.empty
            }


view : Model -> Html Msg
view model =
    case model.products of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading products..."

        RemoteData.Failure error ->
            div []
                [ text "Failed to load products."
                , text (Debug.toString error)
                ]

        RemoteData.Success products ->
            div []
                [ div
                    [ class "grid gap-1 grid-cols-[repeat(auto-fill,minmax(250px,1fr))]" ]
                    (List.map
                        (\(Product product) ->
                            let
                                activeIndex =
                                    Dict.get product.id model.productsState
                                        |> Maybe.withDefault AppProduct.init
                                        |> .activeIndex
                            in
                            AppProduct.view (Product product) { activeIndex = activeIndex }
                                |> Html.map (ProductMsg product.id)
                        )
                        products
                    )
                ]
