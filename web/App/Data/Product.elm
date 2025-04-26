module App.Data.Product exposing
    ( Product(..)
    , ProductData
    , ProductList
    , getProducts
    , productDecoder
    , productsDecoder
    )

import Http
import Json.Decode exposing (Decoder, float, list, maybe, string)
import Json.Decode.Pipeline exposing (required)
import RemoteData exposing (WebData)


type Product
    = Product ProductData


type alias ProductList =
    List Product


type alias ProductData =
    { id : String
    , name : String
    , description : String
    , price : Float
    , imageUrl : String
    , styles : List String
    , tags : List String
    }


productDecoder : Decoder Product
productDecoder =
    Json.Decode.succeed ProductData
        |> required "id" string
        |> required "name" string
        |> required "description" string
        |> required "price" float
        |> required "imageUrl" string
        |> required "styles" (list string)
        |> required "tags" (list string)
        |> Json.Decode.map Product


productsDecoder : Decoder (List Product)
productsDecoder =
    Json.Decode.list productDecoder


getProducts : (WebData ProductList -> msg) -> Cmd msg
getProducts msg =
    Http.get
        { url = "http://localhost:3000/products"
        , expect = Http.expectJson (RemoteData.fromResult >> msg) productsDecoder
        }
