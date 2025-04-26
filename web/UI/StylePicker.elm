module UI.StylePicker exposing
    ( Model
    , Msg(..)
    , init
    , pickIndex
    , update
    , view
    , withActiveIndex
    , withOnPick
    , withStyles
    )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick)
import Json.Decode as Decode


onKeyDown : (String -> msg) -> Attribute msg
onKeyDown msg =
    on "keydown" (Decode.map msg (Decode.field "key" Decode.string))



-- MODEL


type alias Model =
    { activeIndex : Int
    , styles : List String
    , onPick : Int -> Msg
    }


init : Model
init =
    { onPick = \x -> Pick x
    , styles = []
    , activeIndex = 0
    }


withOnPick : (Int -> Msg) -> Model -> Model
withOnPick onPick model =
    { model | onPick = onPick }


withStyles : List String -> Model -> Model
withStyles styles model =
    { model | styles = styles }


withActiveIndex : Int -> Model -> Model
withActiveIndex index model =
    { model | activeIndex = index }



-- MSG


type Msg
    = Pick Int
    | PickPrevious
    | PickNext


keyToMsg : String -> Msg
keyToMsg key =
    case key of
        "ArrowLeft" ->
            PickPrevious

        "ArrowRight" ->
            PickNext

        _ ->
            Pick -1



-- UPDATE


pickIndex : Msg -> List a -> Int -> Int
pickIndex msg list currentIndex =
    let
        maxIndex =
            List.length list - 1
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
        Pick index ->
            { model | activeIndex = pickIndex msg model.styles model.activeIndex }

        PickPrevious ->
            { model | activeIndex = pickIndex msg model.styles model.activeIndex }

        PickNext ->
            { model | activeIndex = pickIndex msg model.styles model.activeIndex }



-- VIEW


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
            , class "p-2 rounded-full focus-visible:bg-gray-200 outline-none"
            ]
            (List.indexedMap
                (\i item ->
                    span
                        [ class
                            ("cursor-pointer rounded-full w-4 h-4"
                                ++ (if i == model.activeIndex then
                                        " ring-1 ring-gray-500 ring-offset-2"

                                    else
                                        ""
                                   )
                            )
                        , style "background" item
                        , onClick <| Pick i
                        , attribute "role" "option"
                        ]
                        []
                )
                model.styles
            )
