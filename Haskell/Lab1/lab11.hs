import Data.List

filter1 :: [Int] -> [Int] -> [Int]
filter1 [] y = reverse y
filter1 (x:xs) y
	| x `elem` y = filter1 xs y
	| otherwise = filter1 xs (x : y) 

kmaxsubunique :: [Int] -> Int -> [(Int, Int, Int)]
kmaxsubunique x y = take y $ reverse $ sort (rec 0 0 (filter1 x []))
	
rec :: Int -> Int -> [Int] -> [(Int, Int, Int)]
rec _ _ [] = []
rec x y z
	| (y == (length z) && x /= (length z)) = rec (x+1) (x+1) z  
	| x == (length z-1) = [calcTrip x y z]
	| otherwise = (calcTrip x y z):(rec x (y+1) z) 

calcTrip :: Int -> Int -> [Int] -> (Int, Int, Int)
calcTrip x y z = (sum $ drop x $ take (y+1) z, x+1, y+1)



