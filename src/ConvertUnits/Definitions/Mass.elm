module ConvertUnits.Definitions.Mass exposing (..)

import Dict exposing (Dict)
import ConvertUnits.Definitions exposing (..)
import ConvertUnits.Definitions exposing (Category(..))


possibilities : List String
possibilities =
    [ "mcg", "mg", "g", "kg", "oz", "lb" ]


metricAnchor : Anchor
metricAnchor =
    Anchor "g" (1 / 453.592) Mass


imperialAnchor : Anchor
imperialAnchor =
    Anchor "lb" 453.592 Mass


units : Dict String ( Descriptor, Anchor )
units =
    Dict.fromList
        -- Metric
        [ ( "mcg", ( Descriptor "mcg" "Microgram" "Micrograms" (1 / 1000000), metricAnchor ) )
        , ( "mg", ( Descriptor "mg" "Milligram" "Milligrams" (1 / 1000), metricAnchor ) )
        , ( "g", ( Descriptor "g" "Gram" "Grams" (1), metricAnchor ) )
        , ( "kg", ( Descriptor "kg" "Kilogram" "Kilograms" (1000), metricAnchor ) )
          -- Imperial
        , ( "oz", ( Descriptor "oz" "Ounce" "Ounces" (1 / 16), imperialAnchor ) )
        , ( "lb", ( Descriptor "lb" "Pound" "Pounds" (1), imperialAnchor ) )
        ]
