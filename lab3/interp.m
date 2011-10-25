function newsig = interp(x,fd,fd2)
n=length(x);
j=0;
newsig=zeros(1,fix(n*fd2/fd));
for i=1:fd2/fd:n*fd2/fd
   j=j+1;
   newsig(i)=x(j); 
end

for i=2:n*fd2/fd
    if mod(i-1,fd2/fd)~=0
        for j = 1:fd2/fd:n*fd2/fd
            newsig(i)=newsig(i)+newsig(j)*(sin(pi*fd*(i-j)/fd2)/(pi*fd*(i-j)/fd2));
        end
    end
        
end

end