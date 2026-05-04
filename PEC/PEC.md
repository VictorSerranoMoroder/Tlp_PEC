### Poda en generación de sucesores
La poda ocurre en la generación de los hijos, donde se evita crear nodos inválidos antes de que formen parte del árbol de búsqueda.

Por ejemplo, dado el siguiente árbol:

```
        f
       /
     A
```

De la función succ se derivan Futoshikis parciales que genera un máximo de 2 estados `(size f)`, consideremos en este caso un Futoshiki de 2x2.
```
        f
       /
     A
    / \x
  A1   A2
```

Se genera A1 que es válido, sin embargo supongamos que A2 es inválido, este no llegaría a formar parte del árbol de búsqueda. El resultado de la iteración sería:

```
        f
       /
     A
    /
  A1
```

Supongamos que ambos estados generados a partir de A1 son inválidos, si todos los hijos de A son inválidos, entonces A no genera sucesores y la rama termina:
```
        f
```

El algoritmo continúa en profundidad (DFS), por lo que tras terminar completamente una rama, puede explorar otras alternativas como B, que podrían llegar a la solución:
```
        f
       /
     B
    /
  B1
   |
 B1final
```

### Ejemplo de funcionamiento
Supongamos el siguiente tablero, con restricciones:
```
cells =
[
  [0, 0],
  [0, 0]
]
size = 2

hRel =
[
  [RLT, Ind],
  [Ind, Ind]
]
```

La restricción se aplica de `(0,0) < (0,1)`


Se llama a la función de `solve` para iniciar el algoritmo:
```hs
solve f
```

Esta llama a `bt` la función de backtrace donde:
```hs
bt esSol succ f
```

#### 1. Genera Candidatos
Se procede a calcular el sucesor de f, donde primero se busca la siguiente celda vacía:
```hs
findEmptyCell
```

Que encontrará la celda `(0,0)`. Una vez tenemos una celda objetivo se procede a intentar los valores de [1,2].

Probamos `v=1`
```hs
updateCell (0,0) = 1
```

#### 2. Filtra Candidatos
Y luego comprobamos:
```hs
isValid f (0,0) 1
```
Es válido porque cumple la restricción (0,0) < (0,1) al no violarla en estado parcial
Al ser válido, **genera hijo**.

En el caso de generar `v=2` este viola la condición y por tanto `isValid` devuelve `false`. Entonces en la función de `succ` devolverá `Nothing` por lo que el estado:

```
[
  [2, 0],
  [0, 0]
]
```
**Nunca** entra en el árbol.

#### 3. Sobreviven los candidatos válidos
Al podar `v=2` el resultado es:
```
        f
        |
       f1
```

El proceso se repite recusivamente reutilizando el resultado siguiendo desde las ramas válidas. **NUNCA** explora ramas inválidas, ya que las poda antes de continuar, aunque puede generar estados parciales que luego pueden fallar más adelante.

## Ejercicio 1 de la práctica
Supongamos una implementación de la práctica (usando los mismos tipos de datos aquí
presentados) en un lenguaje no declarativo (como Java, Pascal, C…). Entonces, comente
qué ventajas y desventajas tendría frente a la implementación en Haskell en relación a lo
siguiente

### 1.a Eficiencia con respecto a la programación
La implementación de un solucionador de Futoshikis en lenguajes no declarativos suele ser más "verbose" y tiene mucha mayor complejidad estructural ya que el programador debe gestionar de forma explícita elementos de bajo nivel del control del programa.

En particular, es necesario implementar manualmente bucles, copias de estructuras de datos y la lógica de retroceso (backtracking), incluyendo la gestión de la pila de llamadas en llamadas recursivas o estructuras auxiliares para simular la exploración del espacio de estados.

En cambio, en Haskell, al tratarse de un lenguaje declarativo, el programa se expresa en términos de **qué se quiere resolver** en lugar de **cómo hacerlo** paso a paso. Esto reduce la cantidad de código necesario.


