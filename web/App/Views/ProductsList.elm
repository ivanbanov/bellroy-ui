module App.Views.ProductsList exposing
    ( Model
    , Msg(..)
    , ProductsList
    , init
    , update
    , view
    )

import App.Data.Product exposing (Product(..), ProductId, getProducts)
import App.Views.Product as AppProduct exposing (Msg(..))
import Dict exposing (Dict)
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import RemoteData exposing (WebData)



-- Types


type alias ProductsList =
    Dict ProductId { product : Product, state : AppProduct.Model }


type Msg
    = GotProducts (WebData App.Data.Product.ProductsList)
    | ProductMsg ProductId AppProduct.Msg



-- Model


type alias Model =
    { products : WebData (Dict ProductId { product : Product, state : AppProduct.Model })
    }


init : ( Model, Cmd Msg )
init =
    ( { products = RemoteData.Loading }
    , getProducts GotProducts
    )



-- Update


update : Msg -> Model -> Model
update msg model =
    case msg of
        ProductMsg productId productMsg ->
            { model
                | products =
                    RemoteData.map
                        (\products ->
                            case Dict.get productId products of
                                Just product ->
                                    Dict.insert productId
                                        { product = product.product
                                        , state = AppProduct.update productMsg product.state
                                        }
                                        products

                                Nothing ->
                                    products
                        )
                        model.products
            }

        GotProducts data ->
            { model
                | products =
                    RemoteData.map
                        (\products ->
                            Dict.map
                                (\_ product ->
                                    { product = product
                                    , state = AppProduct.init
                                    }
                                )
                                products
                        )
                        data
            }



-- View


view : Model -> Html Msg
view model =
    case model.products of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading products..."

        RemoteData.Failure _ ->
            div []
                [ text "Failed to load products."
                ]

        RemoteData.Success products ->
            div []
                [ div
                    [ class "grid gap-1 grid-cols-2 lg:grid-cols-[repeat(auto-fill,minmax(250px,1fr))]" ]
                    (Dict.toList
                        (Dict.map
                            (\id { product, state } ->
                                AppProduct.view product state
                                    |> Html.map (ProductMsg id)
                            )
                            products
                        )
                        |> List.map Tuple.second
                    )
                ]
