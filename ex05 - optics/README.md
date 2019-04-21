## Description
### Profunctor optics
The subject of optics or lenses is quite big. There is [a book](https://leanpub.com/lenses) on this subject. In this tutorial I will only show some basics. Optics seem quite easy to work with but a little bit more complicated to build from scratch. I'll try to summarise as best as I understand how this works.
#### Motivation
Working with deeply nested datastructures in FP can be inconvenient.
```purescript
type RecordA = { b :: RecordB }
type RecordB = { x :: Int }
```
Retrieving the `x` field in a `RecordA` is not a huge problem.
```purescript
getX :: RecordA -> Int
getX a = a.b.x
```
```
> recordA = { b: { x: 10 } }
> getX recordA
10
```
The `getX` function works as expected. No problemo. Things get slightly more complicated if we want to set the `x` field.
```purescript
setX :: Int -> RecordA -> RecordA
setX x a = a { b = a.b { x = x } }
```
```
> setX 3 recordA
{ b: { x: 3 } }
```
The `setX` function also works as expected and might be fine for this simple example. However we can imagine it becoming unwieldy for more complicated cases where we might have lists, maps and/or sum types. The idea behind profunctor optics is that you compose "lenses" and "prisms" to "point" at something in a datastructure to conveniently manipulate it in a pure way. From here on we'll use the well designed [profunctor-lenses](https://pursuit.purescript.org/packages/purescript-profunctor-lenses/5.0.0) package to learn how to use optics in PureScript.
#### Lens optics
Let's start by taking a look at optics for product types like tuples and records. These optics are referred to as "lenses". The are already some lenses defined for the `Tuple` type in the `Data.Lens` module that are quite straight forward.
```
> view _1 (Tuple "Hello" 5)
"Hello"
> set _1 "Yo" (Tuple "Hello" 5)
(Tuple "Yo" 5)
> over _2 (_ * 2) (Tuple "Hello" 5)
(Tuple "Hello" 10)
```
This is quite self explanatory. `view` obviously retrieves a value, `set` sets a value (non-mutating ofcourse) and `over` maps a value. The `_1` and `_2` functions are the lenses that are pointing to the first or second value in the tuple. What's really cool is if we have a nested structure. We can compose the lenses to navigate into the nested structure.
```
> myTuple = Tuple (Tuple 5 "hello") true
> myLens = _1 <<< _2
> view myLens myTuple
"hello"
```
`myLens` points at the position of the "hello" value in `myTuple`. We can set it to another value using the same lens.
```
> set myLens "Hi!" myTuple
(Tuple (Tuple 5 "Hi!") true)
```
*Notice that `myTuple` remains unchanged!*
## Instructions
### Setup
1. Install required packages
    ```
    npx psc-package install profunctor-lenses
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
    import Data.Lens
    import Data.Tuple
    ```
### Usage
1. Download and install all project dependencies
    ```
    npm install
    ```
1. Start the PureScript build process
    ```
    npm run build
    ```
1. Start the PureScript REPL
    ```
    npm run repl
    ```