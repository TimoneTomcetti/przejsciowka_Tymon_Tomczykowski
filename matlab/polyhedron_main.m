close all;
clear;

%% Initial data (TODO in json file)
% Asteroid data
model_fname = "Kleopatra_Ostro.stl";
bulk_density = 3600; % kg/m^3

% Field query points
x = linspace(-300000,300000,30); % m
y = x;
[X,Y] = meshgrid(x);
r = [X(:),Y(:),zeros(length(X(:)),1)];

% Polyhedron method configuration
unit_scale = 1000; % for models provided not in meters

% Ploting configuration
plot_unit = 'km'; % units of plots (km or m)
V_scale = 10^2; % scale of the potential plot

%% Main section
% Creating mascons model
polyhedron_method = polyhedron_obj(model_fname,unit_scale);
% Calculating gravitational potential
polyhedron_method.calculate(r,bulk_density);
% Plotting results
polyhedron_method.plot_V(r,V_scale,'Units',plot_unit);