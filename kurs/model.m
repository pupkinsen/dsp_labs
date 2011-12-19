clc
clear
%conditions
Ns=400;
Np=2000;
No=8000;
f0=700;
f1=900;
f2=1100;
f4=1300;
f7=1500;
f11=1700;
fd=8000;
Xm1=1;


%initialize
T=1/f1;
Td=1/fd;
fi1=0*pi;
ts=(0:Td:(Td*Ns)-Td);
tp=(0:Td:(Td*Np)-Td);
to=(0:Td:(Td*No)-Td);
%generating signals

x0=Xm1*sin((2*pi*f0).*ts+fi1);
x1=Xm1*sin((2*pi*f1).*ts+fi1);
x2=Xm1*sin((2*pi*f2).*ts+fi1);
x4=Xm1*sin((2*pi*f4).*ts+fi1);
x7=Xm1*sin((2*pi*f7).*ts+fi1);
x11=Xm1*sin((2*pi*f1).*ts+fi1);

dp=0.*tp;
ds=0.*ts;
do=0.*to;

%frequency combinations
k=zeros(15,Ns);
k(1,:)=x0+x1; %����� 1/������ �������� 1 �����
k(2,:)=x0+x2; %����� 2/������ �������� ��������� �����
k(3,:)=x1+x2; %����� 3/������ �������� ���������� �����
k(4,:)=x0+x4; %����� 4/���������� ������� ��������
k(5,:)=x1+x4; %����� 5/���������� ������� �����
k(6,:)=x2+x4; %����� 6/������ ���������� �����, �������� � �������
k(7,:)=x0+x7; %����� 7/������� ����������
k(8,:)=x1+x7; %����� 8/������ �������� ���� ����� �������� �����
k(9,:)=x2+x7; %����� 9/������ ���������� ���� �������� �����
k(10,:)=x4+x7; %����� 0/������ ���� ������� � ���������� �������� �����
k(11,:)=x0+x11; %������/������ ��������� �������������� ������
k(12,:)=x1+x11; %������������� ������ �������� ���. ����. 4,5,8,9,10/������
k(13,:)=x2+x11; %������ �������� �������� ������/������
k(14,:)=x4+x11; %���������. ������������� ���������/������
k(15,:)=x7+x11; %�������������. ������������� ����������/������


%�������� ������ 274251, ����� "������� ��������"
sig_p=[ds dp squeeze(k(2,:)) do ds dp squeeze(k(7,:)) do ds dp squeeze(k(4,:)) do ds dp squeeze(k(2,:)) do ds dp squeeze(k(5,:)) do ds dp squeeze(k(1,:)) do ds dp];
sig_o=[squeeze(k(1,:)) dp ds do squeeze(k(2,:)) dp ds do squeeze(k(2,:)) dp ds do squeeze(k(2,:)) dp ds do squeeze(k(2,:)) dp ds do squeeze(k(2,:)) dp ds do squeeze(k(4,:)) dp];
sig=sig_o+sig_p+wgn(1,length(sig_p),-40);%������ � ����� (������+��������+���)


figure(1)
plot(1:length(sig_p),sig_p,'-r',1:length(sig_o),sig_o,'-b');
title('������� ������� � ��������� �����������');
h = legend('������ �����������','�������� �����������',2);
set(h,'Interpreter','none')
figure(2)
plot(1:length(sig),sig);
title('������� � �����');

wavwrite(sig,'sound.wav');