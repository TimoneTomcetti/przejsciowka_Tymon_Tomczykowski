% close all;
clear;

path_to_model = 'model3d\Kleopatra_Ostro.stl';
model_temp = stlread(path_to_model);
unit_scale = 1000;
model = triangulation(model_temp.ConnectivityList,model_temp.Points * unit_scale);

%% Mascons

radius = 5000;
mascons_kleopatra = mascons_obj(model,radius);
mascons_kleopatra.plot_mascons('Spheres','on');

mass_centers = mascons_kleopatra.points;

% r = [0, 8000, 0; 0, -8000, 0] * 1;
% r = [100,0,0];
x = linspace(-300000,300000,30);
y = x;
[X,Y] = meshgrid(x);
r = [X(:),Y(:),zeros(length(X(:)),1)];

G = 6.6743e-11;
bulk_density = 3600; % kg/m^3
V = stlVolume(model.Points',model.ConnectivityList');
M = bulk_density * V;
M_i = M/length(mass_centers(:,1));

V = zeros(length(r(:,1)),1);

for i = 1:length(r(:,1))
    rq = r(i,:);
    for k = 1:length(mass_centers(:,1))
        V(i,1) = V(i,1) + -(G * M_i/(norm(rq - mass_centers(k,:))));
    end
end

% stem3(r(:,1),r(:,2),V*10^7);

x_surf = X(:);
y_surf = Y(:);
z_surf = V*10^2;

xv = linspace(min(x_surf), max(x_surf), 50);
yv = linspace(min(y_surf), max(y_surf), 50);
[X_surf,Y_surf] = meshgrid(xv, yv);
Z_surf = griddata(x_surf,y_surf,z_surf,X_surf,Y_surf);
surf(X_surf, Y_surf, Z_surf);