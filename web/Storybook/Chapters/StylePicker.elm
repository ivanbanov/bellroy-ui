module Storybook.Chapters.StylePicker exposing (..)

import ElmBook.Actions exposing (mapUpdate)
import ElmBook.Chapter exposing (Chapter, renderStatefulComponentList)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import UI.StylePicker exposing (update, withActiveIndex, withStyles)


type alias Model =
    { basic : UI.StylePicker.Model
    , customActive : UI.StylePicker.Model
    }


type alias SharedState x =
    { x | stylePickerModel : Model }


init : Model
init =
    { basic =
        UI.StylePicker.init
            |> withStyles [ "black", "white", "red", "blue" ]
    , customActive =
        UI.StylePicker.init
            |> withStyles [ "cyan", "magenta", "gold", "black" ]
            |> withActiveIndex 2
    }


chapter : Chapter (SharedState x)
chapter =
    ElmBook.Chapter.chapter "StylePicker"
        |> renderStatefulComponentList
            [ ( "Basic"
              , \{ stylePickerModel } ->
                    stylePickerModel.basic
                        |> UI.StylePicker.view
                        |> Html.map
                            (mapUpdate
                                { fromState = \state -> state.stylePickerModel.basic
                                , toState =
                                    \state newBasic ->
                                        let
                                            model =
                                                state.stylePickerModel
                                        in
                                        { state | stylePickerModel = { model | basic = newBasic } }
                                , update = update
                                }
                            )
              )
            , ( "Custom Active"
              , \{ stylePickerModel } ->
                    stylePickerModel.customActive
                        |> UI.StylePicker.view
                        |> Html.map
                            (mapUpdate
                                { fromState = \state -> state.stylePickerModel.customActive
                                , toState =
                                    \state newCustom ->
                                        let
                                            model =
                                                state.stylePickerModel
                                        in
                                        { state | stylePickerModel = { model | customActive = newCustom } }
                                , update = update
                                }
                            )
              )
            ]
