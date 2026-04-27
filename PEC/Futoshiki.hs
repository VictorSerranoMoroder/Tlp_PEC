module Futoshiki where

import Data.List (nub, transpose, findIndex)

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


------------------------------
-- Backtracking
------------------------------


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


------------------------------
-- Solution check
------------------------------

-- | Checks whether a Futoshiki board is completely filled.
--
-- Note: This function does NOT verify correctness of constraints,
-- only that there are no empty cells.
esSol :: Futoshiki -> Bool
esSol f =
    let values = concat (cells f) -- Returns [Int]
    in all (/= 0) values          -- all returns true if all elements are true to the condition

------------------------------
-- Successor generation (with pruning)
------------------------------

-- | Generates all possible states of the board filling the next empty cell with valid values
--
-- For the next empty position:
-- - Tries all possible values from 1 to size
-- - Filters out invalid states using 'isValid'
--
-- Early pruning and validation is produced here
-- Returns an updated and **valid** state of the Futoshiki
succ :: Futoshiki -> [Futoshiki]
succ f =
  case findEmptyCell f of -- Returns an optional value with the new empty cell
        Nothing -> []       -- No empty cell is found
        Just (ri, ci) ->    -- An empty cell is found at coordinates (ri,ci)
          let tryValue v =  -- Create "transform" function for each tried value
                let newBoard = updateCell f (ri,ci) v   -- Create a new Futoshiki with a new value
                in if isValid newBoard (ri,ci)            -- Check if the assigned value mantains the correctness
                    then Just newBoard                    -- If valid, create new Futoshiki with new value
                    else Nothing                          -- Otherwise discard Futoshiki (Early pruning)
          in [ board                     -- In case a new Futoshiki has been created
          | v <- [1 .. size f]           -- Fill v with all possible values
          , Just board <- [tryValue v]   -- For each value try it
          ]

-- | Finds the next empty cell coordinates
--
-- Returns its coordinates (row, column), or Nothing if full.
findEmptyCell :: Futoshiki -> Maybe (Int, Int)
findEmptyCell f =
  findInRows (zip [0..] (cells f)) -- Generates a zipped list of (rowIdx, row) :: [(Int, [Int])]
  where -- Declare an inside function
    findInRows :: [(Int, [Int])] -> Maybe (Int, Int)
    findInRows [] = Nothing           -- No empty cells found
    findInRows ((ri,row):rs) =        -- ri is current row index, row is current row, and rs is the remainder
      case findIndex (==0) row of   -- If it finds a cell with a 0 then look for the column index
        Nothing -> findInRows rs  -- No 0 in this row, call function recursively
        Just ci -> Just (ri, ci)  -- 0 found, return coordinates

------------------------------
-- Board manipulation
------------------------------

-- | Updates a specific cell in the board with a new value.
--
-- Returns a new Futoshiki instance with the updated cell.
updateCell :: Futoshiki -> (Int, Int) -> Int -> Futoshiki
updateCell f (r,c) val =
  let board = cells f
      row = board !! r                    -- Retrieve the complete row
      newRow = replaceAt c val row        -- Create a new row with the value in column (index) c changed to given valur
      newBoard = replaceAt r newRow board -- Replace the original row with the updated row
  in Futoshiki                            -- Return new Futoshiki, size and relations stay unchanged and can be retrieved directly from the original Futoshiki
      (size f)
      newBoard
      (hRel f)
      (vRel f)

-- | Replaces the element at a given index in a list.
--
-- This function takes an index, a value and a list and returns a list where the element at the given index is replaced with the provided value.
-- It works by recursively transversing the list until it reaches the specified index, replaces the element and reconstructs the list with the updated value.
replaceAt :: Int -> a -> [a] -> [a]
replaceAt _ _ [] = []                           -- If list is empty return an empty list
replaceAt 0 val (_:xs) = val : xs               -- If index is 0 then just change first value
replaceAt i val (x:xs)                          -- Otherwise
  | i < 0     = x : xs                          -- If index is negative return original list (should not happen)
  | otherwise = x : replaceAt (i - 1) val xs    -- Recursive case, mantains first element and call recursively updating the elements

------------------------------
-- Validation
------------------------------

