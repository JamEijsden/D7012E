 :- [lab4_legalMove, lab4_makeMove, lab4_bestMove, lab4_findMoves].


%legalTest((white, d, 4), [,(white,f,2),(black,e,3),(black,c,3),(white,b,2),(black,c,5),(white,b,6),(white,f,6), (black,e,5)],Out,Dir).

settings:-
set_prolog_flag(toplevel_print_options, [quoted(true), portray(true), max_depth(1000), priority(699)]).


validInput(C, X ,Y, Board):-
	C == black,
	Board \== [],
	nonvar(X),
	char_type(X, alpha),
	integer(Y),
	char_code(X,X1),
	X1 < 105,
	X1 > 96,
	Y > 0,
	Y < 9 
	;
	C == white,
	Board \== [],
	nonvar(X),
	char_type(X, alpha),
	integer(Y),
	char_code(X,X1),
	X1 < 105,
	X1 > 96,
	Y > 0,
	Y < 9
	;
	not(nonvar(X)),
	integer(Y),
	Y > 0,
	Y < 9, 
	Board \== []
	;
	not(nonvar(X)),
	not(nonvar(Y)),
	Board \== []
	;
	not(nonvar(Y)),
	char_type(X, alpha),
	char_code(X,X1),
	X1 < 105,
	X1 > 96,
	Board \== [].

%Place brick X on Board
placeOnBoard(X, Board, [X | Board]).

%Member which returns brick at fail/success
nmember((_, X, Y), [(C, X, Y) | _], (C, X, Y)).
nmember(X, [_ | Tail], Return):-
	nmember(X, Tail, Return).

isOccupied((_,X,Y), [(C, X, Y) | _], (C,X,Y)).

isOccupied((_,X,Y), [(_,X1,Y1) | Board], By):-
	Y \== Y1,
	X \== X1,
	isOccupied((_,X,Y), Board, By)
	/*;
	X == Y1,
	Y \== Y1,
	isOccupied((_,X,Y), Board, By)
	;
	Y == Y1,
	X \== X1,
	isOccupied((_,X,Y), Board, By)*/.
/*
findall((X,Y),findbestmove(white,[(white,a,1),(black,a,2),(black,b,1),(black,b,2)],1, X, Y), BestMoves).
findall((X,Y),findbestmove(white,[(white,d,4),(white,e,5),(black,e,4),(black,d,5)],1, X, Y), BestMoves).

*/


detectCheat([(X,Y) | Moves], Board, New):-
	isOccupied((_,X,Y), Board,_),
	detectCheat(Moves, Board, New).
detectCheat([(X,Y) | Moves], Board, [(X,Y) | New]):-
	not(isOccupied((_,X,Y), Board,_)),
	detectCheat(Moves, Board, New).
detectCheat([], _, []).

/* Make N moves. */
makemoves(Color, Board, N, Moves, NewBoard):-
	nextMove(Color, Board, N, Moves, NewBoard).

nextMove(white, Board, N, [(white, X1, Y1) | Moves], List):-
	N > 0,
	findall((X,Y),findbestmove(white,Board,N, X, Y), Filter),
	uniq(Filter, Uni),
	detectCheat(Uni, Board, BestMoves),
	getMove(BestMoves, _, (X1,Y1)),
	writef('%q\t%q%q',[Board,X1,Y1]),
	makemove(white, Board, X1, Y1, NewBoard),
	N1 is N-1,
	print(NewBoard),
	nextMove(black, NewBoard, N1, Moves, List).
nextMove(black, Board, N, [(black, X1, Y1) | Moves], List):-
	N > 0,
	findall((X,Y),findbestmove(black,Board,N, X, Y), Filter),
	uniq(Filter, Uni),
	detectCheat(Uni, Board, BestMoves),
	getMove(BestMoves, _, (X1,Y1)),
	writef('%q\t%q%q',[Board,X1,Y1]),
	makemove(black, Board, X1, Y1, NewBoard),
	N1 is N-1,
	print(NewBoard),
	nextMove(white, NewBoard, N1, Moves, List).
	
nextMove(_, Board, 0, [], Board).

/*
print(Board):-
	printBoard(Board),!.
*/

