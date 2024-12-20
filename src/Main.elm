module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
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
    , Task.perform Tick Time.now
    ]
  )


-- UPDATE

type Msg
  = AdjustTimeZone Time.Zone
  | Tick Time.Posix

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    AdjustTimeZone newZone ->
      ( { model | zone = newZone }
      , Cmd.none
      )
    Tick newTime ->
      ( { model | time = newTime }
      , Cmd.none
      )


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every 1000 Tick


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

-- Dates - I just converted these from JS Dates
departDate = 1737187200000
returnDate = 1743408000000

dateDeltaDisplay : Int -> Int -> String
dateDeltaDisplay start end =
  let
    delta = abs (end - start)
    totalSeconds = delta // 1000
    totalMinutes = totalSeconds // 60
    totalHours = totalMinutes // 60
    totalDays = totalHours // 24
  in
    String.fromInt totalDays ++ " days, " ++
    String.fromInt (modBy 24 totalHours) ++ " hours, " ++
    String.fromInt (modBy 60 totalMinutes) ++ " minutes, " ++
    String.fromInt (modBy 60 totalSeconds) ++ " seconds"


-- VIEW

view : Model -> Html Msg
view model =
  let
    day = String.fromInt (Time.toDay model.zone model.time)
    month = monthToString (Time.toMonth model.zone model.time)
    year = String.fromInt (Time.toYear model.zone model.time)
    countdownDisplay = dateDeltaDisplay (Time.posixToMillis model.time) departDate
    -- tilReturnDisplay = dateDeltaDisplay (Time.posixToMillis model.time) returnDate
  in
  main_ [ style "padding" "16px", style "textAlign" "center" ]
    [ heading 
    , time day month year
    , p [] [ text (countdownDisplay ++ " until takeoff!") ]
    -- , p [] [ text (tilReturnDisplay ++ " until return!") ]
    ]

heading =
  div []
    [ h1 [] [ text "Croatia Countdown" ]
    ]

time : String -> String -> String -> Html Msg
time day month year =
  p []
    [ text ("Today is " ++ day ++ " " ++  month ++ ", " ++ year) ]
