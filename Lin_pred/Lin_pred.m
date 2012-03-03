clc
clear
%conditions
N=1024;
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
p=N;
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

 al=zeros(N);

     for p=2:N+1
         zz=levinson(R,p-1);
         al(p-1,1:p-1)=-zz(1,2:end);
     end
    
    clear E i s j ka

     
    clear i p

%Дисперсия для p=1:250
sig0=zeros(N,1);
for p=1:N
    for i=1:p
        alfa(i)=al(p,i);
    end
    for n=p+1:N        
        sig0(p)=sig0(p)+(x(n)-M-sum(alfa(1:p).*(x(n-(1:p))-M)))^2;
    end
    sig0(p)=(1/(N-p))*sig0(p);
end
clear p n s k alfa
figure(1), plot(1:N,sig0);
title('Дисперсия');
xlabel('Порядок модели');
ylabel('sig0');

%Синтез сигнала
sig=zeros(N,1);
for p=1:N
    alfa=zeros(1,p);
        for i=1:p
            alfa(i)=al(p,i);
        end
    s=zeros(size(x));
    s(1:p)=x(1:p);
        for k=p+1:length(s)
            for l=1:p
                if(k-l>=1)
                s(k)=s(k)+alfa(l)*s(k-l);
            end
        end
    end
    sig(p)=sqrt(sum((x-s).^2)/N);
    
end
figure(2), plot(1:N,sig)
title('Среднеквадратическое отклонение');
xlabel('Порядок модели');
ylabel('sigma');


p=250; %Синтез для порядка 250
    alfa=zeros(1,p);
        for i=1:p
            alfa(i)=al(p,i);
        end
    MAX=max(x);
    noise=MAX*randn(N,1);
    s=zeros(size(x));
    s(1:p)=x(1:p);
        for k=p+1:length(s)
            for l=1:p
                if(k-l>=1)
                s(k)=s(k)+alfa(l)*s(k-l);
                end
            end
            s(k)=s(k)+sig0(p)*noise(k)+M;
        end
    sig250=sqrt(sum((x-s).^2)/N)
    
figure(3), plot(1:N,x,1:N,s)
title('Синтез сигнала для p=250');    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    