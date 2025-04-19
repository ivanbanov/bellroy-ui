module Storybook.Storybook exposing (..)

import ElmBook exposing (..)
import ElmBook.ThemeOptions
import Html exposing (img)
import Html.Attributes exposing (..)
import Storybook.Chapters.Card


main : Book ()
main =
    book "Bellroy"
        |> withThemeOptions
            [ ElmBook.ThemeOptions.subtitle "UI Library"
            , ElmBook.ThemeOptions.logo (img [ src "ASSET_URL:../../assets/logo-owl-white.svg", width 50 ] [])
            ]
        |> withChapters
            [ Storybook.Chapters.Card.chapter
            ]
