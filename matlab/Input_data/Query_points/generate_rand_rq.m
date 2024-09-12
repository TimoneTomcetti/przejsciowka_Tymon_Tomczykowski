clear;
close all;
addpath 'C:\Projects\personal\przejsciowka\matlab\Functions'
addpath 'C:\Projects\personal\przejsciowka\matlab\Input_data'

a = -200000;
b = 200000;
n = 100;

[rq, rqn, i] = gen_points(a,b,n,"out",1.144612198106038e+05);

writematrix(rq,"rand_kleo.txt");