module ConvertUnits.Definitions
    exposing
        ( Category(..)
        , Anchor
        , Descriptor
        )

{-|
# Definition
@docs Category, Anchor, Descriptor
-}


{-| Represents a category of units. You can pass a Category to
the possibilities functions if you wish to receive a list of
available units for that category
-}
type Category
    = Area
    | Mass
    | Length


{-| Holds the ratio to convert between Imperial and Metric systems
-}
type alias Anchor =
    { unit : String
    , ratio : Float
    , category : Category
    }


{-| Recod descibing a unit. A Descriptor is returned by the "describe" function.
-}
type alias Descriptor =
    { abbr : String
    , singular : String
    , plural : String
    , toAnchor : Float
    }
