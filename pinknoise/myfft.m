function myfft(x,Fs,label)

N=length(x);
NFFT = 2^nextpow2(N);
Y = fft(x,NFFT)/N;
f = Fs/2*linspace(0,1,NFFT/2);

semilogx(f,20*log(abs(Y(1:NFFT/2)))) 
title(label)
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
end