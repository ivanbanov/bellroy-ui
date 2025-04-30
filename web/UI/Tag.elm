module UI.Tag exposing
    ( Size(..)
    , TagConfig
    , Variant(..)
    , init
    , stringToVariant
    , view
    , withSize
    , withVariant
    )

import Html exposing (..)
import Html.Attributes exposing (class)



-- Types


type Variant
    = Basic
    | Discount
    | Special
    | BestSeller


type Size
    = Small
    | Medium
    | Large



-- Model


type alias TagConfig =
    { variant : Variant
    , size : Size
    }


init : TagConfig
init =
    { variant = Basic
    , size = Small
    }



-- Builders


withVariant : Variant -> TagConfig -> TagConfig
withVariant variant config =
    { config | variant = variant }


withSize : Size -> TagConfig -> TagConfig
withSize size config =
    { config | size = size }



-- Utils


stringToVariant : String -> Variant
stringToVariant string =
    case String.toLower string of
        "basic" ->
            Basic

        "discount" ->
            Discount

        "special" ->
            Special

        "bestseller" ->
            BestSeller

        _ ->
            Basic


getVariantClass : Variant -> String
getVariantClass variant =
    case variant of
        Basic ->
            "bg-gray-200 text-black"

        Discount ->
            "bg-orange-700 text-white"

        Special ->
            "bg-black text-white"

        BestSeller ->
            "bg-white text-orange-700 border border-gray-100"


getSizeClass : Size -> String
getSizeClass size =
    case size of
        Small ->
            "text-[10px]"

        Medium ->
            "text-sm"

        Large ->
            "text-base"


labelClasses : String
labelClasses =
    "px-2 py-1 rounded inline-flex"



-- View


view : String -> TagConfig -> Html msg
view text_ config =
    span
        [ class <|
            String.join " "
                [ labelClasses
                , getVariantClass config.variant
                , getSizeClass config.size
                ]
        ]
        [ text text_ ]
