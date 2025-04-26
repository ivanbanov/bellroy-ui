module App.Views.ProductsList exposing
    ( Model
    , Msg(..)
    , init
    , update
    , view
    )

import App.Data.Product exposing (Product(..), ProductList, getProducts)
import App.Views.Product as AppProduct exposing (Msg(..))
import Dict exposing (Dict)
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import RemoteData exposing (WebData)


type alias Model =
    { products : WebData ProductList
    , activeProductsStyle : Dict String Int
    }


init : ( Model, Cmd Msg )
init =
    ( { products = RemoteData.NotAsked
      , activeProductsStyle = Dict.empty
      }
    , getProducts GotProducts
    )


type Msg
    = GotProducts (WebData ProductList)
    | ProductMsg AppProduct.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        ProductMsg productMsg ->
            case productMsg of
                ProductPickStyle productId pickMsg ->
                    let
                        currentIndex =
                            Maybe.withDefault 0 <| Dict.get productId model.activeProductsStyle

                        listOfStyles =
                            RemoteData.withDefault [] model.products
                                |> List.map (\(Product p) -> ( p.id, p.styles ))
                                |> Dict.fromList
                                |> Dict.get productId
                                |> Maybe.withDefault []
                    in
                    { model
                        | activeProductsStyle =
                            Dict.insert productId
                                (AppProduct.update pickMsg listOfStyles currentIndex)
                                model.activeProductsStyle
                    }

        GotProducts data ->
            { model
                | products = data
                , activeProductsStyle =
                    RemoteData.withDefault [] data
                        |> List.foldl (\(Product product) dict -> Dict.insert product.id 0 dict) Dict.empty
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
                                    Dict.get product.id model.activeProductsStyle
                                        |> Maybe.withDefault 0
                            in
                            AppProduct.view (Product product) activeIndex
                                |> Html.map ProductMsg
                        )
                        products
                    )
                ]
