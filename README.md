# Compilar con GHC
Ejecutar:
``` sh
ghc Main.hs
```

Esto genera:
```
Main
Main.hi
Main.o
```

Y se ejecuta tal que:
``` sh
./Main
```

Se puede utilizar tambien REPL para el desarrollo interactivo:
``` sh
ghci
```

``` hs
:1 Main.hs
```

Ejecutar:
``` hs
main
```

# Lanzar en modo script
Esto interpreta y ejecuta directamente:
``` sh
runhaskell Main.hs
```

# Generación de documentación
Haddock es el generador de documentación oficial de Haskell:
- Extrae comentarios de ficheros `.hs`
- Genera documentación HTML similar a Javadoc y Doxygen

Para escribir los comentarios Haddock requiere de una sintaxis específica:

Para la documentación de la siguiente declaración se usa `-- |`
```hs
-- | Replaces the element at a given index in a list.
-- If the index is out of bounds or negative, the list is returned unchanged.
replaceAt :: Int -> a -> [a] -> [a]
```

Para la documentación del elemento previo se utiliza: `-- ^`
```hs
data Relation = Ind  -- ^ No relation
              | RGT  -- ^ Greater than
              | RLT  -- ^ Less than
```

Para comentarios multilínea se utiliza:
```hs
-- | Generates all valid successor states.
--
-- This function:
--   * Finds the next empty cell
--   * Tries all possible values
--   * Filters invalid states
succ :: Futoshiki -> [Futoshiki]
```

Para generar la documentación utilizar:
```
haddock Futoshiki.hs -o docs   --html   --hyperlinked-source   --use-unicode
```

Previamente se necesita compilar el proyecto, por lo tanto antes de generar la documentación hay que ejecutar:
```
ghc -c Futoshiki.hs
```