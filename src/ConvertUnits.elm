module ConvertUnits
    exposing
        ( convert
        , describe
        , possibilities
        , isPossible
        )

{-| Convert Float values from one unit to another. Currently supports

  Area: [ "mm2", "cm2", "m2", "ha", "km2", "in2", "ft2", "ac", "mi2" ]

  Length: [ "m", "cm", "m", "km", "in", "yd", "ft", "mi" ]

  Mass: [ "mcg", "mg", "g", "kg", "oz", "lb" ]

# Converting
@docs convert

# Helpers
@docs describe, possibilities, isPossible
-}

import ConvertUnits.Definitions exposing (..)
import ConvertUnits.Definitions.Area as Area
import ConvertUnits.Definitions.Length as Length
import ConvertUnits.Definitions.Mass as Mass
import Dict exposing (Dict)


{-| Local infix operator for unionizing dictionaries
-}
(~) : Dict comparable v -> Dict comparable v -> Dict comparable v
(~) =
    Dict.union


listOfPossibilities : List String
listOfPossibilities =
    List.concat
        [ Area.possibilities
        , Length.possibilities
        , Mass.possibilities
        ]


units : Dict.Dict String ( Descriptor, Anchor )
units =
    Area.units
        ~ Length.units
        ~ Mass.units


{-| Returns a list of unit abbreviations possible for conversion

    possibilities Nothing = ["m", "cm", "kg", "ft", ..., "ac"] -- All supported units

    possibilities Area = ["m2", "in2", ..., "km2", "ha"] -- Area units

    possibilities Length = ["in", "ft", ..., "km"] -- Length units
-}
possibilities : Maybe Category -> List String
possibilities category =
    case category of
        Nothing ->
            listOfPossibilities

        Just category ->
            case category of
                Area ->
                    Area.possibilities

                Mass ->
                    Mass.possibilities

                Length ->
                    Length.possibilities


{-| Returns a record with descriptive information about a unit

    describe "m2" == Just { abbr: "m2", singluar: "Square Meter", plural: "Square Meters", toAnchor: 1 }

    describe "ft" == Just { abbr: "ft", singluar: "Foot", plural: "Feet", toAnchor: 1 }

    describe "wut" = Nothing

    describe "yo mama" = Nothing
-}
describe : String -> Maybe Descriptor
describe unit =
    let
        tuple =
            Dict.get unit units
    in
        case tuple of
            Just ( descriptor, anchor ) ->
                Just descriptor

            Nothing ->
                Nothing


{-| Takes a Float value and two String values referring to unit abbreviations
    and attempts to convert the given value from one unit into another.

    convert 1000 "m" "km" == Ok 1

    convert 5 "kg" "oz" == Ok 176.3699536147022

    convert 100 "ft" "m2" == Err "Cannot convert incompatible measures"

    convert 100 "ft" "wut" == Err "Unsupported unit 'wut'
-}
convert : Float -> String -> String -> Result String Float
convert value fromUnit toUnit =
    if (not <| isPossible fromUnit) then
        unsupported fromUnit
    else if (not <| isPossible toUnit) then
        unsupported toUnit
    else if (fromUnit == toUnit) then
        Ok value
    else
        from value (Dict.get fromUnit units) (Dict.get toUnit units)


{-| Continues the conversion with a "from" Descriptor if found
-}
from : Float -> Maybe ( Descriptor, Anchor ) -> Maybe ( Descriptor, Anchor ) -> Result String Float
from value fromUnit toUnit =
    case fromUnit of
        Just ( descriptor, anchor ) ->
            to value ( descriptor, anchor ) toUnit

        Nothing ->
            missingConfiguration "from"


{-| Continues the conversion with a "to" Descriptor if found
-}
to : Float -> ( Descriptor, Anchor ) -> Maybe ( Descriptor, Anchor ) -> Result String Float
to value fromUnit toUnit =
    case toUnit of
        Just ( descriptor, anchor ) ->
            withDescriptors value fromUnit ( descriptor, anchor )

        Nothing ->
            missingConfiguration "to"


{-| Continues the conversion if both descriptors are within the same category
-}
withDescriptors : Float -> ( Descriptor, Anchor ) -> ( Descriptor, Anchor ) -> Result String Float
withDescriptors value ( desc1, anchor1 ) ( desc2, anchor2 ) =
    if (anchor1.category == anchor2.category) then
        calculate value ( desc1, anchor1 ) ( desc2, anchor2 )
    else
        Err "Cannot convert incompatible measures"


{-| Performs the final calculations to convert the given value
-}
calculate : Float -> ( Descriptor, Anchor ) -> ( Descriptor, Anchor ) -> Result String Float
calculate value ( fromUnit, fromSystem ) ( toUnit, toSystem ) =
    value
        |> (*) fromUnit.toAnchor
        |> convertToSystem fromSystem toSystem
        |> (\result -> result / toUnit.toAnchor)
        |> Ok


{-| Applies the destination anchor's ratio
    when converting from Imperial to Metric and vice versa
-}
convertToSystem : Anchor -> Anchor -> Float -> Float
convertToSystem origin destination value =
    if origin == destination then
        value
    else
        value / destination.ratio


{-| Returns True if the given unit abbreviation is included in this package

    isPossible "m" == True

    isPossible "pixel" == False
-}
isPossible : String -> Bool
isPossible unit =
    List.member unit listOfPossibilities


{-| Performs the final calculations to convert the given value
-}
unsupported : String -> Result String Float
unsupported unit =
    Err ("Unsupported unit '" ++ unit ++ "'")


missingConfiguration : String -> Result String Float
missingConfiguration for =
    Err ("Unable to find proper '" ++ for ++ "' configuration")
