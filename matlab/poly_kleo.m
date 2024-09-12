clear;
close all;
addpath 'C:\Projects\personal\przejsciowka\matlab\Functions'
addpath 'C:\Projects\personal\przejsciowka\matlab\Input_data'

r_fname = 'rand_kleo.txt';
r_path = fullfile(pwd,"Input_data","Query_points",r_fname);
rq = readmatrix(r_path);
clear r_fname r_path

unit_scale = 1000;

model_fname = 'Kleopatra_Ostro.stl';
cd_splitted = split(mfilename('fullpath'),'\');
model_path = fullfile(cd_splitted{1:end-2},"model3d",model_fname);
model_temp = stlread(model_path);
model_temp = triangulation(model_temp.ConnectivityList,model_temp.Points * unit_scale);
centroid = calculate_centroid(model_temp);
model = triangulation(model_temp.ConnectivityList,model_temp.Points - centroid);
clear model_fname cd_splitted model_path model_temp centroid

poly = polyhedron_obj(model);

bulk_density = 3600;

tic
poly.calculate(rq,bulk_density);
t_poly = toc;

poly.write_V('kleo');
