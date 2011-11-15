function myfft(x,Fs,label)

N=length(x);
NFFT = 2^nextpow2(N);
Y = fft(x,NFFT)/N;
f = Fs/2*linspace(0,1,NFFT/2);

plot(f,2*abs(Y(1:NFFT/2))) 
title(label)
xlabel('„астота (√ц)')
ylabel('|Y(f)|')
end