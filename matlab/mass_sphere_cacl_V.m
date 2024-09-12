clear;
close all;
addpath 'C:\Projects\personal\przejsciowka\matlab\Functions'
addpath 'C:\Projects\personal\przejsciowka\matlab\Input_data'


model_fname = 'sphere320.stl';
cd_splitted = split(mfilename('fullpath'),'\');
model_path = fullfile(cd_splitted{1:end-2},"model3d",model_fname);
model_temp = stlread(model_path);
model = triangulation(model_temp.ConnectivityList,model_temp.Points);
clear model_fname cd_splitted model_path model_temp centroid

bulk_density = 1;

a1 = 0.2;
a2 = 0.1;
a3 = 0.07;
a4 = 0.04;

mass_1 = mascons_obj(model,a1,bulk_density);
mass_2 = mascons_obj(model,a2,bulk_density);
mass_3 = mascons_obj(model,a3,bulk_density);
mass_4 = mascons_obj(model,a4,bulk_density);

%% Creating query points
x = linspace(-3,3,30); % m
y = x;
[X,Y] = meshgrid(x);
rq = [X(:),Y(:),zeros(length(X(:)),1)];

f1 = figure();
f1.Position = [100 100 700 700];
tiledlayout(1,2);
nexttile;
mass_1.plot_mascons("Spheres",'on');
nexttile;
mass_2.plot_mascons("Spheres",'on');

%% Calculating potential
mass_1.calculate(rq);
mass_2.calculate(rq);
mass_3.calculate(rq);
mass_4.calculate(rq);

mass_1.write_V('1');
mass_2.write_V('2');
mass_3.write_V('3');
mass_4.write_V('4');
