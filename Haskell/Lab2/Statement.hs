module Statement(T, parse, toString, fromString, exec) where
import Prelude hiding (return, fail)
import Parser hiding (T)
import qualified Dictionary
import qualified Expr
type T = Statement
data Statement =
    Assignment String Expr.T |
	Skip |
	Begin [Statement] |
    If Expr.T Statement Statement |
	While Expr.T Statement |
	Read String |
	Write Expr.T
    deriving Show

assignment = 
	word #- accept ":=" # Expr.parse #- require ";" >-> buildAss
buildAss (v, e) = Assignment v e

skip = 
	accept "skip" # require ";" >-> buildSkip
buildSkip _ = Skip

begin = 
	accept "begin" -# (iter parse) #- require "end" >-> Begin

ifstatement = 
	accept "if" -# (Expr.parse #- require "then" # parse) #- require "else" # parse >-> buildIf
buildIf ((e,s1),s2) = If e s1 s2

while = 
	(accept "while" -# Expr.parse #- require "do") # (parse) >-> buildWhile
buildWhile (e, s1) = While e s1

read = 
	accept "read" -# word #- require ";" >-> Read

write = 
	accept "write" -# Expr.parse #- require ";" >-> Write

exec :: [T] -> Dictionary.T String Integer -> [Integer] -> [Integer]
--If
exec (If cond thenStmts elseStmts: stmts) dict input = 
    if (Expr.value cond dict)>0 
    then exec (thenStmts: stmts) dict input
    else exec (elseStmts: stmts) dict input
--Skip
exec (Skip:stmts) dict input = exec stmts dict input
--Begin
exec (Begin (x:xs): stmts) dict input = exec (x:xs++stmts) dict input 
--Assignment
exec (Assignment str expr: stmts) dict input = exec stmts (Dictionary.insert(str, (Expr.value expr dict)) dict) input
--Read
exec (Read var:stmts) dict (h:hs) = exec stmts (Dictionary.insert(var,h) dict) hs 
--Write
exec (Write expr : stmts) dict input = (Expr.value expr dict) :(exec stmts dict input)
--While
exec (While cond st : stmts) dict input = 
	if (Expr.value cond dict)>0 
	then exec (st:(While cond st):stmts) dict input
	else exec stmts dict input 
exec [] dict input = []
instance Parse Statement where
  parse = skip ! Statement.read ! begin ! ifstatement ! while ! Statement.write ! assignment
  
	--error "Statement.parse not implemented"
  
  
  toString = tStr
  
 
tStr (Assignment s e) = s ++ " := " ++ toString e ++ ";n"
tStr (Skip) = "skip;\n"
tStr (While e stmt) = "while " ++ toString e ++ " do " ++ tStr stmt ++ "\n" 
tStr (If e thenStmt elseStmts) = "if " ++ toString e ++ " then " ++ tStr thenStmt ++ " else " ++ tStr elseStmts ++ "\n"
tStr (Begin stmts) = "Begin " ++ tStrRec stmts ++ " end\n"
tStr (Read s) = "read " ++ s ++ ";\n"
tStr (Write e) = "write " ++ toString e ++ ";\n"

--Need special func for begin
tStrRec (stmt:other) = tStr stmt ++  tStrRec other