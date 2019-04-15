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
#### Contravariant functor
There is already [a type class for contravariant functors](https://pursuit.purescript.org/packages/purescript-contravariant/4.0.0/docs/Data.Functor.Contravariant#t:Contravariant)
but it's a little bit difficult to work with. As I understand it it only works for functions but it isn't defined to work with the [Function type](https://pursuit.purescript.org/builtins/docs/Prim#t:Function). Then the type class definition would need to be adapted in a way that makes it "too aware" of this fact. We'll start by taking a look at how the `Contravariant` type class works then we'll make a simpler version for ourselves just to get an idea of why it is the way it is.

In the repl, import the required packages.
```
> import Data.Functor.Contravariant
```
We can now take a peek at the `cmap` function and it's type.
```
> :t cmap
forall a b f. Contravariantf => (b -> a) -> f a -> f b
```
This is a really wierd type signature. It reminds us of map but the mapping function goes from `b` to `a`. How could we do anything with `f a` if we need a `b`? This doesn't seem to make sense. But it makes perfect sense if we think of `f a` as a function `a -> c`. If we have a function `b -> a` and a function `a -> c`, we can produce a new function `b -> c` (or `f b` as we call it here!) with simple composition. However `Contravariant` has no instance for `Function`.

Before we move on I want to show that the absolutely simplest way to get what we want is just composition.
```
> f x = x * 2
> g = (_ - 1) >>> f
> g 10
18
```
We're now going to do the same thing but much more complicated. Skip ahead if you think this is pointless (It kinda seems pointless to me tbh).

First we have to wrap our `Function` type in an [Op type](https://pursuit.purescript.org/packages/purescript-contravariant/4.0.0/docs/Data.Op#t:Op). It simply wraps our function and flips the type arguments. Why? Because!

Reload the REPL with `:r` and let's do the same as before, but in a more confusing and contrived manner.
```
> :r
> import Data.Op
> f x = x * 2
> fOp = Op f
> gOp = cmap (_ - 1) fOp
> g = unwrap gOp
> g 10
18
```
Alright, let's say we think the way the type class is implemented right now is silly and we want to do it in our own way, how would that work?
```purescript
class ContravariantFunctor f where
    contramap :: forall a b c. (b -> a) -> f a c -> f b c

instance contravariantFunctorFn :: ContravariantFunctor (Function) where
    contramap = (>>>)
```
Notice that we have to define `contramap` to work with `f a c` yet the `c` doesn't seem vital to what *a contravariant functor is*. It has to be defined this way only because we know we're going to implement it for the `Function` type. Anyway, how does this implementation work?

Reload the REPL and let's try it out.
```
> f x = x * 2
> g = contramap (_ - 1) f
> g 10
18
```
That was a lot simpler but if we want for some reason to produce something that is a contravariant functor but isn't a function, it has to be something that takes two type arguments. I don't know that that is the big problem but maybe it could be. Oh well. Atleast now we know what it is.
## Instructions
### Setup
1. Install the required modules
    ```
    npx psc-package install psci-support
    npx psc-package install contravariant
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