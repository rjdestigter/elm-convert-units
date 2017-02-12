module ConvertUnits.Definitions.Area exposing (..)

import Dict exposing (Dict)
import ConvertUnits.Definitions exposing (..)


possibilities : List String
possibilities =
    [ "mm2", "cm2", "m2", "ha", "km2", "in2", "ft2", "ac", "mi2" ]


metricAnchor : Anchor
metricAnchor =
    Anchor "m2" 10.7639 Area


imperialAnchor : Anchor
imperialAnchor =
    Anchor "ft2" (1 / 10.7639) Area


units : Dict String ( Descriptor, Anchor )
units =
    Dict.fromList
        -- Metric
        [ ( "mm2", ( Descriptor "mm2" "Square Millimeter" "Square Millimeters" (1 / 1000000), metricAnchor ) )
        , ( "cm2", ( Descriptor "cm2" "Centimeter" "Centimeters" (1 / 10000), metricAnchor ) )
        , ( "m2", ( Descriptor "m2" "Square Meter" "Square Meters" (1), metricAnchor ) )
        , ( "ha", ( Descriptor "ha" "Hectare" "Hectares" (10000), metricAnchor ) )
        , ( "km2", ( Descriptor "km2" "Square Kilometer" "Square Kilometers" (1000000), metricAnchor ) )
          -- Imperial
        , ( "in2", ( Descriptor "in2" "Square Inch" "Square Inches" (1 / 144), imperialAnchor ) )
        , ( "ft2", ( Descriptor "ft2" "Square Foot" "Square Feet" (1), imperialAnchor ) )
        , ( "ac", ( Descriptor "ac" "Acre" "Acres" (43560), imperialAnchor ) )
        , ( "mi2", ( Descriptor "mi2" "Square Mile" "Square Miles" (27878400), imperialAnchor ) )
        ]
