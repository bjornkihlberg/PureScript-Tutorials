## Description
### Profunctors
The profunctor itself isn't all that complicated. According to
[its specification](https://pursuit.purescript.org/packages/purescript-profunctor/4.0.0/docs/Data.Profunctor), the only profunctor defined is the function and its only member `dimap`
```purescript
dimap :: forall a b c d p. Profunctor p => (a -> b) -> (c -> d) -> p b c -> p a d
```
Since the function is the only profunctor, the signature could be simplified.
```purescript
dimap :: forall a b c d => (a -> b) -> (c -> d) -> (b -> c) -> (a -> d)
```
The only way for this to make sense is if `dimap` is implemented as the first two functions composed with the third
```purescript
dimap :: forall a b c d => (a -> b) -> (c -> d) -> (b -> c) -> (a -> d)
dimap f g h = f >>> h >>> g
```
This seems trivial and a lot of ceremony for something very simple.

*I think `Array`, `HashMap` or similar constructs could be profunctors where `dimap` maps the accessor value (index in arrays and keys in maps) and the contained values. That requires perhaps further justification but I won't bother right now.*

Let's see some use cases for profunctors. We could start with the obvious. Hit up the REPL
```
> f x = x * 2
> g = dimap (_ - 1) (_ + 5) f
> g 10
23
```
Subtract `1` from `10`, multiply the result by `2` and then add `5`. Or `(10 - 1) * 2 + 5`. Nothing fancy.
## Instructions
### Setup
1. Install required modules
    ```
    npx psc-package install profunctor
    npx psc-package install psci-support
    ```
1. Set up npm scripts in `package.json` for ease of use
    ```json
    "scripts": {
        "postinstall": "psc-package install",
        "repl": "pulp --psc-package --watch repl"
    }
    ```
1. Create a file `.purs-repl` to automatically import specified modules
    ```purescript
    import Prelude
    import Data.Profunctor
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