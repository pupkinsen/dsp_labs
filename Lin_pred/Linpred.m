function out = Linpred(x,nsig,P)
%Вывод значений сигнала на основе линейного предсказания %x - исходный отрезок сигнала, nsig - длина выходного сигнала, P - порядок модели
M=mean(x);
N=length(x);
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




p=P; %Синтез для порядка p
    alfa=zeros(1,p);
        for i=1:p
            alfa(i)=al(p,i);
        end
    MAX=max(x);
    s=zeros(nsig,1);
    s(1:p)=x(1:p);
        for k=p+1:length(s)
            for l=1:p
                if(k-l>=1)
                s(k)=s(k)+alfa(l)*s(k-l);
                end
            end
      
        end
        out=s;

    
 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    