%conditions
N=512;
n=12;
f1=20000;
Xm1=1.6;
n_intervals=16;

%initialize
interval_limits=zeros(1,n_intervals);
a_r=zeros(N,N);
A_r=zeros(n_intervals,N,N);
Q_r=zeros(n_intervals,N,N);
L_r=zeros(n_intervals,N,N);
J=2*(N/n_intervals^2)+4;
AA=zeros(n_intervals*J,N);
P=zeros(n_intervals,1);


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

%set intervals
interval_limits=0:pi/n_intervals:pi;

%form A^r matrix (formula #2.8) _VERY SLOW_
temp_interval_length=(interval_limits(2)-interval_limits(1))/pi; %constant, used for optimization purposes
for r=2:n_intervals+1
    for i=1:N 
        for k=1:N 
            A_r(r-1,i,k)=(sin(interval_limits(r)*(i-k))-sin(interval_limits(r-1)*(i-k)))/(pi*(i-k));
        end
    end
    for i=1:N
        A_r(r-1,i,i)=temp_interval_length; %all intervals are equal so the constant is used (see 2.8)
    end
%form Q^r and L^r matrices    
[Q_r(r-1,:,:),L_r(r-1,:,:)]=eig(squeeze(A_r(r-1,:,:)));
%Q_r(r-1,:,:)=sort(squeeze(Q_r(r-1,:,:)),'descend');
%L_r(r-1,:,:)=sort(squeeze(Q_r(r-1,:,:)),'descend');
%form AA matrix (formula #2.12)
for i=0:J-1
    AA((r-1)*i+1,:)=sqrt(sort(diag(squeeze(L_r(r-1,:,:))),'descend'))'*squeeze(Q_r(r-1,:,N-i))';
end

end

YY=AA*x3';
for r=1:n_intervals
   P(r)=0;
   for k=1:J
       P(r)=P(r)+YY(k*r)^2; % ????????????????????
   end
end









