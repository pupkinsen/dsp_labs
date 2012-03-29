function out = truncword(sig)
%      filt = fir1(1024,[0.0125 0.65]);
%      sig=filter(filt,1,sig);
 sig=filter([1 -.9],1,sig);
    out=[];
    N=length(sig);
    rms=sqrt(sum(sig.^2)/N);
    tmp=enframe(sig,256,256);
    for i=1:size(tmp,1)
        locrms=sqrt(sum(tmp(i,:).^2)/256);
        if locrms>.1*rms
            out= [out tmp(i,:)];
        end
     end
            
%     s=0;
%     i=1;
%     border=.1;
%     while s<=border
%         i=i+1;
%         s=s+abs(out(i));
%     end
%     out(1:i)=[];
%     s=0;
%     i=length(out);
%     while s<=border
%         i=i-1;
%         s=s+abs(out(i));
%     end
%     out(i:end)=[];
    
%     wordfft=fft(out);
%     wordfft=conv(wordfft,filt);
    
   % out=abs(ifft(wordfft));
  
    
end