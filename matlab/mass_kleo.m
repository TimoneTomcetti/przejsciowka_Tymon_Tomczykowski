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

%% Creating objects 
bulk_density = 3600;

a1 = 12000;
a2 = 8000;
a3 = 4000;

mass_1 = mascons_obj(model,a1,bulk_density);
mass_2 = mascons_obj(model,a2,bulk_density);
mass_3 = mascons_obj(model,a3,bulk_density);


%% Calculating potential

tic
mass_1.calculate(rq);
t1 = toc
tic
mass_2.calculate(rq);
t2 = toc
tic
mass_3.calculate(rq);
t3 = toc

mass_1.write_V('kleo1');
mass_2.write_V('kleo2');
mass_3.write_V('kleo3');

f1 = figure();
f1.Position = [100 100 700 700];
mass_1.plot_mascons("Spheres",'on','Units','km');