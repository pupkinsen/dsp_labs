function interp_var_tables(N,M,fd)
    a=zeros(N,N);
    c=zeros(N*M,N);
    b=zeros(N*M,N+1);
    Q=zeros(N,N);
    L=zeros(N,N);
    Td=1/fd;
    v1=0;
    v2=pi;
   
    for k=1:N

       for i=1:N
          %calculating matrix a
          f=@(X)((sin(X*k/2).*sin(X*i/2))./(X*.5).^2).*cos(.5*X*(k-i));
          q=quad(f,v1,v2,1e-4);
          a(k,i)=(Td/pi)*q;
       end
    end
    
    for k=1:(N*M)
        for i=1:N
             %calculating matrix c
          f=@(X)((sin(X*k/(2*M)).*sin(X*i/2))./(X*.5).^2).*cos(.5*X*(k/M-i));
          q=quad(f,v1,v2,1e-4);
          c(k,i)=(Td/pi)*q;
        end
    end
    
    for k=1:(N*M)

        for i=1:N+1
            %calculating matrix b
          f=@(X)(sin(X*k/2)./(X*.5).^2).*cos(.5*X*(2*k/M-i));
          q=quad(f,v1,v2,1e-4);
          b(k,i)=(1/pi)*q;
        end
    end
 
 [Q, L]=eig(a);   
 save('interp_var_table_data.mat', 'a', 'b', 'c', 'Q', 'L');
end