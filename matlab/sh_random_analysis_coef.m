clear;
close all;
addpath 'C:\Projects\personal\przejsciowka\matlab\Functions'
addpath 'C:\Projects\personal\przejsciowka\matlab\Input_data'

r_fname = 'rand_out.txt';
r_path = fullfile(pwd,"Input_data","Query_points",r_fname);
rq_out = readmatrix(r_path);
clear r_fname r_path


V_fpath_10 = fullfile(pwd,"Input_data","Potential_data","sh_V_rand_coef_1.txt");
V_fpath_20 = fullfile(pwd,"Input_data","Potential_data","sh_V_rand_coef_2.txt");
V_fpath_30 = fullfile(pwd,"Input_data","Potential_data","sh_V_rand_coef_3.txt");
V_fpath_40 = fullfile(pwd,"Input_data","Potential_data","sh_V_rand_coef_4.txt");

V10 = readmatrix(V_fpath_10);
V10 = -V10(:,4);
V20 = readmatrix(V_fpath_20);
V20 = -V20(:,4);
V30 = readmatrix(V_fpath_30);
V30 = -V30(:,4);
V40 = readmatrix(V_fpath_40);
V40 = -V40(:,4);

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

err_10 = mean(abs(V10-V_out)./abs(V_out));
err_20 = mean(abs(V20-V_out)./abs(V_out));
err_30 = mean(abs(V30-V_out)./abs(V_out));
err_40 = mean(abs(V40-V_out)./abs(V_out));

faces = [2, 6, 12, 20];
err_out = [err_10, err_20, err_30, err_40];

f1 = figure();
f1.Position = [100 100 1000 500];
scatter(faces,err_out,'filled','red');
title('Points outside the sphere');
ylabel('Mean relative error');
xlabel('Degree');
grid on;

t_out = [0.0043, 0.016, 0.0455, 0.1096];

f2 = figure();
f2.Position = [100 100 1000 500];
scatter(faces,t_out,'filled','red');
title('Points outside the sphere');
ylabel('Time of calculation [s]');
xlabel('Degree');
grid on;

rqn = vecnorm(rq_out,2,2);
err_sh = abs(V40-V_out)./abs(V_out);
f3 = figure();
scatter(rqn,err_sh);
grid on;
xlabel('Odległość od środka masy modelu [m]');
ylabel('Błąd względny');
