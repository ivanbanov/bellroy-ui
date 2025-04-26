module Storybook.Chapters.Image exposing (chapter)

import ElmBook.Chapter exposing (Chapter, renderComponentList)
import Html exposing (div)
import Html.Attributes exposing (class)
import UI.Image


chapter : Chapter x
chapter =
    ElmBook.Chapter.chapter "Image"
        |> renderComponentList
            [ ( "Fallback"
              , div [ class "flex gap-4" ]
                    [ UI.Image.view
                        [ class "w-40 h-40" ]
                        "invalid-url.jpg"
                    ]
              )
            , ( "Responsive"
              , div [ class "flex gap-4" ]
                    [ UI.Image.view [] "https://picsum.photos/800/600"
                    ]
              )
            ]
