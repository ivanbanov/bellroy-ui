module App exposing (..)

import Browser
import Html exposing (Html, text, div, button)
import Html.Events exposing (onMouseOver, onMouseEnter, onMouseLeave)
import Time

type alias Model =
    { count : Int
    , hovering : Maybe Msg
    }

initialModel : Model
initialModel =
    { count = 0
    , hovering = Nothing
    }

type Msg
    = Increment
    | Decrement
    | StartHovering Msg
    | StopHovering
    | Tick

update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | count = model.count + 1 }

        Decrement ->
            { model | count = model.count - 1 }

        StartHovering hoverMsg ->
            { model | hovering = Just hoverMsg }

        StopHovering ->
            { model | hovering = Nothing }

        Tick ->
            case model.hovering of
                Just hoverMsg ->
                    update hoverMsg model
                Nothing ->
                    model

view : Model -> Html Msg
view model =
    div []
        [ button
            [ onMouseEnter (StartHovering Increment)
            , onMouseLeave StopHovering
            ]
            [ text "+" ]
        , div [] [ text (String.fromInt model.count ++ "1") ]
        , button
            [ onMouseEnter (StartHovering Decrement)
            , onMouseLeave StopHovering
            ]
            [ text "-" ]
        ]

main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initialModel, Cmd.none )
        , view = view
        , update = \msg model -> ( update msg model, Cmd.none )
        , subscriptions = \model ->
            case model.hovering of
                Just _ ->
                    Time.every 500 (\_ -> Tick)
                Nothing ->
                    Sub.none
        }
