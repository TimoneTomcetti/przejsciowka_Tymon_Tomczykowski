clear;
close all;
addpath 'C:\Projects\personal\przejsciowka\matlab\Functions'
addpath 'C:\Projects\personal\przejsciowka\matlab\Input_data\Coefs'

V_poly_path = fullfile(pwd,"Input_data","Potential_data","poly_V_kleo.txt");
V_mass1_path = fullfile(pwd,"Input_data","Potential_data","mass_V_kleo1.txt");
V_mass2_path = fullfile(pwd,"Input_data","Potential_data","mass_V_kleo2.txt");
V_mass3_path = fullfile(pwd,"Input_data","Potential_data","mass_V_kleo3.txt");
V_sh1_path = fullfile(pwd,"Input_data","Potential_data","sh_V_kleo_coef_4.txt");
V_sh2_path = fullfile(pwd,"Input_data","Potential_data","sh_V_kleo_coef_10.txt");
V_sh3_path = fullfile(pwd,"Input_data","Potential_data","sh_V_kleo_coef_50.txt");

V_poly = readmatrix(V_poly_path);
rq = V_poly(:,1:3);
rqn = vecnorm(rq,2,2);
V_poly = V_poly(:,4);


V_mass1 = readmatrix(V_mass1_path);
V_mass1 = V_mass1(:,4);
V_mass2 = readmatrix(V_mass2_path);
V_mass2 = V_mass2(:,4);
V_mass3 = readmatrix(V_mass3_path);
V_mass3 = V_mass3(:,4);

V_sh1 = readmatrix(V_sh1_path);
V_sh1 = -V_sh1(:,4);
V_sh2 = readmatrix(V_sh2_path);
V_sh2 = -V_sh2(:,4);
V_sh3 = readmatrix(V_sh3_path);
V_sh3 = -V_sh3(:,4);

V = [V_mass1, V_mass2, V_mass3, V_sh1, V_sh2, V_sh3];

for i = 1:length(V(1,:))
    err(i) = mean(abs(V(:,i)-V_poly)./abs(V_poly));
end

t = []


err_sh = abs(V_sh3-V_poly)./abs(V_poly);
p = fit(rqn,err_sh,'exp1');
px = sort(rqn);

plot(p,rqn,err_sh);
grid on;
xlabel('Odległość od środka masy modelu [m]');
ylabel('Błąd względny');

