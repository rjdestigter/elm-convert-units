module ConvertUnits.Definitions.Length exposing (..)

import Dict exposing (Dict)
import ConvertUnits.Definitions exposing (..)


possibilities : List String
possibilities =
    [ "m", "cm", "m", "km", "in", "yd", "ft", "mi" ]


metricAnchor : Anchor
metricAnchor =
    Anchor "m" 3.28083989501 Length


imperialAnchor : Anchor
imperialAnchor =
    Anchor "ft" (1 / 3.28083989501) Length


units : Dict String ( Descriptor, Anchor )
units =
    Dict.fromList
        -- Metric
        [ ( "m", ( Descriptor "m" "Millimeter" "Millimeters" (1 / 1000), metricAnchor ) )
        , ( "cm", ( Descriptor "cm" "Centimeter" "Centimeters" (1 / 100), metricAnchor ) )
        , ( "m", ( Descriptor "m" "Meter" "Meters" (1), metricAnchor ) )
        , ( "km", ( Descriptor "km" "Kilometer" "Kilometers" (1000), metricAnchor ) )
          -- Imperial
        , ( "in", ( Descriptor "in" "Inch" "Inches" (1 / 12), imperialAnchor ) )
        , ( "yd", ( Descriptor "yd" "Yard" "Yards" (3), imperialAnchor ) )
        , ( "ft", ( Descriptor "ft" "Foot" "Feet" (1), imperialAnchor ) )
        , ( "mi", ( Descriptor "mi" "Mile" "Miles" (5280), imperialAnchor ) )
        ]
