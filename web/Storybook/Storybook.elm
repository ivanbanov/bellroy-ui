module Storybook.Storybook exposing (..)

import ElmBook exposing (..)
import ElmBook.StatefulOptions
import ElmBook.ThemeOptions
import Html exposing (img)
import Html.Attributes exposing (..)
import Storybook.Chapters.Card
import Storybook.Chapters.Image
import Storybook.Chapters.StylePicker
import Storybook.Chapters.Tag
import VitePluginHelper


type alias SharedState =
    { stylePickerModel : Storybook.Chapters.StylePicker.Model
    }


initialState : SharedState
initialState =
    { stylePickerModel = Storybook.Chapters.StylePicker.init
    }


main : Book SharedState
main =
    book "Bellroy"
        |> withThemeOptions
            [ ElmBook.ThemeOptions.subtitle "UI Library"
            , ElmBook.ThemeOptions.logo
                (img
                    [ src (VitePluginHelper.asset "../../assets/logo-owl-white.svg")
                    , width 50
                    ]
                    []
                )
            ]
        |> withStatefulOptions
            [ ElmBook.StatefulOptions.initialState initialState
            ]
        |> withChapters
            [ Storybook.Chapters.Card.chapter
            , Storybook.Chapters.Image.chapter
            , Storybook.Chapters.StylePicker.chapter
            , Storybook.Chapters.Tag.chapter
            ]
