clear;
close all;
addpath 'C:\Projects\personal\przejsciowka\matlab\Functions'
addpath 'C:\Projects\personal\przejsciowka\matlab\Input_data\Coefs'

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

n = [4, 10, 50];
bulk_density = 3600;
a = 1.144612198106038e+05;

sh1 = spherical_harmonics_obj(model,bulk_density,n(1),a);
sh2 = spherical_harmonics_obj(model,bulk_density,n(2),a);
sh3 = spherical_harmonics_obj(model,bulk_density,n(3),a);

sh1.read_coefs_werner();
sh2.read_coefs_werner();
sh3.read_coefs_werner();

tic
sh1.calculate(sh1.C_nm,sh1.S_nm,rq);
t10 = toc
tic
sh2.calculate(sh2.C_nm,sh2.S_nm,rq);
t30 = toc
tic
sh3.calculate(sh3.C_nm,sh3.S_nm,rq);
t50 = toc

sh1.write_V('kleo_coef_4');
sh2.write_V('kleo_coef_10');
sh3.write_V('kleo_coef_50');

