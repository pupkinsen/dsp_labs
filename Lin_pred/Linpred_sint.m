function out = Linpred_sint(x,nsig,alfa)


p=length(alfa); %Синтез для порядка p
    

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
