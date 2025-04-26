module UI.Card exposing
    ( CardConfig
    , Level(..)
    , init
    , view
    , withLevel
    )

import Html exposing (..)
import Html.Attributes exposing (class)


type Level
    = Level0
    | Level1
    | Level2


type alias CardConfig =
    { level : Level }


init : CardConfig
init =
    { level = Level1 }


withLevel : Level -> CardConfig -> CardConfig
withLevel level config =
    { config | level = level }


getLevelClass : Level -> String
getLevelClass level =
    case level of
        Level0 ->
            ""

        Level1 ->
            "shadow-md"

        Level2 ->
            "shadow-xl"


cardClasses : String
cardClasses =
    "bg-[#f6f6f6] p-4"


view : List (Html msg) -> CardConfig -> Html msg
view html config =
    div
        [ class (cardClasses ++ " " ++ getLevelClass config.level)
        ]
        html
