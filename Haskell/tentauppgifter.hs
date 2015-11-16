data BinTree a = Edge | Node a (BinTree a) (BinTree a) 

etree = Node 5 (Node 3 (Node 1 Edge Edge) (Node 4 Edge Edge)) (Node 7 Edge Edge)

countnodes :: BinTree a -> Int
countnodes Edge = 0  
countnodes (Node a n1 n2) = 1 + (countnodes n1) + (countnodes n2)
 
printTree Edge = " edge "
printTree (Node x a b) = "Node " ++ (show x) ++ " ( " ++ (printTree a) ++ " )    ( " ++ (printTree b) ++ " )"



--Lookup nodes in Binary Tree
lookupnode :: Ord a => BinTree a -> a -> Bool
lookupnode (Node y a b) x
	| x == y = True
	| otherwise = (lookupnode a x) || (lookupnode b x)
lookupnode Edge _ = False



insert :: Ord a => BinTree a -> a -> BinTree a 
insert (Node x a b) y 
	| x <= y = (Node x a (insert b y))
	| otherwise = (Node x (insert a y) b)
insert Edge y = (Node y Edge Edge)




qsort :: Ord a => [a] -> [a]
qsort [] = [] 
qsort (x:xs) = qsort small ++ [x] ++ qsort large
    where
      small = [y | y<-xs, y<=x]
      large = [y | y<-xs, y>x]



--getinput lst = do
--	putStrLn ("Who's your daddy?")
--	input <- getLine
--		| input /= "0" = getinput (qsort (input:lst))
--		| otherwise = putStrLn input


mergesort'merge :: (Ord a) => [a] -> [a] -> [a]
mergesort'merge [] xs = xs
mergesort'merge xs [] = xs
mergesort'merge (x:xs) (y:ys)
    | (x < y) = x:mergesort'merge xs (y:ys)
    | otherwise = y:mergesort'merge (x:xs) ys
 
mergesort'splitinhalf :: [a] -> ([a], [a])
mergesort'splitinhalf xs = (take n xs, drop n xs)
    where n = (length xs) `div` 2 
 
mergesort :: (Ord a) => [a] -> [a]
mergesort xs 
    | (length xs) > 1 = mergesort'merge (mergesort ls) (mergesort rs)
    | otherwise = xs
    where (ls, rs) = mergesort'splitinhalf xs





maxim = maxim' 0		
maxim' x = do
		putStrLn "Enter a number"
		y <- getLine
		let n = (read y :: Int)
		if n > 0
			then if n > x
				then maxim' n
				else maxim' x
			else do
				putStrLn ("\nBiggest Number: " ++ (show x))  

comp (x:xs) = foldr (\x xs -> x : xs) xs 

mult1 x = x*2 
mult2 x = x*3

every3 = enumBy 0 3
	where enum n m= = n : enumBy (n+m) m