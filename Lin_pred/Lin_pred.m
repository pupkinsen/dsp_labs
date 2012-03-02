clc
clear
%conditions
N=128;
[X1, Fs, bits]=wavread('фраза.wav');
X=X1(37100:39300);
%X=sin(0:.01:pi);
DL=length(X);
n1=floor(DL/2)-N/2;
n2=n1-1+N;
x=X(n1:n2);

%Мат. Ожидание
M=mean(x);

%Коэффициенты корреляции (автокореляционный метод)
p=25;
for k=0:p
    s=0;
    for m=1:(N-k)
        s=s+(x(m)-M)*(x(m+k)-M);
    end;
    RR(k+1)=s;
end;
clear k s m
for k=1:(p+1)
    R(k)=RR(k)/RR(1);
end;
clear k RR

%Коэффициенты линейного предсказания (алгоритм Левинсона-Дарбина)

%     E(1)=R(1); ka(1)=R(2)/E(1); al(1,1)=ka(1);
%     for i=2:p
%         E(i)=(1-ka(i-1)^2)*E(i-1);
%         s=0;
%         for j=1:(i-1)
%             s=s+al(i-1,j)*R(i-j+1);
%         end
%         ka(i)=(R(i+1)-s)/E(i);
%         al(i,i)=ka(i);
%         for j=(i-1):-1:1
%             al(i,j)=al(i-1,j)-ka(i)*al(i-1,i-j);
%         end
%     end
 al=zeros(25);

     for p=2:26
         zz=levinson(R,p-1);
         al(p-1,1:p-1)=zz(1,2:end);
     end
    
    clear E i s j ka

     
    clear i p

%Дисперсия для p=1:25
sig0=zeros(25,1);
for p=1:25
    for i=1:p
        alfa(i)=al(i,p);
    end
    for n=p+1:N        
        sig0(p)=sig0(p)+(x(n)-M-sum(alfa(1:p).*(x(n-(1:p))-M)))^2;
    end
    sig0(p)=(1/(N-p))*sig0(p);
end
clear p n s k alfa
plot(1:25,sig0);

%Синтез сигнала
p=13;
    for i=1:p
        alfa(i)=al(i,p);
    end
MAX=max(x);
noys=MAX*randn(N,1);
xs(1:p)=x(1:p);
for i=p+1:N
    s=0;
    for k=1:p
        s=s+alfa(k)*(xs(i-k)-M);
    end
    xs(i)=s+sig0(p)*noys(i)+M;
end
figure(2), plot(1:N,x,1:N,xs)

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    