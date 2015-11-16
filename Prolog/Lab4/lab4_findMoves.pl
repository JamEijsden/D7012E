/*Find all legal moves, looking at a color
*/
findMoves(Color ,Board, Uniques):-
	seperateCs(Board, Whites, Blacks),
	chooseColorlist(Color, Whites, Blacks, ColorList),
	checkClose(Color, Board, ColorList, Board, Legal),
	delete(Legal, [], NLegal),
	append(NLegal,Out),
	uniq(Out,Uniques).

uniq(Data,Uniques) :- 
	sort(Data,Uniques).

chooseColorlist(white,Whites, _, Whites).
chooseColorlist(black, _, Blacks, Blacks).


/* If you want to find white brick moves, this function looks at blacks bricks, vice versa, 
	to later find a chain starting from that black brick.
*/
checkClose(C, [(C1, X, Y) | Board], Match, [_ |Start], [Move | Legal]):-
	C \== C1,
	findStart((C1, X, Y), Board, Match, _,Move),
	nonvar(Move),
	append(Board, [(C1,X,Y)], NewBoard),
	checkClose(C, NewBoard, Match, Start, Legal),!.
checkClose(C, [(C1, X, Y) | Board], Match, [_ | Start], Legal):-
	append(Board, [(C1, X, Y)], New),
	checkClose(C, New, Match, Start,Legal).
checkClose(_,_,_,[],[]).


%Seperate black and white bricks
seperateCs([(white,X,Y) | Board], [(white,X,Y) | Whites], Blacks):-
	seperateCs(Board, Whites,Blacks).
seperateCs([(black,X,Y) | Board], Whites, [(black,X,Y) | Blacks]):-
	seperateCs(Board, Whites, Blacks).
seperateCs([],[],[]).
/* Modified code from lab4_makeMove  */


/* ex. Black looks if any white are neighbours if it find one it looks in the opposite way for a chain/legalmove */

findStart((C, X1, Y), Board, [(C1, X2, Y) | Tail], _, [Move | List]):-
	C \== C1,
	compLeft(X1,X2),
	isLegal((C, X1, Y), Board, right, chain, Move),
	findStart((C,X1,Y),Board,Tail, yes, List),!.

findStart((C, X1, Y), Board, [(C1, X2, Y) | Tail], _, [Move | List]):-
	C \== C1,
	compRight(X1,X2),
	isLegal((C, X1, Y), Board, left, chain, Move),
	findStart((C,X1,Y),Board,Tail, yes, List),!.


findStart((C, X, Y1),Board, [(C1, X, Y2) | Tail], _, [Move | List]):-
	C \== C1,
	compUp(Y1,Y2),
	isLegal((C, X, Y1), Board, down, chain, Move),
	findStart((C,X,Y1),Board,Tail, yes, List),!.

findStart((C, X, Y1),Board, [(C1, X, Y2) | Tail], _, [Move | List]):-
	C \== C1,
	compDown(Y1,Y2),
	isLegal((C, X, Y1), Board, up, chain, Move),
	findStart((C,X,Y1),Board,Tail, yes, List),!.

findStart((C, X1, Y1),Board, [(C1, X2, Y2) | Tail], _, [Move | List]):-
	C \== C1,
	compDownLeft(X1,X2,Y1,Y2),
	isLegal((C, X1, Y1), Board, upRight, chain, Move),
	findStart((C,X1,Y1),Board,Tail, yes, List),!.

findStart((C, X1, Y1),Board, [(C1, X2, Y2) | Tail], _, [Move | List]):-
	C \== C1,
	compUpLeft(X1,X2,Y1,Y2),
	isLegal((C, X1, Y1), Board, downRight, chain, Move),
	findStart((C,X1,Y1),Board,Tail, yes, List),!.

findStart((C, X1, Y1),Board, [(C1, X2, Y2) | Tail], _, [Move | List]):-
	C \== C1,
	compDownRight(X1,X2,Y1,Y2),
	isLegal((C, X1, Y1), Board, upLeft, chain, Move),
	findStart((C,X1,Y1),Board,Tail, yes, List),!.

findStart((C, X1, Y1),Board, [(C1, X2, Y2) | Tail], _, [Move | List]):-
	C \== C1,
	compUpRight(X1,X2,Y1,Y2),
	isLegal((C, X1, Y1), Board, downLeft, chain, Move),
	findStart((C,X1,Y1),Board,Tail, yes, List),!.

findStart((C, X1, Y1), Board, [(C1, X2, Y2) | Tail], Found, Legal):-
	findStart((C,X1,Y1), Board, Tail, Found, Legal).
findStart(X, Board, [], yes, []).



/* Find chain and when chain end returns legalmove else fail */

isLegal((C,X,Y),Board, right, chain, Legal):-
	char_code(X, X1_Code),
	X1 is X1_Code + 1,
	char_code(Move_X2,X1),
	%isOccupied((C, Move_X2, Y), Board, (C, X2, Y2)),
	nmember((_, Move_X2, Y), Board, (C1, _ , _)),
	C == C1,
	isLegal((C,Move_X2,Y), Board, right, chain, Legal).
isLegal((C,X,Y), Board, right, chain, Move):-
	char_code(X, X1_Code),
	X1 is X1_Code + 1,
	char_code(Move_X2,X1),
	%not(isOccupied((C,Move_X2,Y), Board, _)),
	not(nmember((_, Move_X2, Y), Board,_)),
	validInput(C,Move_X2,Y,Board),
	Move = (Move_X2,Y),!.

