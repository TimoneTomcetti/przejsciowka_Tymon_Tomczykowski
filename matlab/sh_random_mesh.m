clear;
close all;
addpath 'C:\Projects\personal\przejsciowka\matlab\Functions'
addpath 'C:\Projects\personal\przejsciowka\matlab\Input_data'

r_fname = 'rand_out.txt';
r_path = fullfile(pwd,"Input_data","Query_points",r_fname);
rq = readmatrix(r_path);
clear r_fname r_path


%% Reading model
model_fname = 'sphere20.stl';
cd_splitted = split(mfilename('fullpath'),'\');
model_path = fullfile(cd_splitted{1:end-2},"model3d",model_fname);
model_temp = stlread(model_path);
model20 = triangulation(model_temp.ConnectivityList,model_temp.Points);
clear model_fname cd_splitted model_path model_temp centroid

model_fname = 'sphere80.stl';
cd_splitted = split(mfilename('fullpath'),'\');
model_path = fullfile(cd_splitted{1:end-2},"model3d",model_fname);
model_temp = stlread(model_path);
model80 = triangulation(model_temp.ConnectivityList,model_temp.Points);
clear model_fname cd_splitted model_path model_temp centroid

model_fname = 'sphere320.stl';
cd_splitted = split(mfilename('fullpath'),'\');
model_path = fullfile(cd_splitted{1:end-2},"model3d",model_fname);
model_temp = stlread(model_path);
model320 = triangulation(model_temp.ConnectivityList,model_temp.Points);
clear model_fname cd_splitted model_path model_temp centroid

model_fname = 'sphere1280.stl';
cd_splitted = split(mfilename('fullpath'),'\');
model_path = fullfile(cd_splitted{1:end-2},"model3d",model_fname);
model_temp = stlread(model_path);
model1280 = triangulation(model_temp.ConnectivityList,model_temp.Points);
clear model_fname cd_splitted model_path model_temp centroid

%% Creating objects 

n = 10;
bulk_density = 1;
a = 1;
sh20 = spherical_harmonics_obj(model20,bulk_density,n,a);
sh20.calculate_coefs();
sh80 = spherical_harmonics_obj(model80,bulk_density,n,a);
sh80.calculate_coefs();
sh320 = spherical_harmonics_obj(model320,bulk_density,n,a);
sh320.calculate_coefs();
sh1280 = spherical_harmonics_obj(model1280,bulk_density,n,a);
sh1280.calculate_coefs();


%% Calculating potential

tic
sh20.calculate(sh20.C_nm,sh20.S_nm,rq);
t20 = toc
tic
sh80.calculate(sh80.C_nm,sh80.S_nm,rq);
t80 = toc
tic
sh320.calculate(sh320.C_nm,sh320.S_nm,rq);
t320 = toc
tic
sh1280.calculate(sh1280.C_nm,sh1280.S_nm,rq);
t1280 = toc

sh20.write_V('rand_mesh_20');
sh80.write_V('rand_mesh_80');
sh320.write_V('rand_mesh_320');
sh1280.write_V('rand_mesh_1280');




% f1 = figure();
% scatter3(rq(:,1),rq(:,2),rq(:,3),'filled','red');
% hold on;
% [x_s,y_s,z_s] = sphere;
% surf(x_s,y_s,z_s,'FaceAlpha',0.2);
% xlim([a,b]);
% ylim([a,b]);
% zlim([a,b]);
% daspect([1 1 1]);
