function newsig = interp_var(x,N,M)
load(strcat('interp_var_table_data_',num2str(N),'_',num2str(M),'.mat'));
v=zeros(1,N);
%L1=zeros(N,1);
%Q1=zeros(N);
v=x-x(1);
%y=Q*v';
%J=1;
%L=diag(L);
%squeeze(L);
%for i=0:(N-1)
%   if L(N-i)>0
%        L1(J)=L(N-i);
%        Q1(:,J)=Q(:,N-i);
%        J=J+1;   
%   end
   
%end
%L1(J:N)=[];
%J=J-1;
%w=y./L1;
%B=Q1*w;
u=x(1)*ones(N*M,1)+c*a^(-1)*v';
%k_index=1;
for i=2:N*M
    u(i-1)=u(i);
    %k_index=k_index+M;
end
newsig=u(1:N*M-1);
end