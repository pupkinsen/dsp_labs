clc
clear
close all
%Creating dictionary hashtable
Dict = java.util.Hashtable;

[s_e1_3, sr] = wavread('1_3.wav');
s_e1_3=mfcc(truncword(s_e1_3));
Dict.put('1',s_e1_3);

[s_e2_3, sr] = wavread('2_2.wav');
s_e2_3=mfcc(truncword(s_e2_3));
Dict.put('2',s_e2_3);

[s_e3_3, sr] = wavread('3_3.wav');
s_e3_3=mfcc(truncword(s_e3_3));
Dict.put('3',s_e3_3);

[s_e4_3, sr] = wavread('4_3.wav');
s_e4_3=mfcc(truncword(s_e4_3));
Dict.put('4',s_e4_3);

[s_e5_3, sr] = wavread('5_2.wav');
s_e5_3=mfcc(truncword(s_e5_3));
Dict.put('5',s_e5_3);

[s_e6_3, sr] = wavread('6_3.wav');
s_e6_3=mfcc(truncword(s_e6_3));
Dict.put('6',s_e6_3);

[s_e7_3, sr] = wavread('7_3.wav');
s_e7_3=mfcc(truncword(s_e7_3));
Dict.put('7',s_e7_3);

[s_e8_3, sr] = wavread('8_3.wav');
s_e8_3=mfcc(truncword(s_e8_3));
Dict.put('8',s_e8_3);

[s_e9_3, sr] = wavread('9_3.wav');
s_e9_3=mfcc(truncword(s_e9_3));
Dict.put('9',s_e9_3);

[s_e0_3, sr] = wavread('0_2.wav');
s_e0_3=mfcc(truncword(s_e0_3));
Dict.put('0',s_e0_3);



%%%%%%%%%%%%%%%%%%%%
err=0;
for count=0:9
    [s, sr] = wavread(strcat(num2str(count),'_s.wav'));
    
    % tone=.4.*sin(300.*(1:3200));
    % sound(tone,8000);
    % disp('Start speaking.')
    % s=wavrecord(1.5*sr,sr);
    % disp('End of Recording.');


    s=truncword(s);
    %sound(s,sr);



    hashKeys = Dict.keys;
    i=1;
    while hashKeys.hasMoreElements

            key=hashKeys.nextElement;
            wordslist(i)=key;
            mfcc_s=mfcc(s);
            mfcc_e=Dict.get(key);
           distancelist(i)=dtw3(mfcc_s(:,1:24),mfcc_e(:,1:24)); 
    %        refword=Dict.get(key);
    %        distancelist(i)=dtw3(kannumfcc(24,s',sr),kannumfcc(24,refword,sr));
            i=i+1;
    end


    [m, k] = min(distancelist);
   % disp(10-k);
    if (10-k)~=count
        err=err+1;
        disp(strcat('ошибка распознавани€: ',num2str(count),', распознана как: ', num2str(10-k)));
        figure(count+1)
            bar(9:-1:0,distancelist);
    set(gca,'XLim',[-1 10]);
    title(strcat('DTW distance:  ',num2str(count)));
    xlabel('number');
    ylabel('distance');
    end
    
end
disp(strcat('ошибок: ', num2str(10*err),'%'));
%sound(Dict.get(num2str(10-k)),sr)




