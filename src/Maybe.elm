module Maybe (Maybe(..), maybe, isJust, isNothing, map, andThen) where

{-| Represents an optional value. Maybe it is there, maybe it is not.

# Type and Constructors
@docs Maybe

# Taking Maybes apart
@docs maybe, isJust, isNothing

# Convenience Functions
@docs map, andThen
-}

{-| The Maybe datatype. Useful when a computation may or may not
result in a value (e.g. logarithm is defined only for positive
numbers). 
-}
type Maybe a = Just a | Nothing

{-| Provide a default value and a function to extract the contents of a `Maybe`.
When given `Nothing` you get the default, when given a `Just` you apply the
function to the associated value.

      isPositive : Maybe Int -> Bool
      isPositive maybeInt = maybe False (\n -> n > 0) maybeInt
-}
maybe : b -> (a -> b) -> Maybe a -> b
maybe b f m =
    case m of
      Just v  -> f v
      Nothing -> b

{-| Check if a maybe happens to be a `Just`.

      isJust (Just 42) == True
      isJust (Just []) == True
      isJust Nothing   == False
-}
isJust : Maybe a -> Bool
isJust = maybe False (\_ -> True)

{-| Check if constructed with `Nothing`.

      isNothing (Just 42) == False
      isNothing (Just []) == False
      isNothing Nothing   == True
-}
isNothing : Maybe a -> Bool
isNothing = maybe True (\_ -> False)

{-| Transform the contents of a `Maybe` with a given function:

      map sqrt (Just 9) == Just 3
      map sqrt Nothing  == Nothing
-}
map : (a -> b) -> Maybe a -> Maybe b
map f maybe =
    case maybe of
      Just v  -> Just (f v)
      Nothing -> Nothing


{-| Chain together many computations that may fail. It is helpful to see its
definition:

      andThen : Maybe a -> (a -> Maybe b) -> Maybe b
      andThen maybe callback =
          case maybe of
            Just value -> callback value
            Nothing    -> Nothing

This means we only continue with the callback if things are going well. For
example, say you need to use (`toInt : String -> Maybe Int`) to parse a month
and make sure it is between 1 and 12:

      validMonth : Int -> Maybe Int
      validMonth month =
          if month >= 1 && month <= 12
              then Just month
              else Nothing

      toMonth : String -> Maybe Int
      toMonth rawString =
          toInt rawString `andThen` validMonth

If `toInt` fails and results in `Nothing` this entire chain of operations will
short-circuit and result in `Nothing`. If `validMonth` results in `Nothing`,
again the chain of computations will result in `Nothing`.
-}
andThen : Maybe a -> (a -> Maybe b) -> Maybe b
andThen maybeValue callback =
    case maybeValue of
        Just value -> callback value
        Nothing    -> Nothing