%Used by findbestmove 
makemoves2(Color, Board, N, Moves, NewBoard):-
	nextMove2(Color, Board, N, Moves, NewBoard).

nextMove2(white, Board, N, [(white, X, Y) | Moves], List):-
	N > 0,
	findMoves(white, Board, AvailableMoves),
	getMove(AvailableMoves, _, (X,Y)),
	makemove(white, Board, X, Y, NewBoard),
	N1 is N-1,
	nextMove2(black, NewBoard, N1, Moves, List).
nextMove2(black, Board, N, [(black, X, Y) | Moves], List):-
	N > 0,
	findMoves(black, Board, AvailableMoves),
	getMove(AvailableMoves, _, (X,Y)),
	makemove(black, Board, X, Y, NewBoard),
	N1 is N-1,
	nextMove2(white, NewBoard, N1, Moves, List).
	
nextMove2(_, Board, 0, [], Board).


%Gets a valid move and uses that in nextMove*
getMove([M | _], _, M).
getMove([_ | Moves], _, MoveOut):-
	getMove(Moves, 1, MoveOut).
getMove([], Flag, (n,n)):-
	Flag \== 1.


makemove(_, Board, n, n, Board).

makemove(Color, Board, X, Y, NewBoard):-
	legalmove(Color, Board, X, Y),
	X \== n,
	Move = (Color, X, Y),
	checkMove(Move, Board, _, NewBoard).
	
	

legalmove(Color, Board, X, Y):-
	validInput(Color, X, Y, Board),
	findMoves(Color, Board, LegalMoves),
	!,
	member((X,Y), LegalMoves).

find(X, [X | _]).
find(X, [_ | Rest]):-
	find(X, Rest).

%legalTest((black, d, 4), [(white,c,3),(white,d,3),(white,e,3),(white,e,4),(white,e,5),(white,d,5),(white,c,5),(white,c,4),(black, d,2),(black, f,4), (black,d,6), (black, b,4), (black,b,2), (black,f,2),(black,f,6),(black,b,6)],Out,Dir).
%legalTest((white, h, 1), [,(white,e,4),(black,f,3),(black,g,2)],Out,Dir).

checkMove(Test, Board, AllChains, NewBoard):-
	chainStart(Test, Board, _, Possible),
	findAllChains(Possible, Board, AllChains, NoChains),
	placeOnBoard(Test, NoChains, NoChainsFull),
	newBoard(AllChains, NoChainsFull,NewBoard),!.
	


%Checks if bricks are neighbours
compLeft(X1, X2):-
	char_code(X1, X1_Code), char_code(X2, X2_Code),
	X2_Sum is X2_Code+1,
	X1_Code == X2_Sum.
compRight(X1,X2):-
	char_code(X1, X1_Code), char_code(X2, X2_Code),
	X2_Sum is X2_Code-1,
	X1_Code == X2_Sum.
compUp(X1,X2):-
	X2_Sum is X2+1,
	X1 == X2_Sum.
compDown(X1,X2):-
	X2_Sum is X2-1,
	X1 == X2_Sum.
compUpLeft(X1,X2,Y1,Y2):-
	char_code(X1, X1_Code), char_code(X2, X2_Code),
	X2_Sum is X2_Code+1,
	Y2_Sum is Y2+1,
	(X1_Code,Y1) == (X2_Sum,Y2_Sum).
compDownLeft(X1,X2,Y1,Y2):-
	char_code(X1, X1_Code), char_code(X2, X2_Code),
	X2_Sum is X2_Code+1,
	Y2_Sum is Y2-1,
	(X1_Code,Y1) == (X2_Sum,Y2_Sum).
compUpRight(X1,X2,Y1,Y2):-
	char_code(X1, X1_Code), char_code(X2, X2_Code),
	X2_Sum is X2_Code-1,
	Y2_Sum is Y2+1,
	(X1_Code,Y1) == (X2_Sum,Y2_Sum).
compDownRight(X1,X2,Y1,Y2):-
	char_code(X1, X1_Code), char_code(X2, X2_Code),
	X2_Sum is X2_Code-1,
	Y2_Sum is Y2-1,
	(X1_Code,Y1) == (X2_Sum,Y2_Sum).