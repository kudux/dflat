% Ex Ay Ez: -x & (x | -y | z)
% Expect 1 solution
length(3).

atom(1,x).
atom(2,y).
atom(3,z).

clause(c0).
clause(c1).

neg(c0,x).

pos(c1,x).
neg(c1,y).
pos(c1,z).
