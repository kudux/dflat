% Suppose that the top level quantifier is \exists

% Predicates computed by the grounder...

itemSet(0,R,N) :- childRow(R,N).
itemSet(L+1,S,N) :- itemSet(L,R,N), sub(R,S).

assigned(S,X) :- childItem(S,is(X,_)).
assigned(S,X) :- childItem(S,taken(X)).

isRemoved(S,X) :- childItem(S,is(X,V)), removed(V).

% Make implicit negative information explicit
-is(S,X,V) :- individualVar(X,L), itemSet(L,S,N), bag(N,V), not childItem(S,is(X,V)).
-contains(S,X,V) :- setVar(X,L), itemSet(L,S,N), bag(N,V), not childItem(S,contains(X,V)).

% A node in the characteristic tree is invalid if it does not assign a variable
invalidItemSet(S) :- final, individualVar(X,L), itemSet(L,S,_), not assigned(S,X).
invalidItemSet(S) :- invalidItemSet(R), sub(R,S).

forallItemSet(S) :- final, childRow(S,_),        sub(S,_), not invalidItemSet(S).
forallItemSet(S) :- existsItemSet(R), sub(R,S), sub(S,_), not invalidItemSet(S).
existsItemSet(S) :- forallItemSet(R), sub(R,S), sub(S,_), not invalidItemSet(S).

bad(S) :- final, length(L), itemSet(L,S,_), not invalidItemSet(S), clause(C), not childItem(S,satisfied(C)).
bad(S)  :- forallItemSet(S), sub(S,T),     bad(T), not invalidItemSet(T).
-bad(S) :- existsItemSet(S), sub(S,T), not bad(T), not invalidItemSet(T).
bad(S) :- existsItemSet(S), not -bad(S).

% Actual solving part...

% Guess a path
1 { extend(0,R) : rootOf(R,N) } 1 :- childNode(N).
1 { extend(L+1,S) : sub(R,S) } 1 :- extend(L,R), sub(R,_).

% Joined rows must agree on common vertices, i.e., if a common vertex is assigned to some (resp. no) variables in a row, it must also be assigned to those (resp. no) variables in the matching row. If a common vertex is contained in the interpretation of some set variables, it must also be contained in those sets of the matching row.

:- extend(L,S0;S1), childItem(S0,is(X,V)), -is(S1,X,V).
:- extend(L,S0;S1), childItem(S0,contains(X,V)), -contains(S1,X,V).

% If an individual variable is set to a vertex in a row, each join partner must have set the variable to either the same vertex or nothing at all.
:- extend(L,S0;S1), childItem(S0,is(X,Y)), childItem(S1,is(X,Z)), Y != Z.
:- extend(L,S0;S1), childItem(S0,is(X,_)), childItem(S1,taken(X)).
:- extend(L,S0;S1), S0 != S1, childItem(S0;S1,taken(X)).

% Use item "taken(x)" when an individual variable x has been assigned to a now-removed vertex

satisfied(C)  :- extend(L,S), childItem(S,satisfied(C)).
contains(X,V) :- extend(L,S), childItem(S,contains(X,V)), current(V).
is(X,V)       :- extend(L,S), childItem(S,is(X,V)),       current(V).
taken(X)      :- extend(L,S), isRemoved(S,X).
taken(X)      :- extend(L,S), childItem(S,taken(X)).

:- final, extend(1,R), bad(R).
:- final, individualVar(X,_), not taken(X).

% Vertex introduction

{ is(X,V) : individualVar(X,_) } :- introduced(V).
{ contains(X,V) : setVar(X,_) } :- introduced(V).

:- individualVar(X,_), is(X,V), is(X,W), V != W.
:- individualVar(X,_), is(X,_), taken(X).

% assignedByGuess(N,X) means that the guessed path for child node N assigned the individual variable X.
assignedByGuess(N,X) :- extend(L,S), itemSet(L,S,N), assigned(S,X).

% If X is a set variable, x,y are individual variables, the following are atoms:
% 1. x = y
% 2. edge(x,y)
% 3. X(x)

% Which clauses become satisfied by the current row? (Additionally to satisfied clauses "inherited" from extended child rows.)
satisfied(C) :- pos(C,eq(X,Y)), is(X,V), is(Y,V).
satisfied(C) :- neg(C,eq(X,Y)), is(X,V), is(Y,W), V != W.
satisfied(C) :- neg(C,eq(X,Y)), extend(L,S), isRemoved(S,X), itemSet(L,S,N), not assignedByGuess(N,Y).
satisfied(C) :- neg(C,eq(X,Y)), extend(L,S), isRemoved(S,Y), itemSet(L,S,N), not assignedByGuess(N,X).

satisfied(C) :- pos(C,edge(X,Y)), is(X,V), is(Y,W), edge(V,W).
satisfied(C) :- neg(C,edge(X,Y)), is(X,V), is(Y,W), not edge(V,W).
satisfied(C) :- neg(C,edge(X,Y)), extend(L,S), isRemoved(S,X), itemSet(L,S,N), not assignedByGuess(N,Y).
satisfied(C) :- neg(C,edge(X,Y)), extend(L,S), isRemoved(S,Y), itemSet(L,S,N), not assignedByGuess(N,X).

satisfied(C) :- pos(C,in(X,Y)), is(X,V), contains(Y,V).
satisfied(C) :- neg(C,in(X,Y)), is(X,V), not contains(Y,V).

item(L,satisfied(C))   :- length(L), satisfied(C).
item(L,is(X,V))        :- individualVar(X,L), is(X,V).
item(L,taken(X))       :- individualVar(X,L), taken(X).
item(L,contains(X,V))  :- setVar(X,L), contains(X,V).



#hide.
#show item/2.
#show extend/2.
#show length/1.
