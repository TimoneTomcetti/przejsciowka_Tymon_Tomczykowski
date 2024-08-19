close all;
clear;

base = IcosahedronMesh();

f1 = figure();
trimesh(base);
axis equal;

complex1 = SubdivideSphericalMesh(base,1);

f2 = figure();
trimesh(complex1);
axis equal;

complex2 = SubdivideSphericalMesh(base,2);

f3 = figure();
trimesh(complex2);
axis equal;

complex3 = SubdivideSphericalMesh(base,3);

f4 = figure();
trimesh(complex3);
axis equal;