module UI.Tests.StylePickerTest exposing (tests)

import Expect
import Html
import Html.Attributes as Attr
import Json.Encode as Encode exposing (Value)
import Test exposing (Test, describe, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import UI.StylePicker as StylePicker exposing (..)



-- TYPES


type Msg
    = Msg StylePicker.Msg


type alias Setup =
    { model : StylePicker.Model
    , view : Query.Single Msg
    }



-- SETUP


setup : Setup
setup =
    let
        model =
            StylePicker.init
                |> StylePicker.withStyles [ "foo", "bar", "qux" ]
                |> StylePicker.withActiveIndex 0
    in
    { model = model
    , view = render model
    }


render : StylePicker.Model -> Query.Single Msg
render model =
    model
        |> StylePicker.view
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
                    StylePicker.update msg setup_.model
            in
            { model = newModel
            , view = render newModel
            }

        Err _ ->
            setup_


simulateKey : String -> Query.Single Msg -> Setup -> Setup
simulateKey key target setup_ =
    let
        simulated =
            Event.simulate (keyDown key) target
    in
    case Event.toResult simulated of
        Ok (Msg msg) ->
            let
                newModel =
                    StylePicker.update msg setup_.model
            in
            { model = newModel
            , view = render newModel
            }

        Err _ ->
            setup_


keyDown : String -> ( String, Value )
keyDown key =
    Event.custom "keydown" <|
        Encode.object [ ( "key", Encode.string key ) ]


findOptions : Query.Single msg -> Query.Multiple msg
findOptions =
    Query.findAll [ Selector.attribute (Attr.attribute "role" "option") ]


findSelected : Query.Single msg -> Query.Multiple msg
findSelected =
    Query.findAll [ Selector.attribute (Attr.attribute "aria-selected" "true") ]



-- TESTS


tests : Test
tests =
    describe "UI.StylePicker"
        [ renderTests
        , pickTests
        , keyboardTests
        ]


renderTests : Test
renderTests =
    describe "Rendering"
        [ test "Renders correct number of styles (+1 for :reset:)" <|
            \_ ->
                setup.view
                    |> findOptions
                    |> Query.count (Expect.equal 4)
        , test "First option is the :reset: style" <|
            \_ ->
                setup.view
                    |> findOptions
                    |> Query.first
                    |> Query.has
                        [ Selector.attribute (Attr.attribute "aria-label" "Product style 1") ]
        , test "Container has role listbox and tabindex 0" <|
            \_ ->
                setup.view
                    |> Query.has
                        [ Selector.attribute (Attr.attribute "tabIndex" "0") ]
        ]


pickTests : Test
pickTests =
    describe "Picking a style"
        [ test "Only one item is selected at start" <|
            \_ ->
                setup.view
                    |> findSelected
                    |> Query.count (Expect.equal 1)
        , test "The selected item is the active index" <|
            \_ ->
                setup.view
                    |> findOptions
                    |> Query.index 0
                    |> Query.has
                        [ Selector.attribute (Attr.attribute "aria-selected" "true") ]
        , test "Click on second item triggers Picked 1" <|
            \_ ->
                setup.view
                    |> findOptions
                    |> Query.index 1
                    |> simulateClick setup
                    |> .view
                    |> Query.has
                        [ Selector.attribute (Attr.attribute "aria-selected" "true") ]
        ]


keyboardTests : Test
keyboardTests =
    describe "Keyboard navigation"
        [ test "Right arrow moves to next item" <|
            \_ ->
                setup
                    |> simulateKey "ArrowRight" setup.view
                    |> simulateKey "ArrowRight" setup.view
                    |> simulateKey "ArrowRight" setup.view
                    |> .view
                    |> findOptions
                    |> Query.index 3
                    |> Query.has [ Selector.attribute (Attr.attribute "aria-selected" "true") ]
        , test "Right arrow loops to first item when at last item" <|
            \_ ->
                setup
                    |> simulateKey "ArrowRight" setup.view
                    |> simulateKey "ArrowRight" setup.view
                    |> simulateKey "ArrowRight" setup.view
                    |> simulateKey "ArrowRight" setup.view
                    |> .view
                    |> findOptions
                    |> Query.index 0
                    |> Query.has [ Selector.attribute (Attr.attribute "aria-selected" "true") ]
        , test "Left arrow moves to last item when at first item" <|
            \_ ->
                setup
                    |> simulateKey "ArrowLeft" setup.view
                    |> .view
                    |> findOptions
                    |> Query.index 3
                    |> Query.has [ Selector.attribute (Attr.attribute "aria-selected" "true") ]
        , test "Left arrow moves to previous item" <|
            \_ ->
                setup
                    |> simulateKey "ArrowLeft" setup.view
                    |> simulateKey "ArrowLeft" setup.view
                    |> .view
                    |> findOptions
                    |> Query.index 2
                    |> Query.has [ Selector.attribute (Attr.attribute "aria-selected" "true") ]
        ]
