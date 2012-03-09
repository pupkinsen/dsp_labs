function out = Linpred_a(x,P)
%Вывод коэффициентов линейного предсказания
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



p=P; %Синтез для порядка p
    alfa=zeros(1,p);
%        for i=1:p
%            alfa(i)=al(p,i);
%        end
    zz=levinson(R,p);
    alfa=-zz(1,2:end);

        out=alfa;
