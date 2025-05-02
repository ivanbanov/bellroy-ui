module App.Data.Product exposing
    ( Product(..)
    , ProductData
    , ProductId
    , ProductsList
    , getProducts
    , productDecoder
    , productsDecoder
    )

import Dict exposing (Dict)
import Http
import Json.Decode exposing (Decoder, float, list, string)
import Json.Decode.Pipeline exposing (required)
import RemoteData exposing (WebData)



-- Types


type Product
    = Product ProductData


type alias ProductsList =
    Dict ProductId Product


type alias ProductId =
    String


type alias ProductData =
    { id : ProductId
    , name : String
    , description : String
    , showCaseInfo : String
    , price : Float
    , imageUrl : String
    , styles : List String
    , tags : List String
    }



-- Decoders


productDecoder : Decoder Product
productDecoder =
    Json.Decode.succeed ProductData
        |> required "id" string
        |> required "name" string
        |> required "description" string
        |> required "showCaseInfo" string
        |> required "price" float
        |> required "imageUrl" string
        |> required "styles" (list string)
        |> required "tags" (list string)
        |> Json.Decode.map Product


productsDecoder : Decoder ProductsList
productsDecoder =
    Json.Decode.list productDecoder
        |> Json.Decode.map (List.map (\(Product data) -> ( data.id, Product data )) >> Dict.fromList)



-- API


getProducts : (WebData ProductsList -> msg) -> Cmd msg
getProducts msg =
    Http.get
        { url = "https://bellroy-api.vercel.app/products"
        , expect = Http.expectJson (RemoteData.fromResult >> msg) productsDecoder
        }
