/* Returns the value of the board. */
valueof(Color, Board, Value):-
	seperateCs(Board, White, Black),
	chooseColorlist(Color, White, Black, Result),
	loopOverList(Result, Value).

loopOverList([(C, X, Y) | Board], S):-
	isEdge(X, Y, Value), 
	loopOverList(Board, Sum),
	S is Sum+Value,!.
loopOverList([], 0).


isEdge(X, 1, Value):-
	isCorner(X,1, Value)
	;
	Value = 2.
isEdge(X, 8, Value):-
	isCorner(X,8, Value)
	;
	Value = 2.
isEdge(a, Y, Value):-
	isCorner(a,Y, Value)
	;
	Value = 2.
isEdge(h, Y, Value):-
	isCorner(h,Y, Value)
	;
	Value = 2.
isEdge(X, Y, 1):-
	X \== a,
	X \== h,
	Y \== 1,
	Y \== 8.

isCorner(a,1,3).
isCorner(a,8,3).
isCorner(h,1,3).
isCorner(h,8,3).

/* Find the best move of a color*/

findbestmove(C, Board, N, X, Y):-
	findall((Moves, NewBoard),makemoves2(C, Board, N, Moves, NewBoard), AllResults),
	evaluate(C, AllResults, ValueList), 
	keepHighest(ValueList, 0, OUT),
	cycle(OUT, (X,Y,_)).

/* Evaluates if best move */
evaluate(C, [([First | Moves], FinalBoard) | AllResults], [V | ValueList]):-
	boardValue(C, FinalBoard, First, V),
	evaluate(C, AllResults, ValueList).
evaluate(C, [], []).


cycle([X | Rest], X).
cycle([X | Rest], Out):-
	cycle(Rest, Out).


/* keeps the highest valued move in list */
keepHighest([(X,Y,V) | ValueList], (X1,Y1,V1), Highest):-
	V > V1,
	keepHighest(ValueList, (X,Y,V), Highest).
keepHighest([(X,Y,V) | ValueList], (X1,Y1,V1), Highest):-
	V < V1,
	keepHighest(ValueList, (X1,Y1,V1), Highest).
keepHighest([(X,Y,V) | ValueList], (X1,Y1,V1), HighestList):-
	V == V1,
	keepHighest(ValueList, (X1,Y1,V1), Highest),
	append(Highest, [(X,Y,V)], HighestList).
keepHighest([], High, [High]).
keepHighest([(X,Y,V) | ValueList], 0, Highest):-
	keepHighest(ValueList, (X,Y,V), Highest).


/*These functions are not in use atm */

returnBiggest((_,_,V1), (X2,Y2,V2), (X2,Y2,V2)):-
	V1 < V2.
returnBiggest((X1,Y1,V1), (_,_,V2), (X1,Y1,V1)):-
	V1 >  V2.
returnBiggest((X1,Y1,V), (X2,Y2,V), (X1,Y1,V)).
returnBiggest((X1,Y1,V), (X2,Y2,V), (X2,Y2,V)).

returnBiggest((X1,Y1,V1), 0, (X1,Y1,V1)):-!.	

boardValue(C, Board, (C, X, Y), (X, Y, Value)):-
	valueof(C, Board, Value).
/**
findbestmove(white,[(white,a,1),(black,a,2),(black,b,1),(black,b,2)], 2, X , Y).
**/