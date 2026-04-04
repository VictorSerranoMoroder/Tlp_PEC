-- std::function<int(int)> add(int);
add :: Int -> Int -> Int
add a b = a + b

main = do
    let a = add 1 3
    putStrLn (show a)