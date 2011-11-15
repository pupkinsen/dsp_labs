clc
clear
%conditions
N=64;
n=16;
f1=2000;
Xm1=1.6;


%initialize


%generating signals
T=1/f1;
Td=T/n;
fd=1/Td;
fi1=0*pi;
t=[0:Td:(T*N/n)-Td];
x1=Xm1*sin((2*pi*f1).*t+fi1);
f2=3*f1;
Xm2=Xm1/2;
T2=1/f2;
fi2=pi/4;
x2=Xm2*sin((2*pi*f2).*t+fi2);
x3=x1+x2;
Xm4=.125*Xm1;
x4=Xm4.*randn(1,N);
x5=x1+x4;
x6=x3+x4;


%===============X1================
xx1=rediscr(x1,2);
xx2=rediscr(x1,3);
%interp_var_tables(length(xx1),2,fd)
z=interp_var(xx1,length(xx1),2);


