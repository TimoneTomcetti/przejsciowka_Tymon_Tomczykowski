clear;
close all;
addpath 'C:\Projects\personal\przejsciowka\matlab\Functions'
addpath 'C:\Projects\personal\przejsciowka\matlab\Input_data'

r_fname = 'rand_in.txt';
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
poly20 = polyhedron_obj(model20);
poly80 = polyhedron_obj(model80);
poly320 = polyhedron_obj(model320);
poly1280 = polyhedron_obj(model1280);

%% Calculating potential
bulk_density = 1;

tic
poly20.calculate(rq,bulk_density);
t20 = toc
tic
poly80.calculate(rq,bulk_density);
t80 = toc
tic
poly320.calculate(rq,bulk_density);
t320 = toc
tic
poly1280.calculate(rq,bulk_density);
t1280 = toc

poly20.write_V('rand_in20');
poly80.write_V('rand_in80');
poly320.write_V('rand_in320');
poly1280.write_V('rand_in1280');




% f1 = figure();
% scatter3(rq(:,1),rq(:,2),rq(:,3),'filled','red');
% hold on;
% [x_s,y_s,z_s] = sphere;
% surf(x_s,y_s,z_s,'FaceAlpha',0.2);
% xlim([a,b]);
% ylim([a,b]);
% zlim([a,b]);
% daspect([1 1 1]);
