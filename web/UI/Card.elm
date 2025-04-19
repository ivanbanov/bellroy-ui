module UI.Card exposing (render)

import Html exposing (..)
import Html.Attributes exposing (class)


render : Html msg
render =
    div
        [ class "bg-white rounded-lg shadow-md p-5 m-5 max-w-[300px]"
        ]
        [ h2
            [ class "mb-2.5 text-gray-800"
            ]
            [ text "Card Title" ]
        , p
            [ class "text-gray-600 leading-relaxed"
            ]
            [ text "This is a simple card component built with Elm using inline styles." ]
        ]
