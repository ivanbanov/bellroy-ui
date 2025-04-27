module App.Tests.ProductsListTest exposing (tests)

import App.Data.Product exposing (Product(..), ProductList)
import App.Views.ProductsList as ProductsList exposing (..)
import Dict
import Expect
import Html.Attributes as Attr
import Http exposing (Error(..))
import RemoteData
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


mock : Product
mock =
    Product
        { id = "123-xxx"
        , name = "Product A"
        , description = "A great product"
        , price = 29.99
        , imageUrl = "https://example.com/image.jpg"
        , tags = [ "Special", "Discount" ]
        , styles = [ "red", "green", "blue" ]
        , showCaseInfo = "lorem ipsum dolor sit amet"
        }


tests : Test
tests =
    describe "App.Views.ProductsList"
        [ test "GotProducts success updates products and initializes product states" <|
            \_ ->
                let
                    productList : ProductList
                    productList =
                        [ mock, mock ]

                    ( model, _ ) =
                        ProductsList.init

                    updatedModel =
                        update (GotProducts (RemoteData.Success productList)) model
                in
                Expect.equal updatedModel.products (RemoteData.Success productList)
        , test "view renders loading text when products are loading" <|
            \_ ->
                view
                    { products = RemoteData.Loading
                    , productsState = Dict.empty
                    }
                    |> Query.fromHtml
                    |> Query.has [ Selector.text "Loading products..." ]
        , test "view renders failure message when products failed to load" <|
            \_ ->
                view
                    { products = RemoteData.Failure NetworkError
                    , productsState = Dict.empty
                    }
                    |> Query.fromHtml
                    |> Query.has [ Selector.text "Failed to load products." ]
        , test "view renders products when success" <|
            \_ ->
                view
                    { products = RemoteData.Success [ mock, mock ]
                    , productsState = Dict.empty
                    }
                    |> Query.fromHtml
                    |> Query.findAll [ Selector.attribute (Attr.attribute "data-testid" "product") ]
                    |> Query.count (Expect.equal 2)
        ]
