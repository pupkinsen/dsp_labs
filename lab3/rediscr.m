function newsig = rediscr(x,fract)
n = length(x);
%newsig=zeroes(fix(n/fract+.5));
j=0;
for i=1:fract:n
    j=j+1;
    newsig(j)=x(i);
end
end
