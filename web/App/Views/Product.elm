module App.Views.Product exposing
    ( Msg(..)
    , update
    , view
    )

import App.Data.Product exposing (Product(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import UI.Card as Card exposing (..)
import UI.Image as Image
import UI.StylePicker as StylePicker exposing (pickIndex)
import UI.Tag as Tag


type Msg
    = ProductPickStyle String StylePicker.Msg


update : StylePicker.Msg -> List a -> Int -> Int
update =
    pickIndex


tagVariantToString : Tag.Variant -> String
tagVariantToString level =
    case level of
        Tag.Basic ->
            "Basic"

        Tag.Discount ->
            "Discount"

        Tag.Special ->
            "Special"

        Tag.BestSeller ->
            "Best Seller"


view : Product -> Int -> Html Msg
view (Product product) activeIndex =
    Card.init
        |> withLevel Level0
        |> Card.view
            [ div [ class "grid grid-rows-[auto_auto_1fr_auto] gap-2" ]
                [ div [ class "aspect-square" ]
                    [ Image.view
                        [ class "w-full h-full object-center object-contain max-h-64", alt product.name ]
                        product.imageUrl
                    ]
                , div [ class "flex gap-2" ]
                    (List.map
                        (\tag ->
                            Tag.init
                                |> Tag.withVariant (Tag.stringToVariant tag)
                                |> Tag.view
                                    (tag
                                        |> Tag.stringToVariant
                                        |> tagVariantToString
                                    )
                        )
                        product.tags
                    )
                , h3
                    [ class "text-sm text-[#333]" ]
                    [ a [ href "#", class "outline-none focus:ring ring-offset-4" ] [ text product.name ] ]
                , p
                    [ class "text-gray-600 text-sm" ]
                    [ text product.description ]
                , div
                    [ class "text-gray-400 text-sm" ]
                    [ text ("€" ++ String.fromFloat product.price) ]
                , StylePicker.init
                    |> StylePicker.withStyles product.styles
                    |> StylePicker.withActiveIndex activeIndex
                    |> StylePicker.view
                    |> Html.map (ProductPickStyle product.id)
                ]
            ]