-- | Checks if an cell meets all the required conditions with its neighbours
-- Validity conditions:
-- - No duplicates in the row
-- - No duplicates in the column
-- - All neighbour relations are satisfied
isValid :: Futoshiki -> (Int, Int) -> Bool
isValid f (ri,ci) =
  let board = cells f                             -- Defines a board made of the cells from the Futoshiki
      rowOk = isRowValid (board !! ri)            -- Checks if row ri is valid
      colOk = isRowValid (transpose board !! ci)  -- Checks if column ci is valid
  in rowOk &&
     colOk &&
     checkNeighbourRelations f (ri,ci)  -- Checks if neighbour relations are being respected

-- | Check if a list contains unique numbers (ignoring zeros)
isRowValid :: [Int] -> Bool
isRowValid row = -- row = [Int]
    let filtered_row = filter (/= 0) row -- Remove all elements that are 0 from the list
    -- nub removes duplicates
    -- compares the lengths of the original row with the one without duplicates
    in length filtered_row == length (nub filtered_row)

-- | Checks all neighbour relations for a given cell.
--
-- Ensures that horizontal and vertical constraints are satisfied with adjacent cells
checkNeighbourRelations :: Futoshiki -> (Int, Int) -> Bool
checkNeighbourRelations f (r,c) =
  let
    -- Prepare variables
    board = cells f                         -- Board is retrieved from the cells from the futoshiki
    n = size f                              -- Size of the futoshiki
    val = board !! r !! c                   -- Current value

    -- Check left neighbour
    leftCheck =
      if c > 0 then                         -- If its NOT the first column
        let leftVal = board !! r !! (c-1)   -- Retrieve value from left cell
            rel     = hRel f !! r !! (c-1)  -- Retrieve relation with its left cell
        in checkRelation leftVal val rel    -- Perform relation check [(left) rel (current)]
      else True                             -- If it is the first column, there is no left neighbour

    -- Check right neighbour
    rightCheck =
      if c < n - 1 then                     -- If it is NOT the last column
        let rightVal = board !! r !! (c+1)  -- Retrieve value from the right cell
            rel      = hRel f !! r !! c     -- Retrueve relation with its right cell
        in checkRelation val rightVal rel   -- Perform relation check [(current) rel (right)]
      else True                             -- If it is the last column, there is no right neighbour

    -- Check top neighbour
    upCheck =
      if r > 0 then                         -- If its NOT the first row
        let topVal = board !! (r-1) !! c    -- Retrieve value from top cell
            rel    = vRel f !! (r-1) !! c   -- Retrieve relation with its top cell
        in checkRelation topVal val rel     -- Perform relation check [(top) rel (current)]
      else True                             -- If it is the first row, there is no top neighbour

    -- Check bottom neighbour
    downCheck =
      if r < n - 1 then                     -- If its NOT the last row
        let downVal = board !! (r+1) !! c   -- Retrieve value from the bottom cell
            rel    = vRel f !! r !! c       -- Retrieve relation with its bottom cell
        in checkRelation val downVal rel    -- Perform relation check [(current) rel (down)]
      else True                             -- If it is the last row, there is no bottom neighbour

  in leftCheck && rightCheck && upCheck && downCheck  -- Check that all conditions are met

-- | Check if a relation is being respected
-- If either value is 0 (empty), the relation is ignored
checkRelation :: Int -> Int -> Relation -> Bool
checkRelation a b rel
  | a == 0 || b == 0 = True     -- Ignore expression if any component is 0
  | a < b && rel == RLT = True  -- Check RLT relation
  | a > b && rel == RGT = True  -- Check RGT relation
  | rel == Ind = True           -- Check Ind relation
  | otherwise = False           -- Otherwise the relation is not being satisfied

-- | Main function: solves a Futoshiki
--
-- Takes a Futoshiki puzzle and returns all its solutions as matrices of integers
solve :: Futoshiki -> [Matrix Int]
-- map cells: after bt returns all solutions as [Futoshiki] maps transforms them into [Matrix Int]
-- (bt esSol Futoshiki.succ f):
--    1. Starts from puzzle `f`
--    2. Generates next states
--    3. Explore until esSol == true
--    4. Returns all solution states
solve f = map cells (bt esSol Futoshiki.succ f)
