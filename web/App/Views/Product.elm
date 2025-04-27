module App.Views.Product exposing
    ( Model
    , Msg(..)
    , init
    , update
    , view
    )

import App.Data.Product exposing (Product(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import List.Extra
import UI.Card as Card exposing (..)
import UI.Image as Image
import UI.StylePicker as StylePicker exposing (Msg(..), pickIndex)
import UI.Tag as Tag


type alias Model =
    { activeIndex : Int }


init : Model
init =
    { activeIndex = 0 }


type Msg
    = ProductPickStyle (List String) StylePicker.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        ProductPickStyle styles styleMsg ->
            { model | activeIndex = pickIndex styleMsg styles model.activeIndex }


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


view : Product -> Model -> Html Msg
view (Product product) model =
    Card.init
        |> withLevel Level0
        |> Card.view
            [ div [ class "grid grid-rows-[auto_auto_1fr_auto] text-xs" ]
                [ div
                    [ attribute "style" <| "--color: " ++ Maybe.withDefault "" (List.Extra.getAt (model.activeIndex - 1) product.styles)
                    , class "flex aspect-square relative after:content-[''] after:absolute after:inset-0 after:bg-[var(--color)] after:opacity-75 after:mix-blend-color after:pointer-events-none"
                    ]
                    [ Image.view
                        [ class "object-center object-contain w-full"
                        , alt product.name
                        ]
                        product.imageUrl
                    ]
                , div [ class "flex gap-2 mb-2" ]
                    (List.map
                        (\tag ->
                            Tag.init
                                |> Tag.withVariant (Tag.stringToVariant tag)
                                |> Tag.withSize Tag.Small
                                |> Tag.view
                                    (tag
                                        |> Tag.stringToVariant
                                        |> tagVariantToString
                                    )
                        )
                        product.tags
                    )
                , h3
                    [ class "text-gray-700 m-0" ]
                    [ a
                        [ href "#", class "outline-none focus:ring ring-offset-4" ]
                        [ span [ class "text-gray-400" ] [ text (product.name ++ " - " ++ product.showCaseInfo) ] ]
                    ]
                , div [ class "my-1" ]
                    [ text ("€" ++ String.fromFloat product.price) ]
                , div [ class "my-1" ]
                    [ StylePicker.init
                        |> StylePicker.withStyles product.styles
                        |> StylePicker.withActiveIndex model.activeIndex
                        |> StylePicker.view
                        |> Html.map (ProductPickStyle product.styles)
                    ]
                , p
                    [ class "text-gray-400 text-[11px]" ]
                    [ text product.description ]
                ]
            ]
