# PureScript-Tutorials
Tutorials on using PureScript

## Cheat sheet
### Initialize new project
```
pulp --psc-package init
```
### Show instance
```purescript
newtype Box a = Box a

instance showBox :: (Show a) => Show (Box a) where
    show (Box x) = "Box " <> (show x)
```
### Records
#### Structural record type
```purescript
type MyRecord = { a :: Int, b :: Number, c :: String }
```
#### Nominal record type
```purescript
newtype MyRecord = MyRecord { a :: Int, b :: Number, c :: String }
```
#### Record patterns
```purescript
f :: forall a. { i :: Int | a } -> { i :: Int }
f { i } = { i: i + 1 }
```

```purescript
f :: forall a. { i :: Int | a } -> { i :: Int | a }
f x = x { i = x.i + 1 }
```

```purescript
f :: forall a b. a -> b -> { x :: a, y :: b, z :: String }
f = { x: _, y: _, z: "Hello" }
```

```purescript
f :: forall a b c. { x :: a | c } -> b -> { x :: b | c }
f = _ { x = _ }
```