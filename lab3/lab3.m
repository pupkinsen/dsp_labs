clc
clear
%conditions
N=512;
n=16;
f1=20000;
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
disp 'Расчет для сигнала x1'
x7=rediscr(x1,2);
x8=interp(x7,fd/2,fd);
figure(1);

SUBPLOT(3,1,1), stem(0:Td:31*Td,x1(1:32));
title('Сигнал x1');
xlabel('t (с)');

subplot(3,1,2), stem(0:2*Td:31*Td,x7(1:16));
title('Уменьшение fd в 2 раза');
xlabel('t (с)');

subplot(3,1,3), stem(0:Td:31*Td,x8(1:32));
title('Сигнал после интерполяции');
xlabel('t (с)');

x9=rediscr(x1,3);
x10=interp(x9,fd/3,fd);
figure(2);
subplot(3,1,1), stem(0:Td:31*Td,x1(1:32));
title('Сигнал x1');
xlabel('t (с)');

subplot(3,1,2), stem(0:3*Td:31*Td,x9(1:11));
title('Уменьшение fd в 3 раза');
xlabel('t (с)');

subplot(3,1,3), stem(0:Td:31*Td,x10(1:32));
title('Сигнал после интерполяции');
xlabel('t (с)');

x11=rediscr(x1,4);
x12=interp(x11,fd/4,fd);
figure(3);
subplot(3,1,1), stem(0:Td:31*Td,x1(1:32));
title('Сигнал x1');
xlabel('t (с)');

subplot(3,1,2), stem(0:4*Td:31*Td,x11(1:8));
axis([0 31*Td -2 2]);
title('Уменьшение fd в 4 раза');
xlabel('t (с)');

subplot(3,1,3), stem(0:Td:31*Td,x12(1:32));
title('Сигнал после интерполяции');
xlabel('t (с)');
figure(4);
myfft(x1,fd,'Спектр сигнала x1');
figure(5);
myfft(x12,fd,'Спектр сигнала после интерполяции');

%Calculating errors
eps1=sqrt(sum((x8-x1).^2)/sum(x1.^2));
eps2=sqrt(sum((x10(1:512)-x1).^2)/sum(x1.^2));
eps3=sqrt(sum((x12-x1).^2)/sum(x1.^2));

disp 'Погрешность при fd/2';
disp(eps1);
disp 'Погрешность при fd/3';
disp(eps2);
disp 'Погрешность при fd/4';
disp(eps3);

%===============X6================

disp 'Расчет для сигнала x6'
x13=rediscr(x6,2);
x14=interp(x13,fd/2,fd);
figure(6);

subplot(3,1,1), stem(0:Td:31*Td,x6(1:32));
title('Сигнал x6');
xlabel('t (с)');

subplot(3,1,2), stem(0:2*Td:31*Td,x13(1:16));
title('Уменьшение fd в 2 раза');
xlabel('t (с)');

subplot(3,1,3), stem(0:Td:31*Td,x14(1:32));
title('Сигнал после интерполяции');
xlabel('t (с)');

x15=rediscr(x6,3);
x16=interp(x15,fd/3,fd);
figure(7);
subplot(3,1,1), stem(0:Td:31*Td,x6(1:32));
title('Сигнал x6');
xlabel('t (с)');

subplot(3,1,2), stem(0:3*Td:31*Td,x15(1:11));
title('Уменьшение fd в 3 раза');
xlabel('t (с)');

subplot(3,1,3), stem(0:Td:31*Td,x16(1:32));
title('Сигнал после интерполяции');
xlabel('t (с)');

x17=rediscr(x6,4);
x18=interp(x17,fd/4,fd);
figure(8);
subplot(3,1,1), stem(0:Td:31*Td,x6(1:32));
title('Сигнал x6');
xlabel('t (с)');

subplot(3,1,2), stem(0:4*Td:31*Td,x17(1:8));
title('Уменьшение fd в 4 раза');
axis([0 31*Td -5 5]);
xlabel('t (с)');

subplot(3,1,3), stem(0:Td:31*Td,x18(1:32));
title('Сигнал после интерполяции');
xlabel('t (с)');
figure(9);
myfft(x6,fd,'Спектр сигнала x6');
figure(10);
myfft(x18,fd,'Спектр сигнала после интерполяции fd/4');
figure(11);
myfft(x14,fd,'Спектр сигнала после интерполяции fd/2');

%Calculating errors
eps1=sqrt(sum((x14-x6).^2)/sum(x6.^2));
eps2=sqrt(sum((x16(1:512)-x6).^2)/sum(x6.^2));
eps3=sqrt(sum((x18-x6).^2)/sum(x6.^2));

disp 'Погрешность при fd/2';
disp(eps1);
disp 'Погрешность при fd/3';
disp(eps2);
disp 'Погрешность при fd/4';
disp(eps3);
