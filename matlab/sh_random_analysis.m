clear;
close all;
addpath 'C:\Projects\personal\przejsciowka\matlab\Functions'
addpath 'C:\Projects\personal\przejsciowka\matlab\Input_data'
addpath 'C:\Projects\personal\przejsciowka\matlab\Input_data\Potential_data\'

r_fname = 'rand_out.txt';
r_path = fullfile(pwd,"Input_data","Query_points",r_fname);
rq_out = readmatrix(r_path);
clear r_fname r_path


V_fpath_20 = fullfile(pwd,"Input_data","Potential_data","sh_V_rand_mesh_20.txt");
V_fpath_80 = fullfile(pwd,"Input_data","Potential_data","sh_V_rand_mesh_80.txt");
V_fpath_320 = fullfile(pwd,"Input_data","Potential_data","sh_V_rand_mesh_320.txt");
V_fpath_1280 = fullfile(pwd,"Input_data","Potential_data","sh_V_rand_mesh_1280.txt");

V20 = readmatrix(V_fpath_20);
V20 = -V20(:,4);
V80 = readmatrix(V_fpath_80);
V80 = -V80(:,4);
V320 = readmatrix(V_fpath_320);
V320 = -V320(:,4);
V1280 = readmatrix(V_fpath_1280);
V1280 = -V1280(:,4);

a = 1; % radius
M = 4/3 * pi * a^3; % mass of a sphere
G = 6.6743e-11; % gravitational constant
for i = 1:length(rq_out(:,1))
    r = norm(rq_out(i,:));
    if r > 1
        V_out(i) = -G*M/r;
    else
        V_out(i) = -G*M* (3*a^2 - r^2)/(2*a^3);
    end
end
V_out = V_out';

err_20 = mean(abs(V20-V_out)./abs(V_out));
err_80 = mean(abs(V80-V_out)./abs(V_out));
err_320 = mean(abs(V320-V_out)./abs(V_out));
err_1280 = mean(abs(V1280-V_out)./abs(V_out));

faces = [20, 80, 320, 1280];
err_out = [err_20, err_80, err_320, err_1280];

f1 = figure();
f1.Position = [100 100 1000 500];
scatter(faces,err_out,'filled','red');
title('Points outside the sphere');
ylabel('Mean relative error');
xlabel('Number of faces');
grid on;

t_out = [0.0357, 0.0344, 0.0347, 0.0349];

f2 = figure();
f2.Position = [100 100 1000 500];
scatter(faces,t_out,'filled','red');
title('Points outside the sphere');
ylabel('Time of calculation [s]');
xlabel('Number of faces');
grid on;