### 1.b Eficiencia con respecto a la ejecución
Los lenguajes no declarativos suelen ser más eficientes en ejecución, ya que proporcionan un control más directo sobre el hardware y la memoria.

El programador puede modificar estructuras de datos in-place, evitar copias innecesarias y optimizar el flujo de ejecución de manera explícita. Esto permite reducir overhead asociado a la creación de estructuras intermedias o llamadas funcionales o recursisvas.

En contraste, en Haskell se trabaja con inmutabilidad de datos y evaluación perezosa (lazy evaluation) lo que puede introducir costes adicionales.

En general, los lenguajes no declarativos tienden a ser más eficientes en ejecución, mientras que aquellos que son declarativos priorizan la claridad y cercanía al problema.

### 1.c ¿Qué paradigma sale beneficiado por la semántica de variables?
La semántica de variables se refiere a cómo se comportan las variables dentro del lenguaje, especialmente en relación con su mutabilidad y su significado durante la ejecución del programa.

En lenguajes imperativos, las variables son mutables, lo que significa que su valor puede cambiar a lo largo del tiempo.

En cambio, en lenguajes declarativos, las variables son inmutables: una vez asignado un valor, este no cambia. Esto implica que una variable representa directamente un valor claro sin efectos ni condicionabilidad adicionales.

La semántica de variables beneficia claramente al paradigma declarativo, ya que facilita el razonamiento sobre el código y elimina la mutabilidad.

### 1.d Principal punto a favor de Haskell
El principal punto a favor de haskell es la *capacidad de expresar la solución de forma declarativa y cercana al problema*. En este caso el backtracking se expresa como una composición de functores donde el código que cada función expresa de forma muy cercana al mundo real la lógica del problema.

Como resultado, el código en Haskell refleja de forma muy directa la lógica matemática del problema, lo que mejora la legibilidad, la corrección y la mantenibilidad del programa.



## Ejercicio 2 de la práctica
Indique qué clases de constructores de tipos (ver capítulo 5 del libro de la
asignatura) se han utilizado para definir los tipos de datos presentes en el módulo
Futoshiki. Justifique sus respuestas.

En el módulo de Futoshiki encontramos los siguientes tipos de constructores:

- Constructor de tipo suma/enumeración
  Se utiliza en la definición de Relation:
  ```hs
  data Relation = Ind | RGT | RLT
    deriving (Eq, Read, Show)
  ```
  Este es un tipo algebraico de suma, ya que:

  El tipo Relation puede tomar una de varias alternativas posibles y las alternativas son mutuamente excluyentes:
  - `Ind`
  - `RGT`
  - `RLT`

  Esto corresponde a un constructor de suma, también conocido como tipo enumerado.


- Constructor de tipo registro
  Se utiliza en la definición de Futoshiki:
  ```hs
  data Futoshiki = Futoshiki {
    size  :: Int,
    cells :: Matrix Int,
    hRel  :: Matrix Relation,
    vRel  :: Matrix Relation
  }
  ```

  Este es un tipo algebraico de producto (record type) porque:

  El constructor Futoshiki agrupa varios campos simultáneamente en una misma instancia de estructura. Cada valor de Futoshiki contiene obligatoriamente todos los campos.

- Constructor de tipo paramétrico de tipo alias
  ```hs
  type Matrix a = [[a]]
  ```

  Este es un constructor de tipo paramétrico porque:

  Matrix depende de un parámetro de tipo `a` sin definir y permite construir matrices de cualquier tipo:
  - `Matrix Int`
  - `Matrix Relation`

- Constructor de tipo recursivo
  Aunque no se definen explícitamente, se usan estructuras de listas:

  - `[[a]] (Matrix)`
  - `[Int]`
  - `[(Int, Int)]`

  Las listas en Haskell son un tipo algebraico recursivo definido como:

  ```hs
  data [a] = [] | a : [a]
  ```

  Esto implica:
  - Constructor base: []
  - Constructor recursivo: (:)

  Las matrices y filas del Futoshiki están construidas sobre listas, que son inherentemente recursivas.
