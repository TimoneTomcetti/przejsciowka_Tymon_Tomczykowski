close all;
clear;
addpath 'C:\Projects\personal\przejsciowka\matlab\Functions'

%% Initial data (TODO in json file)
% Asteroid data
model_fname = "Kleopatra_Ostro.stl";
bulk_density = 3600; % kg/m^3

% Field query points
x = linspace(-300000,300000,30); % m
y = x;
[X,Y] = meshgrid(x);
r = [X(:),Y(:),-6e+4 * ones(length(X(:)),1)];

% Spherical_harmonics method configuration
unit_scale = 1000; % for models provided not in meters

% Ploting configuration
plot_unit = 'm'; % units of plots (km or m)
V_scale = 10^2; % scale of the potential plot

%% Main section
% Creating mascons model
spherical_harmonics_method = spherical_harmonics_obj(model_fname,unit_scale,bulk_density,8);

centroid = spherical_harmonics_method.calculate_centroid();
% Calculating gravitational potential
spherical_harmonics_method.calculate_coefs(bulk_density,centroid);

% Point masses method
% mas_r = 5000;
% mascons_method = mascons_obj(model_fname,mas_r,unit_scale,bulk_density);
% spherical_harmonics_method.calculate_coefs_point_masses(centroid,mascons_method.points,mascons_method.M_i);

spherical_harmonics_method.calculate(spherical_harmonics_method.C_nm,spherical_harmonics_method.S_nm,r,centroid);

spherical_harmonics_method.plot_V(r,V_scale,'Units',plot_unit);