module App.Tests.ProductsListTest exposing (tests)

import App.Data.Product exposing (Product(..), ProductId)
import App.Views.Product
import App.Views.ProductsList exposing (Msg(..), init, update, view)
import Dict exposing (Dict)
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


mockProductDict : Dict ProductId Product
mockProductDict =
    Dict.fromList
        [ ( "foo", mock )
        , ( "bar", mock )
        ]


tests : Test
tests =
    describe "App.Views.ProductsList"
        [ test "GotProducts success updates products and initializes product states" <|
            \_ ->
                let
                    ( model, _ ) =
                        init

                    updatedModel =
                        update (GotProducts (RemoteData.Success mockProductDict)) model

                    expected =
                        RemoteData.Success
                            (Dict.map
                                (\_ product ->
                                    { product = product
                                    , state = App.Views.Product.init
                                    }
                                )
                                mockProductDict
                            )
                in
                Expect.equal updatedModel.products expected
        , test "view renders loading text when products are loading" <|
            \_ ->
                view
                    { products = RemoteData.Loading }
                    |> Query.fromHtml
                    |> Query.has [ Selector.text "Loading products..." ]
        , test "view renders failure message when products failed to load" <|
            \_ ->
                view
                    { products = RemoteData.Failure NetworkError }
                    |> Query.fromHtml
                    |> Query.has [ Selector.text "Failed to load products." ]
        , test "view renders products when success" <|
            \_ ->
                let
                    products =
                        Dict.fromList
                            [ ( "foo", { product = mock, state = App.Views.Product.init } )
                            , ( "bar", { product = mock, state = App.Views.Product.init } )
                            ]
                in
                view { products = RemoteData.Success products }
                    |> Query.fromHtml
                    |> Query.findAll [ Selector.attribute (Attr.attribute "data-testid" "product") ]
                    |> Query.count (Expect.equal 2)
        ]
