    sig=wavread('42342.wav');
out=[];
    N=length(sig);
    rms=sqrt(sum(sig.^2)/N);
    tmp=enframe(sig,256,256);
    plist=zeros(size(tmp,1),1);
    p=1;
    for i=1:size(tmp,1)
        locrms=sqrt(sum(tmp(i,:).^2)/256);
        if locrms>.1*rms
            out= [out tmp(i,:)];
        else
            plist(p)=(i-p)*256+1;
            p=p+1;
        end
    end
     plist(p:end)=[];
     newsig=[out 0];
     p=p-1;
     
     for i=p:-1:1
     newsig=[newsig(1:plist(i)) zeros(1,256) newsig((plist(i)+1):end)];    
     end
     