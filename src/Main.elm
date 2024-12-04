module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Task exposing (Task)
import Time exposing (Month(..))


-- MAIN

main =
  Browser.element
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }


-- MODEL

type alias Model =
  { zone : Time.Zone
  , time : Time.Posix
  }

init : () -> (Model, Cmd Msg)
init _ =
  ( Model Time.utc (Time.millisToPosix 0)
  , Cmd.batch
    [ Task.perform AdjustTimeZone Time.here
    , Task.perform AdjustCurrentTime Time.now
    ]
  )


-- UPDATE

type Msg
  = AdjustTimeZone Time.Zone
  | AdjustCurrentTime Time.Posix

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    AdjustTimeZone newZone ->
      ( { model | zone = newZone }
      , Cmd.none
      )
    AdjustCurrentTime newTime ->
      ( { model | time = newTime }
      , Cmd.none
      )


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- OK HELPERS I GUESS

monthToString : Time.Month -> String
monthToString month =
  case month of
    Jan -> "January"
    Feb -> "Februrary"
    Mar -> "March"
    Apr -> "April"
    May -> "May"
    Jun -> "June"
    Jul -> "July"
    Aug -> "August"
    Sep -> "September"
    Oct -> "October"
    Nov -> "November"
    Dec -> "December"

-- VIEW

view : Model -> Html Msg
view model =
  let
    day = String.fromInt (Time.toDay model.zone model.time)
    month = monthToString (Time.toMonth model.zone model.time)
    year = String.fromInt (Time.toYear model.zone model.time)
  in
  main_ []
    [ heading 
    , time day month year
    ]

heading =
  div []
    [ h1 [] [ text "Hello Elm!" ]
    ]

time : String -> String -> String -> Html Msg
time day month year =
  p []
    [ text ("Today is " ++ day ++ " of " ++  month ++ ", " ++ year) ]
