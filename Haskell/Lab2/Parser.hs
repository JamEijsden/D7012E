module Parser(module CoreParser, T, digit, digitVal, chars, letter, err,
              lit, number, iter, accept, require, token,
              spaces, word, (-#), (#-)) where
import Prelude hiding (return, fail)
import Data.Char
import CoreParser
infixl 7 -#, #- 

type T a = Parser a

err :: String -> Parser a
err message cs = error (message++" near "++cs++"\n")

iter :: Parser a -> Parser [a]  
iter m = m # iter m >-> cons ! return [] 

cons(a, b) = a:b

(-#) :: Parser a -> Parser b -> Parser b
(m -# n) cs = ((m # n) >-> snd) cs
--m -# n = error "#- not implemented"


(#-) :: Parser a -> Parser b -> Parser a
(m #- n) cs = ((m # n) >-> fst) cs


spaces :: Parser String
spaces cs = iter (char ? isSpace) cs
	

token :: Parser a -> Parser a
token m = m #- spaces

letter :: Parser Char
letter = char ? isAlpha

word :: Parser String
word = token (letter # iter letter >-> cons)

chars :: Int -> Parser String
chars 0 = return []
chars n = char # chars (n-1) >-> cons

accept :: String -> Parser String
accept w = (token (chars (length w))) ? (==w)


--------------- with Just and Nothing -----------
require' :: String -> Parser String
require' w q =
	case accept w q of
	Nothing -> error ("expecting " ++ w ++ " near " ++ q)
	Just(a,b) -> Just(a,b)
-------------------------------------------------

require :: String -> Parser String
require w q
	|	w == sq = accept w q
	|	otherwise = error ("expecting " ++ w ++ " near " ++ q)
	where sq = take (length w) q

lit :: Char -> Parser Char
lit c = token char ? (==c)

digit :: Parser Char 
digit = char ? isDigit 

digitVal :: Parser Integer
digitVal = digit >-> digitToInt >-> fromIntegral

number' :: Integer -> Parser Integer
number' n = digitVal #> (\ d -> number' (10*n+d))
          ! return n
		  
number :: Parser Integer
number = token (digitVal #> number')





		 



