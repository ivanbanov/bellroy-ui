module UI.Image exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, src)


view : List (Html.Attribute msg) -> String -> Html msg
view attributes imageUrl =
    img
        ([ class
            -- manually adding base64 since tailwind wont properly process the elm code if imported dinamically
            ("max-w-full after:bg-cover relative after:block after:absolute after:top-0 after:left-0 after:w-full after:h-full "
                ++ "after:bg-[url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz48IS0tIFVwbG9hZGVkIHRvOiBTVkcgUmVwbywgd3d3LnN2Z3JlcG8uY29tLCBHZW5lcmF0b3I6IFNWRyBSZXBvIE1peGVyIFRvb2xzIC0tPgo8c3ZnIHdpZHRoPSI4MDBweCIgaGVpZ2h0PSI4MDBweCIgdmlld0JveD0iMCAwIDEyMCAxMjAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxyZWN0IHdpZHRoPSIxMjAiIGhlaWdodD0iMTIwIiBmaWxsPSIjZjZmNmY2Ii8+CjxwYXRoIGZpbGwtcnVsZT0iZXZlbm9kZCIgY2xpcC1ydWxlPSJldmVub2RkIiBkPSJNMzMuMjUwMyAzOC40ODE2QzMzLjI2MDMgMzcuMDQ3MiAzNC40MTk5IDM1Ljg4NjQgMzUuODU0MyAzNS44NzVIODMuMTQ2M0M4NC41ODQ4IDM1Ljg3NSA4NS43NTAzIDM3LjA0MzEgODUuNzUwMyAzOC40ODE2VjgwLjUxODRDODUuNzQwMyA4MS45NTI4IDg0LjU4MDcgODMuMTEzNiA4My4xNDYzIDgzLjEyNUgzNS44NTQzQzM0LjQxNTggODMuMTIzNiAzMy4yNTAzIDgxLjk1NyAzMy4yNTAzIDgwLjUxODRWMzguNDgxNlpNODAuNTAwNiA0MS4xMjUxSDM4LjUwMDZWNzcuODc1MUw2Mi44OTIxIDUzLjQ3ODNDNjMuOTE3MiA1Mi40NTM2IDY1LjU3ODggNTIuNDUzNiA2Ni42MDM5IDUzLjQ3ODNMODAuNTAwNiA2Ny40MDEzVjQxLjEyNTFaTTQzLjc1IDUxLjYyNDlDNDMuNzUgNTQuNTI0NCA0Ni4xMDA1IDU2Ljg3NDkgNDkgNTYuODc0OUM1MS44OTk1IDU2Ljg3NDkgNTQuMjUgNTQuNTI0NCA1NC4yNSA1MS42MjQ5QzU0LjI1IDQ4LjcyNTQgNTEuODk5NSA0Ni4zNzQ5IDQ5IDQ2LjM3NDlDNDYuMTAwNSA0Ni4zNzQ5IDQzLjc1IDQ4LjcyNTQgNDMuNzUgNTEuNjI0OVoiIGZpbGw9IiMzMzMiLz4KPC9zdmc+)]"
            )
         , src imageUrl
         ]
            ++ attributes
        )
        []
