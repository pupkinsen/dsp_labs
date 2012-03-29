function dist = dtw3(M1,M2) 
n = size(M1,1); 
m = size(M2,1); 

d = zeros(n,m); 
 
 for i = 1:n 
 for j = 1:m 
 	d(i,j) = sum((M1(i,:)-M2(j,:)).^2); 
 end 
 end

D =  ones(n,m) * realmax; 
D(1,1) = d(1,1); 

for i = 2:n 
for j = 1:m 
	D1 = D(i-1,j); 
 
	if j>1 
		D2 = D(i-1,j-1); 
    else 
        D2 = realmax; 
	end 
 
	if j>2 
		D3 = D(i-1,j-2); 
    else 
        D3 = realmax; 
	end 
 
	D(i,j) = d(i,j) + min([D1,D2,D3]); 
end 
end 
 
dist = D(n,m);
% M=d;
% 
%  [r,c] = size(M);
% 
% 
%     D = zeros(r+1, c+1);
%     D(1,:) = NaN;
%     D(:,1) = NaN;
%     D(1,1) = 0;
%     D(2:(r+1), 2:(c+1)) = M;
% 
% 
%     phi = zeros(r,c);
% 
%     for i = 1:r; 
%       for j = 1:c;
%         [dmax, tb] = min([D(i, j), D(i, j+1), D(i+1, j)]);
%         D(i+1,j+1) = D(i+1,j+1)+dmax;
%         phi(i,j) = tb;
%       end
%     end
%     
%     dist=D(end,end);
    
%       D = zeros(r+1, c+1);
%     D(1,:) = NaN;
%     D(:,1) = NaN;
%     D(1,1) = 0;
%     D(2:(r+1), 2:(c+1)) = M;
%     D=rot90(D,2);
% 
%     phi = zeros(r,c);
% 
%     for i = 1:r; 
%       for j = 1:c;
%         [dmax, tb] = min([D(i, j), D(i, j+1), D(i+1, j)]);
%         D(i+1,j+1) = D(i+1,j+1)+dmax;
%         phi(i,j) = tb;
%       end
%     end
%     
%     dis=dist+D(end,end);