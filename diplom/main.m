clc
clear
close all
%Creating dictionary hashtable
Dict = java.util.Hashtable;

[s_e1_3, sr] = wavread('1_3.wav');
s_e1_3=truncword(s_e1_3);
Dict.put('1',s_e1_3);

[s_e2_3, sr] = wavread('2_3.wav');
s_e2_3=truncword(s_e2_3);
Dict.put('2',s_e2_3);

[s_e3_3, sr] = wavread('3_3.wav');
s_e3_3=truncword(s_e3_3);
Dict.put('3',s_e3_3);

[s_e4_3, sr] = wavread('4_3.wav');
s_e4_3=truncword(s_e4_3);
Dict.put('4',s_e4_3);

[s_e5_3, sr] = wavread('5_3.wav');
s_e5_3=truncword(s_e5_3);
Dict.put('5',s_e5_3);

[s_e6_3, sr] = wavread('6_3.wav');
s_e6_3=truncword(s_e6_3);
Dict.put('6',s_e6_3);

[s_e7_3, sr] = wavread('7_3.wav');
s_e7_3=truncword(s_e7_3);
Dict.put('7',s_e7_3);

[s_e8_3, sr] = wavread('8_3.wav');
s_e8_3=truncword(s_e8_3);
Dict.put('8',s_e8_3);

[s_e9_3, sr] = wavread('9_3.wav');
s_e9_3=truncword(s_e9_3);
Dict.put('9',s_e9_3);

[s_e0_3, sr] = wavread('0_3.wav');
s_e0_3=truncword(s_e0_3);
Dict.put('0',s_e0_3);



%%%%%%%%%%%%%%%%%%%%


[s, sr] = wavread('1.wav');
s=truncword(s);

hashKeys = Dict.keys;
i=1;
while hashKeys.hasMoreElements
        
        key=hashKeys.nextElement;
        wordslist(i)=key;
        distancelist(i)=DTWdistance(s,Dict.get(key),sr); 
        i=i+1;
end
bar(9:-1:0,distancelist);
set(gca,'XLim',[-1 10]);
title('DTW distance');
xlabel('number');
ylabel('distance');
[m, k] = min(distancelist);
disp(10-k);




