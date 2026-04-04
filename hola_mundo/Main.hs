-- Main: Punto de entrada
-- IO() significa:
--      Accion que realiza efectos de IO
--      devuelve () == void
main :: IO ()
main = do
    putStrLn "¿Cómo te llamas?"
    name <- getLine
    putStrLn ("Hola " ++ name)