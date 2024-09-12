close all;
clear;

base = IcosahedronMesh();



f1 = figure();
f1.Position = [100 100 800 600];
tiledlayout(f1,2,2);
nexttile
trisurf(base);
xlabel('x [m]','Interpreter','latex');
ylabel('y [m]','Interpreter','latex');
zlabel('z [m]','Interpreter','latex');
xlim([-1,1]);
daspect([1 1 1]);
title('20 faces');


complex1 = SubdivideSphericalMesh(base,1);

nexttile;
trisurf(complex1);
axis equal;
xlabel('x [m]','Interpreter','latex');
ylabel('y [m]','Interpreter','latex');
zlabel('z [m]','Interpreter','latex');
title('80 faces');

complex2 = SubdivideSphericalMesh(base,2);

nexttile
trisurf(complex2);
axis equal;
xlabel('x [m]','Interpreter','latex');
ylabel('y [m]','Interpreter','latex');
zlabel('z [m]','Interpreter','latex');
title('320 faces');

complex3 = SubdivideSphericalMesh(base,3);

nexttile
trisurf(complex3);
axis equal;
xlabel('x [m]','Interpreter','latex');
ylabel('y [m]','Interpreter','latex');
zlabel('z [m]','Interpreter','latex');
title('1280 faces');