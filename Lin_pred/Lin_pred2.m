clc
clear
close all
%conditions
N=128;
[X1, Fs, bits]=wavread('фраза.wav');
X=X1(37100:39300);
X=sin(0:.01:pi);
DL=length(X);
n1=floor(DL/2)-N/2;
n2=n1-1+N;
x=X(n1:n2);

M=13; % order of the predictor
%x=input('Enter the signal(row vector): ');
%for M=1:200
r=zeros(M+1,1); % Column matrix of the autocorrelation
%Calculating the autocorrelation functions upto order M
for k=0:M
for l=1:length(x)
if((l-k)>=1)
r(k+1)=r(k+1)+(x(l)*conj(x(l-k)));
end
end
r(k+1)=r(k+1)/(length(x)-k);
end
r0=r(1);
r=r(2:M+1,1); % remove r(0) from the matrix
% Now compute the coeff. (here we are using direct matlab inv. function)
%a=inv(R)*r % the coefficients
% Levinson-Durbin Recursion to get the coefficients
a=1; % a0 (start)
P=r0; % Power in error
D=r(1);
for m=1:M
Gamma=-D/P; % The reflection coeff. for mth order filter
a=[a;0] + Gamma.* conj(flipud([a;0])); % The coeff. for the mth order
% filter
P=P*(1-(abs(Gamma))^2); % Power of the error for mth filter
if(m+1<=M)
D=(flipud(r(1:m+1))')*a; % calculate Delta(D)(m)
end
end
a=-a(2:M+1); % remove the first element of the Prediction-error filter
% coeff. vector (since it is equal to 1 and we donot
% need it here) also we need to put a negative sign
% as the prediction-error-filter has a -ve sign for
% prediction-filter coeff.
P
% Now we need to estimate the signal
s=zeros(size(x)); % estimate of x
s(1)=x(1);
for k=2:length(s)
for l=1:M
if(k-l>=1)
s(k)=s(k)+a(l)*x(k-l);
end
end
end
%end
figure;
plot(1:length(x),x,'r-',1:length(s),s,'b-');
figure;
plot(1:length(s),abs(fft(s-x)))