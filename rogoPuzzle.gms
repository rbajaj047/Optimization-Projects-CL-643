set V /1*40/;
scalars nrow /5/, ncol /8/;
scalar steps /12/;

alias(V,i,j);

set arc(i,j);

parameter p(V) /1 2, 2 0, 3 3, 4 0, 5 1, 6 0, 7 0, 8 2,
9 0, 10 3, 11 0, 12 0, 13 0, 14 0, 15 4, 16 0,
17 4, 18 0, 19 1, 20 0, 21 0, 22 4, 23 0, 24 1,
25 0, 26 0, 27 -100, 28 2, 29 2, 30 -100, 31 0, 32 0,
33 0, 34 0, 35 2, 36 0, 37 0, 38 2, 39 0, 40 0/;

arc(i,j) = yes\$(abs(ord(i)-ord(j))=ncol or (ord(j)-ord(i))\$(mod(ord(i),ncol) ne 0 and
mod(ord(j),ncol) ne 1)=1 or (ord(i)-ord(j))\$(mod(ord(j),ncol) ne 0 and mod(ord(i),ncol) ne 1)=1);

binary variable
y(V)
x(i,j)
delta(v);

positive variable
u(V);

variable
obj;

equations
connections(i)
connections2(j)
loop_size
mtz(i,j)
assign1(V)
assign2(V)
objective
assign3;

objective.. sum(v,p(v)*y(v)) =e= obj;

loop_size.. sum(V,y(V)) =e= steps;

connections(i).. sum(j\$arc(i,j),x(i,j)) =e= y(i);

connections2(j).. sum(i\$arc(i,j),x(i,j)) =e= y(j);

assign1(V).. u(V)-delta(V) =g= 0;

assign2(V).. u(V) +(steps-1)*delta(V) =l= steps;

assign3.. sum(V,delta(V)) =e= 1;

mtz(i,j)$(ord(i) ne ord(j)).. u(i)-u(j) + steps*(x(i,j)-delta(j)) =l= steps-1;

model project /all/;
solve project using mip max obj;