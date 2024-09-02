
    
Sets
    i loca/ 1*5 /;
Alias(i,j);

Parameters
    xi(i)    'x-coordinate for location i'
    / 1 36, 2 23, 3 23, 4 10, 5 5 /
    yi(i)    'y-coordinate for location i'
    / 1 20, 2 30, 3 56, 4 15, 5 5 /
    di(i)    'Projected demand for next period for location i'
    / 1 7, 2 3, 3 2, 4 4, 5 2 /
    si(i)    'Number of helicopters currently assigned to location i'
    / 1 6, 2 2, 3 3, 4 3, 5 4 /;

Scalar
    c 'Transportation cost per kilometer'
    / 100 /;

Variables
    myvar, zij 'Number of helicopters to be moved from location i to j';

Positive Variables zij;

Equations
    obj 'Objective Function', balance(i), balance1(i), balance2(i);
    
obj.. myvar =e= sum((i,j), sqrt(sqr(xi(j)- xi(i)) + sqr(yi(j)-yi(i))) * c * zij(i,j));
balance(i)..
if(sum(i,di(i)) <= sum(i,si(i)),
    sum(j, zij(j)) + s(i) =l= d(i) + sum(j,zij(j))),
else
    sum(j, zij(j)) + s(i) =g= d(i) + sum(j,zij(j));


Model airAmbulanceReassignment /all/;
solve airAmbulanceReassignment using mip minimizing obj;

*Display zij.l, si.l, di, sum(i, si.l(i)), sum(i, di(i)), sum((i,j)$[ord(i)<>ord(j)], zij.l(i,j));

