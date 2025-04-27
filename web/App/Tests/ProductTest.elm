module App.Tests.ProductTest exposing (tests)

import App.Data.Product exposing (Product(..))
import App.Views.Product exposing (Model, init, update, view)
import Expect
import Html
import Html.Attributes as Attr
import Json.Encode as Encode exposing (Value)
import Test exposing (Test, describe, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import UI.StylePicker as StylePicker



-- TYPES


type Msg
    = Msg App.Views.Product.Msg


type alias Setup =
    { model : Model
    , view : Query.Single Msg
    }



-- SETUP


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



-- SETUP


setup : Setup
setup =
    { model = init
    , view = render init
    }


render : Model -> Query.Single Msg
render model =
    view mock model
        |> Html.map Msg
        |> Query.fromHtml



-- HELPERS


simulateClick : Setup -> Query.Single Msg -> Setup
simulateClick setup_ target =
    let
        simulated =
            Event.simulate Event.click target
    in
    case Event.toResult simulated of
        Ok (Msg msg) ->
            let
                newModel =
                    update msg setup_.model
            in
            { model = newModel
            , view = render newModel
            }

        Err _ ->
            setup_


findOptions : Query.Single msg -> Query.Multiple msg
findOptions =
    Query.findAll [ Selector.attribute (Attr.attribute "role" "option") ]



-- TESTS


tests : Test
tests =
    describe "App.Views.Product"
        [ renderTests
        , stylePickerTests
        ]


renderTests : Test
renderTests =
    describe "Rendering"
        [ test "renders product name" <|
            \_ ->
                setup.view
                    |> Query.has [ Selector.text "Product A" ]
        , test "renders product price" <|
            \_ ->
                setup.view
                    |> Query.has [ Selector.text "€29.99" ]
        , test "renders product description" <|
            \_ ->
                setup.view
                    |> Query.has [ Selector.text "A great product" ]
        ]


stylePickerTests : Test
stylePickerTests =
    describe "StylePicker"
        [ test "renders the style picker with the correct number of styles" <|
            \_ ->
                setup.view
                    |> findOptions
                    -- 4 since style picker adds a default
                    |> Query.count (Expect.equal 4)
        , test "clicking on a style applies the correct color to the product image" <|
            \_ ->
                setup.view
                    |> findOptions
                    |> Query.index 1
                    |> simulateClick setup
                    |> .view
                    |> Query.find [ Selector.attribute (Attr.attribute "data-testid" "product-img") ]
                    |> Query.has [ Selector.attribute (Attr.attribute "style" "--color: red") ]
        ]
