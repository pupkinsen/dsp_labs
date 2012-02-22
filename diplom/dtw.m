function [ p, q, D ] = dtw( siga, sigb, sr )
%DTW Dynamic time warp
%   Detailed explanation goes here
    S1 = abs(spectrogram(siga,512,384,512,sr));
    S2 = abs(spectrogram(sigb,512,384,512,sr));
    
    ES1 = sqrt(sum(S1.^2))+1e-12;
    ES2 = sqrt(sum(S2.^2))+1e-12;
    M = (S1'*S2)./(ES1'*ES2);
    M=1-M;
    imagesc(M);
    
    colormap(gray)
        
    [r,c] = size(M);


    D = zeros(r+1, c+1);
    D(1,:) = NaN;
    D(:,1) = NaN;
    D(1,1) = 0;
    D(2:(r+1), 2:(c+1)) = M;


    phi = zeros(r,c);

    for i = 1:r; 
      for j = 1:c;
        [dmax, tb] = min([D(i, j), D(i, j+1), D(i+1, j)]);
        D(i+1,j+1) = D(i+1,j+1)+dmax;
        phi(i,j) = tb;
      end
    end


    i = r; 
    j = c;
    p = i;
    q = j;
    while i > 1 && j > 1
      tb = phi(i,j);
      if (tb == 1)
        i = i-1;
        j = j-1;
      elseif (tb == 2)
        i = i-1;
      elseif (tb == 3)
        j = j-1;
      else    
        error;
      end
      p = [i,p];
      q = [j,q];
    end


    D = D(2:(r+1),2:(c+1));
    
end

