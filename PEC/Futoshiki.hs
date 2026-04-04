module Futoshiki where

import Data.List (nub, transpose)

-- Bidimensional Matrix --
type Matrix a = [[a]]

-- Relation between cells --
data Relation = Ind | RGT | RLT
  deriving (Eq, Read, Show)

-- Futoshiki definition --
data Futoshiki = Futoshiki {
  size  :: Int,
  cells :: Matrix Int,
  hRel  :: Matrix Relation,
  vRel  :: Matrix Relation
}
  deriving (Eq, Read, Show)

-- Función de backtracking genérica --
-- Explora un árbol de búsqueda completo (DFS) y devuelve todas las soluciones.
-- Paso 1: Comprueba si es solucion (esSol n)
-- Paso 2: Genera los hijos (succ n :: [a]) con todos los posibles estados siguientes del problema
-- Paso 3: Explora recusivamente (map (bt esSol succ) (succ n)) para cada hijo vuelve a aplicar el algoritmo
-- Paso 4: Aplanar resultados (concat...)
bt :: (a -> Bool) -> (a -> [a]) -> a -> [a] -- Recorrido y colectar soluciones
bt    esSol          succ          n
  | esSol n                           = [n] -- Comprueba si es solucion
  | otherwise                         = concat (map (bt esSol succ) (succ n)) -- Explora recursivamente

-- 1. Función que dado un nodo (es decir, un elemento de tipo Futoshiki) nos diga si ya es una solución o no.
-- Condiciones:
--    - El tablero está completo
--    - Las filas no contienen valores repetidos
--    - Las columnas no contienen valores repetidos
--    - Las relaciones se respetan

-- @brief
-- @details
-- @param[in]
-- @return
esSol :: Futoshiki -> Bool -- Condicion de parada 
esSol f =
    isComplete (f) &&
    areRowsUnique (f) &&
    areColumnsValid (f) &&
    areRelationsValid (f)
--- @brief Check if the Futoshiki is complete
--- @details
--- @param[in]  Futoshiki
--- @return   Whether or not the futoshiki is complete
isComplete :: Futoshiki -> Bool -- Type Signature (Function receives Futoshiki returns bool)
isComplete f = 
    let values = concat (cells f) -- Returns [Int]
    in all (/= 0) values -- all returns true if all elements are true to the condition

--- @brief Check if the given rows from a futoshiki are unique
--- @details
--- @param[in]  Futoshiki
--- @return   Whether or not the futoshiki rows contain unique values
areRowsUnique :: Futoshiki -> Bool
areRowsUnique f = -- f is the full board
    -- cells :: Futoshiki -> Matrix Int
    -- cells f :: [[Int]]
    let rows = cells f 
    in all isRowValid (rows) -- Check condition for all rows

--- @brief Check if the given columns from a futoshiki are unique
--- @details
--- @param[in]  Futoshiki
--- @return   Whether or not the futoshiki columns contain unique values
areColumnsValid :: Futoshiki -> Bool
areColumnsValid f =
    -- cells :: Futoshiki -> Matrix Int
    -- cells f :: [[Int]]
    let columns = transpose (cells f) -- transpose converts rows into columns
    in all isRowValid (columns) -- Check condition for all columns

--- @brief Check if a list contains unique numbers (ignoring zeros)
--- @details
--- @param[in] A list of integers
--- @return   Whether or not the list does not contain duplicates
isRowValid :: [Int] -> Bool
isRowValid row = -- row = [Int]
    let filtered_row = filter (/= 0) row -- Remove all elements that are 0 from the list
    -- nub removes duplicates
    -- compares the lengths of the original row with the one without duplicates 
    in length filtered_row == length (nub filtered_row) 

--- @brief Check if Futoshiki relationships are being respected
--- @details
--- @param[in] Futoshiki
--- @return   Whether or not the relationships are being respected
areRelationsValid :: Futoshiki -> Bool
areRelationsValid f = 
    -- cells :: Futoshiki -> Matrix Int
    -- cells f :: [[Int]]
    let futoshiki_size = size f -- Futoshiki size to generate the indices
      horizontalCheck = -- [Bool] of results created using [List Comprehension](https://wiki.haskell.org/List_comprehension)  
        [ checkRelation (cells f !! ri !! ci)      -- Left number of the horizontal pair
                        (cells f !! ri !! (ci+1))  -- Right number of the horizontal pair (ci+1)
                        (hRel f !! ri !! ci)       -- Relation between both
        | ri <- [0..futoshiki_size-1] -- iterate through rows
        , ci <- [0..futoshiki_size-2]  -- iterate through pairs of horizontal neighbors in that row
        ]
      verticalCheck = -- [Bool] of results created using [List Comprehension](https://wiki.haskell.org/List_comprehension)  
        [ checkRelation (cells f !! ri !! ci)      -- Left number of the vertical pair
                        (cells f !! (ri+1) !! ci)  -- Right number of the vertical pair (ri+1)
                        (vRel f !! ri !! ci)       -- Relation between both 
      | ri <- [0..futoshiki_size-2] -- iterates over rows except the last
      , ci <- [0..futoshiki_size-1] -- iterate through all columns
      ]
    -- Will return true if all relations are valid
    in all id horizontalCheck && all id verticalCheck


--- @brief Check if a relation is being respected
--- @details
--- @param[in] Value A
--- @param[in] Value B
--- @param[in] Type of relation
--- @return   Whether or not the relation is being respected
checkRelation :: Int -> Int -> Relation -> Bool
checkRelation a b rel 
    | a == 0 || b == 0 = True     -- Ignore expression if any component is 0
    | a > b && rel == RLT = True  -- Check RLT relation
    | a < b && rel == RGT = True  -- Check RGT relation
    | rel == Ind = True           -- Check Ind relation
    | otherwise = False           -- Otherwise the relation is not being satisfied

-- 2. Una función que dado un nodo nos devuelva su lista de nodos hijos.
-- Paso 1: Buscar una celda vacía
-- Paso 2: Probar valores
-- Paso 3: Generar nuevos Futoshikis

-- La función succ toma cualquier cosa que tenga definido un sucesor y devuelve ese sucesor.
-- Debemos de definir una función propia para devolver los sucesores
succ :: Futoshiki -> [Futoshiki]

-- Main function: solves a Futoshiki --
solve :: Futoshiki -> [Matrix Int]
solve f = map cells (bt esSol succ f)

