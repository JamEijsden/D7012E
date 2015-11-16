/* Finds chains and flips them on the board, ex black -> white when legalmove done. */

findAllChains([(Try,Dir) | Possible], Board, [FullChain | AllChains], NEW):-
	checkChain(Try,Board, Board, Chain, Dir),
	checkIfChain((Try, Chain), FullChain),
	delChain(Board, FullChain, NewBoard),
	findAllChains(Possible, NewBoard, AllChains, NEW).
findAllChains([],Board, [], Board).

checkIfChain((Try, Chain), FullChain):-
	Chain \== no,
	FullChain = [Try | Chain].
checkIfChain((_,no),[]).

/* removes old bricks from the board */
delChains(Board, [X | Chains], NewBoard):-
	delChain(Board, X, RemovedX),
	delChains(RemovedX, Chains, NewBoard).
delChains(Board, [], Board):-!.

delChain(Board, [X | Bricks], NewBoard):-
	del(Board, X, RemovedX),
	delChain(RemovedX, Bricks, NewBoard).
delChain(Board, [], Board).

del(Board, [], Board).
del([X | Board], X, Board).
del([X | Board], Chain, [X | NewBoard]):-
	del(Board, Chain, NewBoard).



/* Creates a new board with flipped bricks */
newBoard([Chain | ChainList],Board, NewBoard):-
	chColor(Chain, Board, New),
	newBoard(ChainList,New, NewBoard).
newBoard([],Board, Board).

/*Changes color on brick */

chColor([(white,X,Y) | Rest],Board, [(black,X,Y) | New]):-
	chColor(Rest, Board, New).
chColor([(black,X,Y) | Rest], Board, [(white,X,Y) | New]):-
	chColor(Rest, Board, New).
chColor([],Board, Board).



chainStart((C, X1, Y), [(C1, X2, Y) | Tail], Tail, [One | Possible]):-
	C \== C1,
	compLeft(X1,X2),
	Dir = left,
	One = ((C1,X2,Y), Dir),
	chainStart((C, X1, Y), Tail, Rest, Possible),!.


/*Check right*/

chainStart((C, X1, Y), [(C1, X2, Y) | Tail], Tail, [One | Possible]):-
	C \== C1,
	compRight(X1,X2),
	Dir = right,
	One = ((C1,X2,Y), Dir),
	chainStart((C, X1, Y), Tail, Rest, Possible).

/*Checks up*/

chainStart((C, X, Y1), [(C1, X, Y2) | Tail], Rest, [One | Possible]):-
	C \== C1,
	compUp(Y1,Y2),
	Dir = up,
	One = ((C1,X,Y2), Dir),
	chainStart((C, X, Y1), Tail, Rest, Possible).


/*Checks down*/

chainStart((C, X, Y1), [(C1, X, Y2) | Tail], Rest, [One | Possible]):-
	C \== C1,
	compDown(Y1,Y2),
	Dir = down,
	One = ((C1,X,Y2), Dir),
	chainStart((C, X, Y1), Tail, Rest, Possible).

/*And now the diagonal checks*/

/*Up left check*/
chainStart((C, X1, Y1), [(C1, X2, Y2) | Tail], Rest, [One | Possible]):-
	C \== C1,
	compUpLeft(X1,X2,Y1,Y2),
	Dir = upLeft,
	One = ((C1,X2,Y2), Dir),
	chainStart((C, X1, Y1), Tail, Rest, Possible).


/*Down left check*/
chainStart((C, X1, Y1), [(C1, X2, Y2) | Tail], Rest, [One | Possible]):-
	C \== C1,
	compDownLeft(X1,X2,Y1,Y2),
	Dir = downLeft,
	One = ((C1,X2,Y2), Dir),
	chainStart((C, X1, Y1), Tail, Rest, Possible).

/*Up Right check*/
chainStart((C, X1, Y1), [(C1, X2, Y2) | Tail], Rest, [One | Possible]):-
	X1\==X2,
	Y1\==Y2,
	C \== C1,
	compUpRight(X1,X2,Y1,Y2),
	Dir = upRight,
	One = ((C1,X2,Y2), Dir),
	chainStart((C, X1, Y1), Tail, Rest, Possible).


/*Down Right check*/

chainStart((C, X1, Y1), [(C1, X2, Y2) | Tail], Rest, [One | Possible]):-
	C \== C1,
	compDownRight(X1,X2,Y1,Y2),
	Dir = downRight,
	One = ((C1,X2,Y2), Dir),
	chainStart((C, X1, Y1), Tail, Rest, Possible).


/*Recursions over left and right if they fail*/

chainStart((C, X, Y), [(C1,X1,Y2) | Tail], [(C1,X1, Y2) | Rest], Possible):-
	chainStart((C, X, Y), Tail, Rest, Possible).
chainStart(_, [], [], []).



