N=600;
n=12;
f1=20000;
Xm1=1.6;
T=1/f1;
Td=T/n;
fd=1/Td;
fi1=0*pi;
t=[0:Td:T*N/n];
x1=Xm1*sin((2*pi*f1).*t+fi1);

figure(1),plot(t,x1,'--');
f2=3*f1;
Xm2=Xm1/2;
T2=1/f2;
fi2=pi/4;
x2=Xm2*sin((2*pi*f2).*t+fi2);
figure(1),plot(t,x2);
x3=x1+x2;
figure(2), plot(t,x3);
Xm4=.125*Xm1;
x4=Xm4.*randn(1,N+1);
figure(3), plot(t,x4);
x5=x1+x4;
x6=x3+x4;
figure(4), plot(t,x5);
figure(5), plot(t,x6);
M1=mean(x1);
M2=mean(x2);
M3=mean(x3);
M4=mean(x4);
M5=mean(x5);
M6=mean(x6);
D1=cov(x1);
D2=cov(x2);
D3=cov(x3);
D4=cov(x4);
D5=cov(x5);
D6=cov(x6);
Nt1=length(x1);
Nf1=1024;
P1=zeros(1,Nf1);
P2=zeros(1,Nf1);
for k1=1:Nf1
    Re1(k1)=0;
    Im1(k1)=0;
    for j1=1:Nt1
        Re1(k1)=Re1(k1)+x3(j1)*cos(pi*(j1-1)*(k1-1)/Nf1);
        Im1(k1)=Im1(k1)+x3(j1)*sin(pi*(j1-1)*(k1-1)/Nf1);
    end
    P1(k1)=(Re1(k1)^2+Im1(k1)^2)/Nt1;
    if (mod((Im1(k1)/Re1(k1)), (pi<2)) > .1)
    P2(k1)=atan(Im1(k1)/Re1(k1));
    else
    P2(k1)=0;    
    end
end
Fs1=[0.0001:fd/(2*Nf1):fd/2];

figure(6), plot(Fs1,P1);
figure(7), plot(Fs1,P2);
