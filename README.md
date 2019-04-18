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