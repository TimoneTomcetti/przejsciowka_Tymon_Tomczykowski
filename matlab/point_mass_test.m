clear;

G = 6.6743e-11;
R = 0.5;
Vol = 4/3 * pi * R^3;
M = 1000;

density = M/Vol;

r = [100,0,0];

V = -G * M / norm(r);