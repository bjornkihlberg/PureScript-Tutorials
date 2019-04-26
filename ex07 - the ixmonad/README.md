## Description
### Indexed Monads
The [IxMonad](https://pursuit.purescript.org/packages/purescript-indexed-monad/1.0.0/docs/Control.Monad.Indexed#t:IxMonad) is a monad to help enforce operations happen in a certain order. This is to help prevent you from moving to an illegal state. For example, if you're controlling an external device, perhaps you'd need to activate a locking mechanism before opening it (can't open something that i slocked), and close it only when it's opened (no point closing something that is already closed) and lock it when it's closed (no point locking if something isn't closed). It seems to me that it doesn't guarantee safety but it helps you to remember to do operations in the right order.

A use case I'm very interested in is if it's possible to use this when working with the GPU with [WebGL](https://get.webgl.org/) or [OpenGL](https://opengl.org/).

In my example I've created an indexed monad `IxABC` where I define three types with no constructors `A`, `B` and `C`.
```purescript
newtype IxABC i o a = IxABC a

data A
data B
data C
```
The idea is that we use these types to tag the IxABC monad with what state it is in so that they can only be composed in a certain order. In the signature for `IxABC i o a`, `i` represents the previous state, eg `A` and `o` represents the next state, eg `B` which means it could only be composed with another `IxABC` where its `i` is the same as the previous `o`. It's a little confusing but it will become clearer.

Some convenience instances for `Show` and `Newtype`.
```purescript
derive instance newtypeIxABC :: Newtype (IxABC i o a) _

instance showABC :: (Show a) => Show (IxABC i o a) where
    show (IxABC x) = "IxABC (" <> show x <> ")"
```
Followed by instance for `IxMonad` and its superclasses `IxBind`, `IxApplicative`, `IxApply` and `IxFunctor`.
```purescript
instance showABC :: (Show a) => Show (IxABC i o a) where
    show (IxABC x) = "IxABC (" <> show x <> ")"

instance ixFunctorABC :: IxFunctor IxABC where
    imap f (IxABC x) = IxABC (f x)

instance ixApplyABC :: IxApply IxABC where
    iapply (IxABC f) (IxABC x) = IxABC (f x)

instance ixApplicativeABC :: IxApplicative IxABC where
    ipure = IxABC

instance ixBindABC :: IxBind IxABC where
    ibind (IxABC x) f = (IxABC <<< unwrap) (f x)

instance ixMonadABC :: IxMonad IxABC
```
*This is a little tedious but it seems like you have to create an instance for all the `IxMonad` superclasses rather than include their definitions in the `IxMonad` instance directly. Maybe it's possible and I'm too stupid!*

Now we can define some operations and use our "tags" `A`, `B` and `C` to ensure that they can only be composed in the correct order!
```purescript
initA :: Int -> IxABC Void A Int
initA = IxABC

doB :: Int -> IxABC A B Int
doB = (_ * 2) >>> IxABC

doC :: Int-> IxABC B C Int
doC = (_ - 1) >>> IxABC
```
`initA :: Int -> IxABC Void A Int` wraps an initial `Int` value in an `IxABC` and tags it with `A`. `doB :: Int -> IxABC A B Int` is tagged with `B` and can only follow an `IxABC` tagged with `A`. `doC :: Int-> IxABC B C Int` is tagged with `C` and can only follow an `IxABC` tagged with `B`.
## Instructions
### Setup
1. Install required packages
    ```
    npx psc-package install psci-support
    npx psc-package install indexed-monad
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
1. Start the PureScript build process
    ```
    npm run build
    ```
1. Start the PureScript REPL
    ```
    npm run repl
    ```