function out = truncword(sig)
    out=sig;
    s=0;
    i=1;
    border=.01;
    while s<=border
        i=i+1;
        s=s+abs(out(i));
    end
    out(1:i)=[];
    s=0;
    i=length(out);
    while s<=border
        i=i-1;
        s=s+abs(out(i));
    end
    out(i:end)=[];
    filt = fir1(1024,[0.0375 0.5]);
%     wordfft=fft(out);
%     wordfft=conv(wordfft,filt);
    
   % out=abs(ifft(wordfft));
   out=filter(filt,1,out);
    
end