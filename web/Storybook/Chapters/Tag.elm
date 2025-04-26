module Storybook.Chapters.Tag exposing (chapter)

import ElmBook.Chapter exposing (Chapter, renderComponentList)
import Html exposing (div)
import Html.Attributes exposing (class)
import UI.Tag exposing (init)


variants : List UI.Tag.Variant
variants =
    [ UI.Tag.Basic, UI.Tag.Discount, UI.Tag.Special, UI.Tag.BestSeller ]


sizes : List UI.Tag.Size
sizes =
    [ UI.Tag.Small, UI.Tag.Medium, UI.Tag.Large ]


variantToString : UI.Tag.Variant -> String
variantToString level =
    case level of
        UI.Tag.Basic ->
            "Basic"

        UI.Tag.Discount ->
            "Discount"

        UI.Tag.Special ->
            "Special"

        UI.Tag.BestSeller ->
            "Best Seller"


sizeToString : UI.Tag.Size -> String
sizeToString size =
    case size of
        UI.Tag.Small ->
            "Small"

        UI.Tag.Medium ->
            "Medium"

        UI.Tag.Large ->
            "Large"


chapter : Chapter x
chapter =
    ElmBook.Chapter.chapter "Tag"
        |> renderComponentList
            [ ( "Variants"
              , div [ class "flex gap-4" ] <|
                    List.map
                        (\variant -> UI.Tag.view (variantToString variant) { init | variant = variant })
                        variants
              )
            , ( "Sizes"
              , div [ class "flex gap-4 place-items-start" ] <|
                    List.map
                        (\size -> UI.Tag.view (sizeToString size) { init | size = size })
                        sizes
              )
            ]
