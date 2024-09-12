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

V_fpath_1 = fullfile(pwd,"Input_data","Potential_data","mass_V_rand_in1.txt");
V_fpath_2 = fullfile(pwd,"Input_data","Potential_data","mass_V_rand_in2.txt");
V_fpath_3 = fullfile(pwd,"Input_data","Potential_data","mass_V_rand_in3.txt");
V_fpath_4 = fullfile(pwd,"Input_data","Potential_data","mass_V_rand_in4.txt");

V1_in = readmatrix(V_fpath_1);
V1_in = V1_in(:,4);
V2_in = readmatrix(V_fpath_2);
V2_in = V2_in(:,4);
V3_in = readmatrix(V_fpath_3);
V3_in = V3_in(:,4);
V4_in = readmatrix(V_fpath_4);
V4_in = V4_in(:,4);

V_fpath_1 = fullfile(pwd,"Input_data","Potential_data","mass_V_rand_out1.txt");
V_fpath_2 = fullfile(pwd,"Input_data","Potential_data","mass_V_rand_out2.txt");
V_fpath_3 = fullfile(pwd,"Input_data","Potential_data","mass_V_rand_out3.txt");
V_fpath_4 = fullfile(pwd,"Input_data","Potential_data","mass_V_rand_out4.txt");

V1_out = readmatrix(V_fpath_1);
V1_out = V1_out(:,4);
V2_out = readmatrix(V_fpath_2);
V2_out = V2_out(:,4);
V3_out = readmatrix(V_fpath_3);
V3_out = V3_out(:,4);
V4_out = readmatrix(V_fpath_4);
V4_out = V4_out(:,4);

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

err_1_in = mean(abs(V1_in-V_in)./abs(V_in));
err_2_in = mean(abs(V2_in-V_in)./abs(V_in));
err_3_in = mean(abs(V3_in-V_in)./abs(V_in));
err_4_in = mean(abs(V4_in-V_in)./abs(V_in));

err_1_out = mean(abs(V1_out-V_out)./abs(V_out));
err_2_out = mean(abs(V2_out-V_out)./abs(V_out));
err_3_out = mean(abs(V3_out-V_out)./abs(V_out));
err_4_out = mean(abs(V4_out-V_out)./abs(V_out));

points = [27, 360, 1181, 3448];
err_in = [err_1_in, err_2_in, err_3_in, err_4_in];
err_out = [err_1_out, err_2_out, err_3_out, err_4_out];

f1 = figure();
f1.Position = [100 100 1200 500];
tiledlayout(1,2);
nexttile;
scatter(points,err_in,'filled','red');
title('Query points inside the sphere');
ylabel('Mean relative error');
xlabel('Number of mass points');
grid on;
nexttile;
scatter(points,err_out,'filled','red');
title('Query points outside the sphere');
ylabel('Mean relative error');
xlabel('Number of mass points');
grid on;

t_in = [0.04, 0.49, 4.71, 81.52];
t_out = [0.04, 0.49, 4.96, 82.3];

f2 = figure();
f2.Position = [100 100 1200 500];
tiledlayout(1,2);
nexttile;
scatter(points,t_in,'filled','red');
title('Query points inside the sphere');
ylabel('Time of calculation [s]');
xlabel('Number of mass points');
grid on;
nexttile;
scatter(points,t_out,'filled','red');
title('Query points outside the sphere');
ylabel('Time of calculation [s]');
xlabel('Number of mass points');
grid on;

rqn = vecnorm(rq_out,2,2);
err_sh = abs(V4_out-V_out)./abs(V_out);
f3 = figure();
scatter(rqn,err_sh);
grid on;
xlabel('Odległość od środka masy modelu [m]');
ylabel('Błąd względny');
