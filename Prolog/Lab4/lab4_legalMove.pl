
/*
	Finds a chain which is to be flipped
*/

checkChain((C,X1,Y), [(C,X2,Y) | Tail], [Remove | Start], [Move |Ordered], left):- %Checks left chain
	compLeft(X1,X2),
	Move = (C, X2, Y),
	append(Tail, [Move], NBoard),
	checkChain(Move, NBoard, Start, Ordered, left).
checkChain((C1,X1,Y), [(C2, X2,Y) | Tail], Check, Start, left):-
	C1 \== C2,
	compLeft(X1,X2),
	Start = [],!.

/*Check right*/


checkChain((C,X1,Y), [(C,X2,Y) | Tail], [Remove | Start], [Move |Ordered], right):- %Checks left chain
	compRight(X1,X2),
	Move = (C, X2, Y),
	append(Tail, [Move], NBoard),
	checkChain(Move, NBoard, Start, Ordered, right).
checkChain((C1,X1,Y), [(C2, X2,Y) | Tail], Check, Start, right):-
	C1 \== C2,
	compRight(X1,X2),
	Start = [],!.

/*Checks up*/
checkChain((C,X,Y1), [(C,X,Y2) | Tail], [Remove | Start], [Move |Ordered], up):- %Checks left chain
	compUp(Y1,Y2),
	Move = (C, X, Y2),
	append(Tail, [Move], NBoard),
	checkChain(Move, NBoard, Start, Ordered, up).
checkChain((C1,X,Y1), [(C2, X,Y2) | Tail], Check, Start, up):-
	C1 \== C2,
	compUp(Y1,Y2),
	Start = [],!.

/*Checks down*/

checkChain((C,X,Y1), [(C,X,Y2) | Tail], [Remove | Start], [Move |Ordered],down):- %Checks left chain
	compDown(Y1,Y2),
	Move = (C, X, Y2),
	append(Tail, [Move], NBoard),
	checkChain(Move, NBoard, Start, Ordered, down).
checkChain((C1,X,Y1), [(C2, X,Y2) | Tail], Check, Start, down):-
	C1 \== C2,
	compDown(Y1,Y2),
	Start = [],!.

/*And now the diagonal checks*/

/*Up left check*/
checkChain((C,X1,Y1), [(C,X2,Y2) | Tail], [Remove | Start], [Move |Ordered],upLeft):- %Checks left chain
	compUpLeft(X1,X2,Y1,Y2),
	Move = (C, X2, Y2),
	append(Tail, [Move], NBoard),
	checkChain(Move, NBoard, Start, Ordered, upLeft).
checkChain((C1,X1,Y1), [(C2, X2,Y2) | Tail], Check, Start, upLeft):-
	C1 \== C2,
	compUpLeft(X1,X2,Y1,Y2),
	Start = [],!.%,!.

/*Down left check*/
checkChain((C,X1,Y1), [(C,X2,Y2) | Tail], [Remove | Start], [Move | Ordered],downLeft):- %Checks left chain
	compDownLeft(X1,X2,Y1,Y2),
	Move = (C, X2, Y2),
	append(Tail, [Move], NBoard),
	checkChain(Move, NBoard, Start, Ordered, downLeft).
checkChain((C1,X1,Y1), [(C2, X2,Y2) | Tail], Check, Start, downLeft):-
	C1 \== C2,
	compDownLeft(X1,X2,Y1,Y2),
	Start = [],!.%,!.

/*Up Right check*/

checkChain((C,X1,Y1), [(C,X2,Y2) | Tail], [Remove | Start], [Move |Ordered],upRight):- %Checks left chain
	compUpRight(X1,X2,Y1,Y2),
	Move = (C, X2, Y2),
	append(Tail, [Move], NBoard),
	checkChain(Move, NBoard, Start, Ordered, upRight).
checkChain((C1,X1,Y1), [(C2, X2,Y2) | Tail], Check,   Start, upRight):-
	C1 \== C2,
	compUpRight(X1,X2,Y1,Y2),
	Start = [],!.%,!.

/*Down Right check*/

checkChain((C,X1,Y1), [(C,X2,Y2) | Tail], [Remove | Start], [Move|Ordered],downRight):- %Checks left chain
	compDownRight(X1,X2,Y1,Y2),
	Move = (C, X2, Y2),
	append(Tail, [Move], NBoard),
	checkChain(Move, NBoard, Start, Ordered, downRight).
checkChain((C1,X1,Y1), [(C2, X2,Y2) | Tail], Check,   Start, downRight):-
	C1 \== C2,
	compDownRight(X1,X2,Y1,Y2),
	Start = [],!.%,!.

/*Recursions over left and right if they fail*/

validMoveStart((C, X, Y), [(C1,X1,Y2) | Tail], [(C1,X1, Y2) | Rest], Start, Dir):-
	validMoveStart((C, X, Y), Tail, Rest, Start, Dir).

checkChain((C1,X1,Y1), [(C2,X2,Y2) | Tail], [(C2,X2,Y2) | Start], Ordered, Dir):-
	append(Tail, [(C2,X2,Y2)],NewB),
	checkChain((C1,X1,Y1), NewB, Start, Ordered, Dir).

checkChain((C1,X1,Y1), Board, [], no, Dir).
