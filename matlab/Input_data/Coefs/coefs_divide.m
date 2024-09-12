close all;
clear;

C50 = readmatrix('C_werner_50.txt');
S50 = readmatrix('S_werner_50.txt');

C4 = C50(1:5,1:5);
S4 = S50(1:5,1:5);

C10 = C50(1:11,1:11);
S10 = S50(1:11,1:11);

writematrix(C4,'C_werner_4.txt');
writematrix(S4,'S_werner_4.txt');
writematrix(C10,'C_werner_10.txt');
writematrix(S10,'S_werner_10.txt');