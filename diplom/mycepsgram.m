function  out=mycepsgram(x,winsize,overlap)
    fftlength=1024;
    N=size(x,1);
    nw=floor(N/(winsize-overlap));
    out=zeros(fftlength/2,nw);
    for i=0:nw-2
        buf=rceps(x(i*(winsize-overlap)+1:i*(winsize-overlap)+1+winsize),fftlength);
        out(:,i+1)=buf(1:fftlength/2);
    end
    
    buf=rceps(x((winsize-overlap)*(nw-1):end),fftlength);
    out(:,nw)=buf(1:fftlength/2);

end