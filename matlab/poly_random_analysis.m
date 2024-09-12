clear;
close all;
addpath 'C:\Projects\personal\przejsciowka\matlab\Functions'
addpath 'C:\Projects\personal\przejsciowka\matlab\Input_data'

r_fname = 'rand_in.txt';
r_path = fullfile(pwd,"Input_data","Query_points",r_fname);
rq_in = readmatrix(r_path);
clear r_fname r_path

r_fname = 'rand_out.txt';
r_path = fullfile(pwd,"Input_data","Query_points",r_fname);
rq_out = readmatrix(r_path);
clear r_fname r_path

V_fpath_20 = fullfile(pwd,"Input_data","Potential_data","poly_V_rand_in20.txt");
V_fpath_80 = fullfile(pwd,"Input_data","Potential_data","poly_V_rand_in80.txt");
V_fpath_320 = fullfile(pwd,"Input_data","Potential_data","poly_V_rand_in320.txt");
V_fpath_1280 = fullfile(pwd,"Input_data","Potential_data","poly_V_rand_in1280.txt");

V20_in = readmatrix(V_fpath_20);
V20_in = V20_in(:,4);
V80_in = readmatrix(V_fpath_80);
V80_in = V80_in(:,4);
V320_in = readmatrix(V_fpath_320);
V320_in = V320_in(:,4);
V1280_in = readmatrix(V_fpath_1280);
V1280_in = V1280_in(:,4);

V_fpath_20 = fullfile(pwd,"Input_data","Potential_data","poly_V_rand_out20.txt");
V_fpath_80 = fullfile(pwd,"Input_data","Potential_data","poly_V_rand_out80.txt");
V_fpath_320 = fullfile(pwd,"Input_data","Potential_data","poly_V_rand_out320.txt");
V_fpath_1280 = fullfile(pwd,"Input_data","Potential_data","poly_V_rand_out1280.txt");

V20_out = readmatrix(V_fpath_20);
V20_out = V20_out(:,4);
V80_out = readmatrix(V_fpath_80);
V80_out = V80_out(:,4);
V320_out = readmatrix(V_fpath_320);
V320_out = V320_out(:,4);
V1280_out = readmatrix(V_fpath_1280);
V1280_out = V1280_out(:,4);

a = 1; % radius
M = 4/3 * pi * a^3; % mass of a sphere
G = 6.6743e-11; % gravitational constant
for i = 1:length(rq_in(:,1))
    r = norm(rq_in(i,:));
    if r > 1
        V_in(i) = -G*M/r;
    else
        V_in(i) = -G*M* (3*a^2 - r^2)/(2*a^3);
    end
end
for i = 1:length(rq_out(:,1))
    r = norm(rq_out(i,:));
    if r > 1
        V_out(i) = -G*M/r;
    else
        V_out(i) = -G*M* (3*a^2 - r^2)/(2*a^3);
    end
end
V_in = V_in';
V_out = V_out';

err_20_in = mean(abs(V20_in-V_in)./abs(V_in));
err_80_in = mean(abs(V80_in-V_in)./abs(V_in));
err_320_in = mean(abs(V320_in-V_in)./abs(V_in));
err_1280_in = mean(abs(V1280_in-V_in)./abs(V_in));

err_20_out = mean(abs(V20_out-V_out)./abs(V_out));
err_80_out = mean(abs(V80_out-V_out)./abs(V_out));
err_320_out = mean(abs(V320_out-V_out)./abs(V_out));
err_1280_out = mean(abs(V1280_out-V_out)./abs(V_out));

faces = [20, 80, 320, 1280];
err_in = [err_20_in, err_80_in, err_320_in, err_1280_in];
err_out = [err_20_out, err_80_out, err_320_out, err_1280_out];

f1 = figure();
f1.Position = [100 100 1200 500];
tiledlayout(1,2);
nexttile;
scatter(faces,err_in,'filled','red');
title('Points inside the sphere');
ylabel('Mean relative error');
xlabel('Number of faces');
grid on;
nexttile;
scatter(faces,err_out,'filled','red');
title('Points outside the sphere');
ylabel('Mean relative error');
xlabel('Number of faces');
grid on;

t_in = [0.97, 3.63, 14.41, 57.71];
t_out = [1.20, 3.81, 15.22, 58.46];

f2 = figure();
f2.Position = [100 100 1200 500];
tiledlayout(1,2);
nexttile;
scatter(faces,t_in,'filled','red');
title('Points inside the sphere');
ylabel('Time of calculation [s]');
xlabel('Number of faces');
grid on;
nexttile;
scatter(faces,t_out,'filled','red');
title('Points outside the sphere');
ylabel('Time of calculation [s]');
xlabel('Number of faces');
grid on;