isLegal((C,X,Y),Board, left, chain, Legal):-
	char_code(X, X1_Code),
	X1 is X1_Code - 1,
	char_code(Move_X2,X1),
	%isOccupied((C, Move_X2, Y), Board, (C, X2, Y2)),
	nmember((_, Move_X2, Y), Board,(C1, _ , _)),
	C == C1,
	isLegal((C,Move_X2,Y), Board, left, chain, Legal).
isLegal((C,X,Y), Board, left, chain, Move):-
	char_code(X, X1_Code),
	X1 is X1_Code - 1,
	char_code(Move_X2,X1),
	%not(isOccupied((C,Move_X2,Y), Board, _)),
	not(nmember((_, Move_X2, Y), Board,_)),
	validInput(C,Move_X2,Y,Board),
	Move = (Move_X2,Y),!.

isLegal((C,X,Y),Board, down, chain, Legal):-
	Y1 is Y +1,
	%isOccupied((C, X, Y1), Board, (C, X2, Y2)),
	nmember((_, X, Y1), Board, (C1, _ , _)),
	C == C1,
	isLegal((C,X,Y1), Board, down, chain, Legal).
isLegal((C,X,Y), Board, down, chain, Move):-
	Y1 is Y +1,
	%not(isOccupied((C,X,Y1), Board, _)),
	not(nmember((_, X, Y1), Board,_)),
	validInput(C,X,Y1,Board),
	Move = (X,Y1),!.

isLegal((C,X,Y),Board, up, chain, Legal):-
	Y1 is Y -1,
	%isOccupied((C, X, Y1), Board, (C, X2, Y2)),
	nmember((_, X, Y1), Board, (C1, _ , _)),
	C == C1,
	isLegal((C,X,Y1), Board, up, chain, Legal).
isLegal((C,X,Y), Board, up, chain, Move):-
	Y1 is Y -1,
	%not(isOccupied((C,X,Y1), Board, _)),
	not(nmember((_, X, Y1), Board,_)),
	validInput(C,X,Y1,Board),
	Move = (X,Y1),!.

isLegal((C,X,Y),Board, upRight, chain, Legal):-
	char_code(X, X1_Code),
	X1 is X1_Code + 1,
	Y1 is Y -1,
	char_code(Move_X2,X1),
	%isOccupied((C, Move_X2, Y1), Board, (C, X2, Y2)),
	nmember((_, Move_X2, Y1), Board, (C1, _ , _)),
	C == C1,
	isLegal((C,Move_X2,Y1), Board, upRight, chain, Legal).
isLegal((C,X,Y), Board, upRight, chain, Move):-
	char_code(X, X1_Code),
	X1 is X1_Code + 1,
	Y1 is Y -1,
	char_code(Move_X2,X1),
	%not(isOccupied((C,Move_X2,Y1), Board, _)),
	not(nmember((_, Move_X2, Y1), Board,_)),
	validInput(C,Move_X2,Y1,Board),
	Move = (Move_X2,Y1),!.

isLegal((C,X,Y),Board, downRight, chain, Legal):-
	char_code(X, X1_Code),
	X1 is X1_Code + 1,
	Y1 is Y +1,
	char_code(Move_X2,X1),
	%isOccupied((C, Move_X2, Y1), Board, (C, X2, Y2)),
	nmember((_, Move_X2, Y1), Board,(C1, _ , _)),
	C == C1,
	isLegal((C,Move_X2,Y1), Board, downRight, chain, Legal).
isLegal((C,X,Y), Board, downRight, chain, Move):-
	char_code(X, X1_Code),
	X1 is X1_Code + 1,
	Y1 is Y +1,
	char_code(Move_X2,X1),
	%not(isOccupied((C,Move_X2,Y1), Board, _)),
	not(nmember((_, Move_X2, Y1), Board,_)),
	validInput(C,Move_X2,Y1,Board),
	Move = (Move_X2,Y1),!.

isLegal((C,X,Y),Board, downLeft, chain, Legal):-
	char_code(X, X1_Code),
	X1 is X1_Code - 1,
	Y1 is Y +1,
	char_code(Move_X2,X1),
	%isOccupied((C, Move_X2, Y1), Board, (C, X2, Y2)),
	nmember((_, Move_X2, Y1), Board,(C1, _ , _)),
	C == C1,
	isLegal((C,Move_X2,Y1), Board, downLeft, chain, Legal).
isLegal((C,X,Y), Board, downLeft, chain, Move):-
	char_code(X, X1_Code),
	X1 is X1_Code - 1,
	Y1 is Y +1,
	char_code(Move_X2,X1),
	%not(isOccupied((C,Move_X2,Y1), Board, _)),
	not(nmember((_, Move_X2, Y1), Board,_)),
	validInput(C,Move_X2,Y1,Board),
	Move = (Move_X2,Y1),!.

isLegal((C,X,Y),Board, upLeft, chain, Legal):-
	char_code(X, X1_Code),
	X1 is X1_Code - 1,
	Y1 is Y -1,
	char_code(Move_X2,X1),
	%isOccupied((C, Move_X2, Y1), Board, (C, X2, Y2)),
	nmember((_, Move_X2, Y1), Board, (C1, _ , _)),
	C == C1,
	isLegal((C,Move_X2,Y1), Board, upLeft, chain, Legal).
isLegal((C,X,Y), Board, upLeft, chain, Move):-
	char_code(X, X1_Code),
	X1 is X1_Code - 1,
	Y1 is Y - 1,
	char_code(Move_X2,X1),
	%not(isOccupied((C,Move_X2,Y1), Board, _)),
	not(nmember((_, Move_X2, Y1), Board,_)),
	validInput(C,Move_X2,Y1,Board),
	Move = (Move_X2,Y1),!.



