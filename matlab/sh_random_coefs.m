clear;
close all;
addpath 'C:\Projects\personal\przejsciowka\matlab\Functions'
addpath 'C:\Projects\personal\przejsciowka\matlab\Input_data'

r_fname = 'rand_out.txt';
r_path = fullfile(pwd,"Input_data","Query_points",r_fname);
rq = readmatrix(r_path);
clear r_fname r_path


%% Reading model


model_fname = 'sphere320.stl';
cd_splitted = split(mfilename('fullpath'),'\');
model_path = fullfile(cd_splitted{1:end-2},"model3d",model_fname);
model_temp = stlread(model_path);
model = triangulation(model_temp.ConnectivityList,model_temp.Points);
clear model_fname cd_splitted model_path model_temp centroid

n = [2, 6, 12, 20];
bulk_density = 1;
a = 1;
sh1 = spherical_harmonics_obj(model,bulk_density,n(1),a);
sh1.calculate_coefs();
sh2 = spherical_harmonics_obj(model,bulk_density,n(2),a);
sh2.calculate_coefs();
sh3 = spherical_harmonics_obj(model,bulk_density,n(3),a);
sh3.calculate_coefs();
sh4 = spherical_harmonics_obj(model,bulk_density,n(4),a);
sh4.calculate_coefs();

%% Calculate V
tic
sh1.calculate(sh1.C_nm,sh1.S_nm,rq);
t10 = toc
tic
sh2.calculate(sh2.C_nm,sh2.S_nm,rq);
t20 = toc
tic
sh3.calculate(sh3.C_nm,sh3.S_nm,rq);
t30 = toc
tic
sh4.calculate(sh4.C_nm,sh4.S_nm,rq);
t40 = toc

sh1.write_V('rand_coef_1');
sh2.write_V('rand_coef_2');
sh3.write_V('rand_coef_3');
sh4.write_V('rand_coef_4');
