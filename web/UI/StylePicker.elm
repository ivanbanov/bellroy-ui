module UI.StylePicker exposing
    ( Model
    , Msg(..)
    , init
    , pickIndex
    , update
    , view
    , withActiveIndex
    , withStyles
    )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick)
import Json.Decode as Decode



-- Types


type Msg
    = Pick Int
    | PickPrevious
    | PickNext



-- Model


type alias Model =
    { activeIndex : Int
    , styles : List String
    }


init : Model
init =
    { styles = []
    , activeIndex = 0
    }



-- Builders


withStyles : List String -> Model -> Model
withStyles styles model =
    { model | styles = styles }


withActiveIndex : Int -> Model -> Model
withActiveIndex index model =
    { model | activeIndex = index }



-- Utils


onKeyDown : (String -> msg) -> Attribute msg
onKeyDown msg =
    on "keydown" (Decode.map msg (Decode.field "key" Decode.string))


keyToMsg : String -> Msg
keyToMsg key =
    case key of
        "ArrowLeft" ->
            PickPrevious

        "ArrowRight" ->
            PickNext

        _ ->
            Pick -1



-- Update


pickIndex : Msg -> List a -> Int -> Int
pickIndex msg list currentIndex =
    let
        maxIndex =
            List.length list
    in
    case msg of
        Pick index ->
            if index < 0 then
                currentIndex

            else
                index

        PickPrevious ->
            if currentIndex == 0 then
                maxIndex

            else
                currentIndex - 1

        PickNext ->
            if currentIndex == maxIndex then
                0

            else
                currentIndex + 1


update : Msg -> Model -> Model
update msg model =
    case msg of
        _ ->
            { model | activeIndex = pickIndex msg model.styles model.activeIndex }



-- View


styleView : String -> Bool -> Int -> Html Msg
styleView item active index =
    span
        [ class
            ("cursor-pointer rounded-full w-4 h-4 "
                ++ (if active then
                        " ring-1 ring-gray-500 ring-offset-2"

                    else
                        ""
                   )
            )
        , style "background"
            (if item == ":reset:" then
                " linear-gradient(-45deg, transparent 45%, #000, transparent 55%) , radial-gradient(circle at center, #fff 60%, #777 10%)"

             else
                item
            )
        , onClick <| Pick index
        , attribute "role" "option"
        , attribute "aria-selected"
            (if active then
                "true"

             else
                "false"
            )
        , attribute "aria-label" ("Product style " ++ String.fromInt (index + 1))
        ]
        []


view : Model -> Html Msg
view model =
    if List.isEmpty model.styles then
        text ""

    else
        div
            [ class "flex gap-3"
            , tabindex 0
            , onKeyDown keyToMsg
            , attribute "role" "listbox"
            , class "p-2 rounded-full focus-visible:bg-[#fdfdfd] focus-visible:border focus-visible:border-[#f0f0f0] focus-visible:-m-[1px] outline-none"
            ]
            (List.indexedMap
                (\i item -> styleView item (i == model.activeIndex) i)
                (":reset:" :: model.styles)
            )
