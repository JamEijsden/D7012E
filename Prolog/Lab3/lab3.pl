
/** Fox and Goose can not be alone on one side 
	and the same goes for Goose and Beans. **/
invalid([X, X, _, Y]):-
	X \== Y.
invalid([_, X, X, Y]):-
	X \== Y.
	



/** Changes Obj's side value, either west or east. **/
change(west, This):-	
	This = east.
change(east, This):-
	This = west.

	
/** Output defined as tuple, (Obj, Side). **/
updateOut(Obj, Where, TupleOut):-
	TupleOut = (Obj, Where).
	
/** Input order: Fox, Goose, Beans, Boat.
	Out is output (Object, Side).
	**/	
 
move([X, G, B, X], NewState, Out):-
	change(X, Y),
	not(invalid([Y, G, B, Y])),
	NewState = [Y, G, B, Y],
	updateOut(fox, Y, Out).
move([F, X, B, X], NewState, Out):-
	change(X, Y),
	not(invalid([F, Y, B, Y])),
	NewState = [F, Y, B, Y],
	updateOut(goose, Y, Out).
move([F, G, X, X], NewState, Out):-
	change(X, Y),
	not(invalid([F, G, Y, Y])),
	NewState = [F, G, Y, Y],
	updateOut(beans, Y, Out).
move([F, G, B, X], NewState, Out):-
	change(X, Y),
	not(invalid([F, G, B, Y])),
	NewState = [F, G, B, Y],
	updateOut(boat, Y, Out).
	
solvefgb([X, X, X, X], X, _, []).
solvefgb([Fox, Goat, Beans, Boat], Dest, N, [Out | Trace]):-
	N>0,
	move([Fox, Goat, Beans, Boat], NewState, Out),
	solvefgb(NewState, Dest, N-1, Trace).

