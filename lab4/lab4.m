clc
clear
%conditions
N=15;
n=8;
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
interp_var_tables(length(xx1),2,fd)
z=interp_var(xx1,length(xx1),2);
figure(1), subplot(3,1,1), plot(0:Td:(length(x1)-1)*Td,x1);
xlabel('t (C)');
ylabel('x1');
subplot(3,1,2), 
xlabel('t (C)');
ylabel('x1 rediscr');
subplot(3,1,3), plot(0:Td:(length(x1)-1)*Td,z);
xlabel('t (C)');
ylabel('x1 interp');

%Calculating errors
eps1=sqrt(sum((z'-x1).^2)/sum(x1.^2));

disp '�����������:';
disp(eps1);
figure(2), myfft(x1,1/Td,'������ x1');
figure(3), myfft(z,1/Td,'������ ���������������� �������');
figure(7), plot(t,x1,'--',t,z,0:2*Td:(length(x1)-1)*Td,xx1,'--rs','LineWidth',1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','g',...
                'MarkerSize',5)
%===============X6================
xx6=rediscr(x6,2);

%interp_var_tables(length(xx1),2,fd)
z6=interp_var(xx6,length(xx6),2);
figure(4), subplot(3,1,1), plot(0:Td:(length(x6)-1)*Td,x6);
xlabel('t (C)');
ylabel('x6');
subplot(3,1,2), plot(0:2*Td:(length(x6)-1)*Td,xx6);
xlabel('t (C)');
ylabel('x6 rediscr');
subplot(3,1,3), plot(0:Td:(length(x6)-1)*Td,z6);
xlabel('t (C)');
ylabel('x6 interp');

%Calculating errors
eps2=sqrt(sum((z6'-x6).^2)/sum(x6.^2));

disp '�����������:';
disp(eps2);
figure(5), myfft(x6,1/Td,'������ x6');
figure(6), myfft(z6,1/Td,'������ ���������������� �������');


