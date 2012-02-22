clc
clear
close all

[s_e1, sr] = wavread('1.wav');
[s_e2, sr] = wavread('2.wav');
[s_e3, sr] = wavread('3.wav');
[s, sr] = wavread('1_1.wav');


dtwcompare(s_e1, s_e3, sr);

