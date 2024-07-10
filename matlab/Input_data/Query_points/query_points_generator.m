clear;
close all;

x = linspace(-300000,300000,30); % m
y = x;
[X,Y] = meshgrid(x);
r = [X(:),Y(:),-6e+4 * ones(length(X(:)),1)];

writematrix(r,"test.txt");