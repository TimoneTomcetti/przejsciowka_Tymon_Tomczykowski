clear;
% close all;
addpath 'C:\Projects\personal\przejsciowka\matlab\Functions'
addpath 'C:\Projects\personal\przejsciowka\matlab\Input_data'

%% Reading model
unit_scale = 1000;

model_fname = 'Kleopatra_Ostro.stl';
cd_splitted = split(mfilename('fullpath'),'\');
model_path = fullfile(cd_splitted{1:end-2},"model3d",model_fname);
model_temp = stlread(model_path);
model_temp = triangulation(model_temp.ConnectivityList,model_temp.Points * unit_scale);
centroid = calculate_centroid(model_temp);
model = triangulation(model_temp.ConnectivityList,model_temp.Points - centroid);
clear model_fname cd_splitted model_path model_temp centroid


a = -200000;
b = 200000;
n = 100;
rq = gen_points_kleo(a,b,n,model);

trimesh(model);
hold on;
scatter3(rq(:,1),rq(:,2),rq(:,3));
axis equal;

writematrix(rq,"rand_kleo.txt");

