module Storybook.Chapters.Card exposing (chapter)

import ElmBook.Chapter exposing (Chapter, renderComponentList)
import Html exposing (div, text)
import Html.Attributes exposing (class)
import UI.Card exposing (init)


cardLevels : List UI.Card.Level
cardLevels =
    [ UI.Card.Level0, UI.Card.Level1, UI.Card.Level2 ]


levelToString : UI.Card.Level -> String
levelToString level =
    case level of
        UI.Card.Level0 ->
            "Flat"

        UI.Card.Level1 ->
            "Level 1"

        UI.Card.Level2 ->
            "Level 2"


chapter : Chapter x
chapter =
    ElmBook.Chapter.chapter "Card"
        |> renderComponentList
            [ ( "Levels"
              , div [ class "flex gap-4" ] <|
                    List.map
                        (\level ->
                            UI.Card.view
                                [ div [ class "flex-1" ] [ text <| levelToString level ] ]
                                { init | level = level }
                        )
                        cardLevels
              )
            ]
