module Storybook.Chapters.Card exposing (chapter)

import ElmBook.Chapter exposing (Chapter, renderComponentList)
import UI.Card


chapter : Chapter x
chapter =
    ElmBook.Chapter.chapter "Card"
        |> renderComponentList
            [ ( "Default", UI.Card.render )
            ]
