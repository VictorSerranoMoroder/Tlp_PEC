# Haskell

## Conceptos básicos
Haskell es un **lenguaje de programación puramente funcional**. En los lenguajes imperativos obtenemos resultados dándole al computador una secuencia de tareas que luego éste ejecutará.

Con la programación puramente funcional no decimos al computador lo que tiene que hacer, sino más bien, **decimos como son las cosas**. El factorial de un número es el producto de todos los números desde el 1 hasta ese número, la suma de una lista de números es el primer número más la suma del resto de la lista...

Lo único que puede hacer una función es calcular y devolver algo como resultado. Al principio esto puede parecer una limitación pero en realidad tiene algunas buenas consecuencias: **si una función es llamada dos veces con los mismos parámetros, obtendremos siempre el mismo resultado**. A esto lo llamamos **transparencia referencial** y no solo permite al compilador razonar acerca de el comportamiento de un programa, sino que también nos permite deducir fácilmente (e incluso demostrar) que una función es correcta y así poder construir funciones más complejas uniendo funciones simples.

Haskell es **perezoso**. Es decir, a menos que le indiquemos lo contrario, *Haskell no ejecutará funciones ni calculará resultados hasta que se vea realmente forzado a hacerlo*. Esto funciona muy bien junto con la transparencia referencial y permite que veamos los programas como una serie de transformaciones de datos.

Haskell es un **lenguaje tipificado estáticamente**.

## Utilizando Haskell

### Funciones
Las funciones son definidas de forma similar a como son llamadas. El nombre de la función es seguido por los parámetros separados por espacios. Pero, cuando estamos definiendo funciones, hay un = y luego definimos lo que hace la función.
```hs
doubleMe x = x + x
```

Las funciones se pueden llamar desde otras funciones y pueden definir parte de su comportamiento:
```hs
doubleUs x y = doubleMe x + doubleMe y
```

> Esto es un simple ejemplo de un patrón normal que se ve por todo Haskell. Crear funciones pequeñas que son obviamente correctas y luego combinarlas en funciones más complejas.

### Listas
#### Concepto y operadores
Es la estructura de datos más utilizada y pueden ser utilizadas de diferentes formas para modelar y resolver un montón de problemas. Las listas son MUY importantes.

En Haskell, las listas son una estructura de datos **homogénea**. Almacena varios elementos del mismo tipo.

Las listas se definen mediante corchetes y sus valores se separan por comas tal que:
```hs
let numbers = [4,8,15,16,23,42]
```

Una tarea común es concatenar dos listas. Cosa que conseguimos con el operador `++`.
```hs
ghci> [1,2,3,4] ++ [9,10,11,12]
[1,2,3,4,9,10,11,12]
ghci> "hello" ++ " " ++ "world"
"hello world"
```

Hay que tener cuidado cuando utilizamos el operador `++` repetidas veces sobre cadenas largas, Haskell tiene que recorrer la lista entera desde la parte izquierda del operador `++`. Esto no supone ningún problema cuando trabajamos con listas que no son demasiado grandes. Pero concatenar algo al final de una lista que tiene cincuenta millones de elementos llevará un rato. Sin embargo, concatenar algo al principio de una lista utilizando el operador `:` (también llamado operador cons) es instantáneo.

```hs
ghci> 'U':"n gato negro"
"Un gato negro"
```

Si queremos obtener un elemento de la lista sabiendo su índice, utilizamos `!!` (los índices empiezan en 0):
```hs
ghci> "Steve Buscemi" !! 6
'B'
```

#### Funciones básicas
##### Funciones de Acceso
- `head` toma una lista y devuelve su cabeza. La cabeza de una lista es básicamente el primer elemento.
```hs
ghci> head [5,4,3,2,1]
5
```

- `tail` toma una lista y devuelve su cola. En otros palabras, corta la cabeza de la lista.
```hs
ghci> tail [5,4,3,2,1]
[4,3,2,1]
```

- `last` toma una lista y devuelve su último elemento.
```hs
ghci> last [5,4,3,2,1]
1
```

- `reverse` pone del revés una lista.
```hs
ghci> reverse [5,4,3,2,1]
[1,2,3,4,5]
```

- `take` toma un número y una lista y extrae dicho número de elementos de una lista.
```hs
ghci> take 5 [1,2]
[1,2]
ghci> take 0 [6,6,6]
[]
```

- `drop` funciona de forma similar, solo que quita un número de elementos del comienzo de la lista.
```hs
ghci> drop 3 [8,4,2,1,5,6]
[1,5,6]
ghci> drop 0 [1,2,3,4]
[1,2,3,4]
ghci> drop 100 [1,2,3,4]
[]
```
---
##### Características

- `init` toma una lista y devuelve toda la lista excepto su último elemento.
```hs
ghci> init [5,4,3,2,1]
[5,4,3,2]
```

- `length` toma una lista y obviamente devuelve su tamaño.
```hs
ghci> length [5,4,3,2,1]
5
```

- `null` comprueba si una lista está vacía. Si lo está, devuelve True, en caso contrario devuelve False.
```hs
ghci> null [1,2,3]
False
ghci> null []
True
```
---
##### Operaciones matemáticas y comparativas

- `maximum` toma una lisita de cosas que se pueden poner en algún tipo de orden y devuelve el elemento más grande

- `minimum` devuelve el más pequeño.

- `sum` toma una lista de números y devuelve su suma.

- `product` toma una lista de números y devuelve su producto.
```hs
ghci> sum [5,2,1,6,3,2,5,7]
31
ghci> product [6,2,1,2]
24
ghci> product [1,2,5,6,7,9,2,0]
0
```

- `elem` toma una cosa y una lista de cosas y nos dice si dicha cosa es un elemento de la lista.
```hs
ghci> 4 `elem` [3,4,5,6]
True
ghci> 10 `elem` [3,4,5,6]
False
```
---
### Lista Intensional
Un conjunto definido de forma intensiva que contenga los diez primeros números naturales pares sería:
$$
S={2*x | x*\in N, x \leq 10}
$$

Las listas intensionales son muy similares a los conjuntos definidos de forma intensiva. En este caso, la lista intensional que deberíamos usar sería [x*2 | x <- [1..10]]. x es extraído de [1..10] y para cada elemento de [1..10] (que hemos ligado a x) calculamos su doble. Su resultado es:
```hs
ghci> [x*2 | x <- [1..10]]
[2,4,6,8,10,12,14,16,18,20]
```

¿Y si quisiéramos todos los números del 50 al 100 cuyo resto al dividir por 7 fuera 3? Fácil:

```hs
ghci> [ x | x <- [50..100], x `mod` 7 == 3]
[52,59,66,73,80,87,94]
```

Para mayor comodidad, vamos a poner la lista intensional dentro de una función para que sea fácilmente reutilizable

```hs
boomBangs xs = [ if x < 10 then "BOOM!" else "BANG!" | x <- xs, odd x]
```