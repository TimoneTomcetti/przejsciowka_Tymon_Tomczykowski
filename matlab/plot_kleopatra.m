close all;
clear;

model_fname = 'Kleopatra_Ostro.stl';
cd_splitted = split(mfilename('fullpath'),'\');
model_path = fullfile(cd_splitted{1:end-2},"model3d",model_fname);
model_temp = stlread(model_path);
model = triangulation(model_temp.ConnectivityList,model_temp.Points);
clear model_fname cd_splitted model_path model_temp centroid

trisurf(model,'Facecolor',[.7 .7 .7]);
axis equal;
xlabel('x [km]','Interpreter','latex');
ylabel('y [km]','Interpreter','latex');
zlabel('z [km]','Interpreter','latex');