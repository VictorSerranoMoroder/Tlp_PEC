
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

### 1.b

### 1.c

### 1.d

## Ejercicio 2 de la práctica
Indique qué clases de constructores de tipos (ver capítulo 5 del libro de la
asignatura) se han utilizado para definir los tipos de datos presentes en el módulo
Futoshiki. Justifique sus respuestas.