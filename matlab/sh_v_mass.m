clear;
close all;
addpath 'C:\Projects\personal\przejsciowka\matlab\Functions'
addpath 'C:\Projects\personal\przejsciowka\matlab\Input_data'

r_fname = 'rand_out.txt';
r_path = fullfile(pwd,"Input_data","Query_points",r_fname);
rq_out = readmatrix(r_path);
clear r_fname r_path

V_fpath_40 = fullfile(pwd,"Input_data","Potential_data","sh_V_rand_coef_4.txt");
V_fpath_4 = fullfile(pwd,"Input_data","Potential_data","mass_V_rand_out4.txt");

V4_out = readmatrix(V_fpath_4);
V4_out = V4_out(:,4);


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



err_sh = abs(V40-V_out)./abs(V_out);

rqn = vecnorm(rq_out,2,2);
err_mass = abs(V4_out-V_out)./abs(V_out);
f3 = figure();
scatter(rqn,err_mass);
hold on;
scatter(rqn,err_sh);
grid on;
xlabel('Odległość od środka masy modelu [m]');
ylabel('Błąd względny');
legend('Point masses','Spherical Harmonics');