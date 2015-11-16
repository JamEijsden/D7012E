/** KAPSACK UPPGIFT 1 **/

getRekt([(S,V) | Rest], Current, Sublist):-
	getRating(S, V, Rating),
	getRekt(Rest, [(Rating,S,V) | Current], Sublist).
getRekt([(S,V) | Rest], [], Sublist):-
	getRating(S, V, Rating),
	getRekt(Rest, [(Rating, S, V)], Sublist).
getRekt([], Current, Current).

getRating(S, V, Rating):-
	Rating is (V/S).


kapsack(Size, ItemList, Subset):-
	getRekt(ItemList, [], Sublist),
	sort(Sublist, Sorted),
	reverse(Sorted, [], Desc),
	checkSize(Size, Desc, 0, Subset),!.

checkSize(Size, [(_, S ,V) | Sorted], Sum, [(S, V) | NewList]):-
	Add is Sum +S,
	Add =< Size,
	checkSize(Size, Sorted, Add, NewList).
checkSize(Size, [(_, S, _) | Sorted], Sum, NewList):-
	Add is Sum + S,
	Add > Size,
	checkSize(Size, Sorted, Sum, NewList).
checkSize(Size, [], _, []).


reverse([X |Tail], Temp , Out):-
	append([X], Temp, New),
	reverse(Tail, New, Out).
reverse([], Out, Out).




/**************** UPPGIFT 5 A **************/

not1(X):-
	call(X) -> fail
	;
	true.


/** not1(member(a, [b, c, d, e])). will succeed because member(a, [b,c,d,e]) will not1 find a in the list 
	th.erefore fail but the not negates this to true and it will succeed.

	not1(member(A, [b, c, d, e])). The member predicate one will succeed because A can be any item in the list
	but not1 will negate this and cause it to fail.
**/


/*********** Uppgift 4 ***************/

/** A and B or C **/

p1(A,B,_):-
	A,B.
p1(_,_,C):-
	C.


/** (A and B) or (not A and C) **/
p2(A,B,_):-
	A,!,B.
p2(_,_,C):-
	C.

/** C or A and B **/
p3(_,_,C):-
	C.
p3(A,B,_):-
	A,!,B.



/** Uppgift 2 **/

close(L1, L2, N):-
	calcN(L1, L2, 0, N),!.

calcN([First | L1], [First | L2], Temp, N):-
	calcN(L1, L2, Temp, N).
calcN([First | L1], [NotSame | L2], Temp, N):-	
	Sum is (Temp + 1),
	calcN(L1, L2, Sum, N).
calcN([], [First | L2], Temp, N):-
	Sum is (Temp + 1),
	calcN([], L2, Sum, N).
calcN([First | L1], [], Temp, N):-
	Sum is (Temp + 1),
	calcN(L1, [], Sum, N).
calcN([], [], N, N).

/** How many solutions hwne backtracking over testo(N,M,K,J). 
	N = 1, M = 2 dessa får inte backtracka.
	K = 1, K = 2, J = 3, J = 4 får backtracka.
	1 solution: N(1), M(3),K(1),J(3)
	2 solutions N(1), M(3), K(1), J(4)
	3 Solution N(1), M(3), K(2), J(3)
	3 solution N(1), M(3), K(2), J(4)
**/ 

test(N, M):-
	!,
	member(N, [1,2]),
	member(M, [3,4]).

testo(N, M, K, J):-
	test(N, M),
	!,
	test(K, J).