{-
/*!
* Copyright (c) 2015-2016, Okta, Inc. and/or its affiliates. All rights reserved.
* The Okta software accompanied by this notice is provided pursuant to the Apache License, Version 2.0 (the "License.")
*
* You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
* WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*
* See the License for the specific language governing permissions and limitations under the License.
*/
-}

port module Main exposing (..)

import Dict exposing (..)
import Html exposing (..)
import Html as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import Navigation
import Date

main : Program ProgramOptions Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


--------------------------------------------------
-- MODEL
--------------------------------------------------

type alias ProgramOptions =
    { tokenResp : Maybe TokenResp
    }

type alias Model =
    { tokenResp : Maybe TokenResp
    }


type alias TokenResp =
    { idToken : String
    , accessToken : String
    , scope : List String
    }

type Msg
    = LoginRedirect
    | Logout

--------------------------------------------------
-- INIT
--------------------------------------------------

init : ProgramOptions  -> (Model, Cmd Msg)
init opt = ( Model opt.tokenResp
           , Cmd.none
           )


--------------------------------------------------
-- UPDATE
--------------------------------------------------

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    LoginRedirect ->
        ( model, loginRedirect () )

    -- auth sdk will take care of logout hence keep model unchanged so far
    -- otherwise double refresh (model change refresh plus after logout refresh)
    Logout -> ( model, logout () )



--------------------------------------------------
-- VIEW
--------------------------------------------------

view : Model -> Html Msg
view = loginRedirectHtml

-- case List.head model.history of

loginRedirectHtml : Model -> Html Msg
loginRedirectHtml m =
    div []
        [ table [ class "ui collapsing celled table compact inverted grey" ]
                [ thead []
                        [ tr []
                             [ th [ colspan 2 ]
                                  [ text "If you're using the mock-okta server:" ]
                             ]
                        ]
                , tbody []
                        [ tr []
                             [ td [] [ text "user" ]
                             , strong [] [ text "george" ]
                             ]
                        , tr []
                             [ td [] [ text "Pass"]
                             , strong [] [ text "Asdf1234" ]
                             ]
                        ]
                ]
        , p []
            [ button
                  [ id "login"
                  , datase "login-link"
                  , class "ui icon button blue"
                  , onClick LoginRedirect
                  ]
                  [ i [ class "sign in icon" ] []
                  , text "Login with Okta"
                  ]
            ]

        , div []
            (case m.tokenResp of
                Nothing -> []
                Just t -> [ text t.accessToken ])
        ]



fromInt : Int -> Date.Date
fromInt = Date.fromTime << toFloat << (*) 1000

datase : String -> Attribute msg
datase = attribute "data-se"

--------------------------------------------------
-- PORTs
--------------------------------------------------

port loginRedirect : () -> Cmd msg
port loginCustom : () -> Cmd msg
port logout : () -> Cmd msg
