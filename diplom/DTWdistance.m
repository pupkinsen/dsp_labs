function distance=DTWdistance(siga, sigb, sr )
    %DTW Dynamic time warp distance measurement
%   Measures distance between siga and sigb using DTW algorithm
     S1 = abs(spectrogram(siga,512,384,512,sr));
     S2 = abs(spectrogram(sigb,512,384,512,sr));
     %S1 = abs(mycepsgram(siga,512,256));
     %S2 = abs(mycepsgram(sigb,512,256));
    
    ES1 = sqrt(sum(S1.^2))+1e-12;
    ES2 = sqrt(sum(S2.^2))+1e-12;
    M = (S1'*S2)./(ES1'*ES2);
    M=1-M;
          
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
    
    distance=D(end,end);

end