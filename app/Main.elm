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
    Navigation.programWithFlags UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


--------------------------------------------------
-- MODEL
--------------------------------------------------

type alias ProgramOptions =
    { user : Maybe User
    }

type alias Model =
    { history : List Navigation.Location
    , user : Maybe User
    }


type alias User =
    { email : String
    , iss : String
    , iat : Int
    , exp : Int
    }

type Msg
    = LoginRedirect
    | LoginCustom
    | Logout
    | UrlChange Navigation.Location

--------------------------------------------------
-- INIT
--------------------------------------------------

init : ProgramOptions -> Navigation.Location  -> (Model, Cmd Msg)
init opt location = ( Model [ location ] opt.user
                    , if location.pathname == customUrl then loginCustom () else Cmd.none
                    )


--------------------------------------------------
-- UPDATE
--------------------------------------------------

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    LoginRedirect ->
        ( model, loginRedirect () )

    LoginCustom -> ( model, loginCustom () )

    -- auth sdk will take care of logout hence keep model unchanged so far
    -- otherwise double refresh (model change refresh plus after logout refresh)
    Logout -> ( model, logout () )

    UrlChange location ->
        ( { model | history = location :: model.history }
        , Cmd.none
        )


--------------------------------------------------
-- VIEW
--------------------------------------------------

redirectUrl : String
redirectUrl = "/authorization-code/login-redirect"

customUrl : String
customUrl = "/authorization-code/login-custom"

profileUrl : String
profileUrl = "/authorization-code/profile"

view : Model -> Html Msg
view model =
    case List.head model.history of
        Nothing -> overviewHtml
        Just loc -> handleRouter model loc

handleRouter : Model -> Navigation.Location -> Html Msg
handleRouter model loc = case Dict.get loc.pathname routers of
                             Just handler -> handler model
                             Nothing -> overviewHtml

routers : Dict String (Model -> Html Msg)
routers = fromList [ (redirectUrl, loginRedirectHtml)
                   , (customUrl, loginCustomHtml)
                   , (profileUrl, profileHtml)
                   ]

overviewHtml : Html Msg
overviewHtml =
    div [ id "default-app-text" ]
        [ text "Samples render here"
        ]

scenarioLink : String   -- ^ URL
            -> String   -- ^ attribute value of data-se
            -> String   -- ^ link name
            -> Html Msg
scenarioLink url se name = li [] [a [ href url, datase se ] [ text name ]]

loginRedirectHtml : Model -> Html Msg
loginRedirectHtml _ =
    div []
        [ p []
            [ text "Click "
            , strong [] [ text "Login with Okta" ]
            , text " to redirect to your Okta org for authentication."
            ]
        , table [ class "ui collapsing celled table compact inverted grey" ]
                [ thead []
                        [ tr []
                             [ th [ colspan 2 ]
                                  [ text "If you're using the mock-okta server:" ]
                             ]
                        ]
                , tbody []
                        [ tr []
                             [ td [] [ text "User"]
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
        ]


-- login custom scenario will render login form from Okta Signin Widget hence render nothing from Elm.
-- @see init function.
loginCustomHtml : Model -> Html Msg
loginCustomHtml _ = text ""

profileHtml : Model -> Html Msg
profileHtml model =
    case model.user of
        Nothing -> p [] [ text "no profile found" ]
        Just user ->
            div [ class "profile" ]
                [ h2 [ class "ui icon header"]
                      [ i [ class "hand peace icon"] []
                      , div [ class "content" ] [ text "Signed In" ]
                      ]
                , table [ class "ui collapsing celled table inverted black" ]
                      [ thead []
                            [ tr []
                                  [ th [ colspan 2 ]
                                        [ text "Some claims from the id_token" ]
                                  ]
                            ]
                      , tbody []
                          [ tr []
                                [ td [] [ text "email"]
                                , td [ datase "email" ] [ text user.email ]
                                ]
                          , tr []
                              [ td [] [ text "exp"]
                              , td [] [ text (toString (fromInt user.exp)) ]
                              ]
                        ]
                      ]
                , p []
                    [ button
                          [ id "logout"
                          , datase "logout-link"
                          , class "ui grey icon button"
                          , onClick Logout
                          ]
                          [ i [ class "sign out icon" ] []
                          , text "Sign out"
                  ]
                    ]

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
