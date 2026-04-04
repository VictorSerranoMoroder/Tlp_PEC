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

