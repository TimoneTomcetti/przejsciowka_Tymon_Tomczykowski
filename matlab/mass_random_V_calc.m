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


%% Creating objects 
bulk_density = 1;

a1 = 0.2;
a2 = 0.1;
a3 = 0.06;
a4 = 0.05;
vol = 4/3*pi;

mass_1 = mascons_obj(model,a1,bulk_density,vol);
mass_2 = mascons_obj(model,a2,bulk_density,vol);
mass_3 = mascons_obj(model,a3,bulk_density,vol);
mass_4 = mascons_obj(model,a4,bulk_density,vol);

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
tic
mass_4.calculate(rq);
t4 = toc

mass_1.write_V('rand_out1');
mass_2.write_V('rand_out2');
mass_3.write_V('rand_out3');
mass_4.write_V('rand_out4');




% f1 = figure();
% scatter3(rq(:,1),rq(:,2),rq(:,3),'filled','red');
% hold on;
% [x_s,y_s,z_s] = sphere;
% surf(x_s,y_s,z_s,'FaceAlpha',0.2);
% xlim([a,b]);
% ylim([a,b]);
% zlim([a,b]);
% daspect([1 1 1]);
