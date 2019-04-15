## Description
### Some [Category theory](https://en.wikipedia.org/wiki/Category_theory) as modelled in PureScript
I will not go into detail, only show some basic examples for each construct that interests me.
#### Functor
The [Functor](https://en.wikipedia.org/wiki/Functor) is modelled as a type class that implements `map` and that has to follow certain laws as described [here](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Functor#t:Functor).
```purescript
class Functor f where
    map :: forall a b. (a -> b) -> f a -> f b
```
An example of a `Functor` is the `Array` type. That means we can map over an array.
```
> map (2 * _) [1, 2, 3, 4, 5]
[2,4,6,8,10]
```
Another example of a `Functor` are functions. Mapping over functions mean we produce a new function where we mapped the returned result.
```
> f x = x * 2
> g = map (_ - 1) f
> g 5
9
```
We can also create our own functor (And `show` for convenience).
```purescript
newtype Box a = Box a

instance functorBox :: Functor Box where
    map f (Box x) = Box (f x)

instance showBox :: (Show a) => Show (Box a) where
    show (Box x) = "Box " <> (show x)
```
Now we can map over values of type `Box`.
```
> box = Box 5
> map (_ + 2) box
Box 7
```
## Instructions
### Setup
1. Install the psci-support module
    ```
    npx psc-package install psci-support
    ```
1. Set up npm scripts in `package.json` for ease of use
    ```json
    "scripts": {
        "postinstall": "psc-package install",
        "repl": "pulp --psc-package --watch repl",
        "build": "pulp --psc-package --watch build"
    }
    ```
1. Create a file `.purs-repl` to automatically import specified modules
    ```purescript
    import Prelude
    import Main
    ```
### Usage
1. Download and install all project dependencies
    ```
    npm install
    ```
1. Start the PureScript REPL
    ```
    npm run repl
    ```