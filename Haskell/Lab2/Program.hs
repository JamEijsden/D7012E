module Program(T, parse, fromString, toString, exec) where
import Parser hiding (T)
import qualified Statement
import qualified Dictionary
import Prelude hiding (return, fail)
newtype T = Program [Statement.T] -- to be defined


instance Parse T where
  parse = (iter Statement.parse) >-> Program
  --error "Program.parse not implemented"
  toString = error "Program.toString not implemented"



exec(Program st) num = Statement.exec st Dictionary.empty num
