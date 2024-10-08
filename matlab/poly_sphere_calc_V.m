clear;
% close all;
addpath 'C:\Projects\personal\przejsciowka\matlab\Functions'
addpath 'C:\Projects\personal\przejsciowka\matlab\Input_data'

%% Reading model
model_fname = 'sphere20.stl';
cd_splitted = split(mfilename('fullpath'),'\');
model_path = fullfile(cd_splitted{1:end-2},"model3d",model_fname);
model_temp = stlread(model_path);
model20 = triangulation(model_temp.ConnectivityList,model_temp.Points);
clear model_fname cd_splitted model_path model_temp centroid

model_fname = 'sphere80.stl';
cd_splitted = split(mfilename('fullpath'),'\');
model_path = fullfile(cd_splitted{1:end-2},"model3d",model_fname);
model_temp = stlread(model_path);
model80 = triangulation(model_temp.ConnectivityList,model_temp.Points);
clear model_fname cd_splitted model_path model_temp centroid

model_fname = 'sphere320.stl';
cd_splitted = split(mfilename('fullpath'),'\');
model_path = fullfile(cd_splitted{1:end-2},"model3d",model_fname);
model_temp = stlread(model_path);
model320 = triangulation(model_temp.ConnectivityList,model_temp.Points);
clear model_fname cd_splitted model_path model_temp centroid

model_fname = 'sphere1280.stl';
cd_splitted = split(mfilename('fullpath'),'\');
model_path = fullfile(cd_splitted{1:end-2},"model3d",model_fname);
model_temp = stlread(model_path);
model1280 = triangulation(model_temp.ConnectivityList,model_temp.Points);
clear model_fname cd_splitted model_path model_temp centroid

%% Creating objects 
poly20 = polyhedron_obj(model20);
poly80 = polyhedron_obj(model80);
poly320 = polyhedron_obj(model320);
poly1280 = polyhedron_obj(model1280);

%% Creating query points
x = linspace(-3,3,30); % m
y = x;
[X,Y] = meshgrid(x);
rq = [X(:),Y(:),zeros(length(X(:)),1)];

%% Calculating potential
bulk_density = 1;

poly20.calculate(rq,bulk_density);
poly80.calculate(rq,bulk_density);
poly320.calculate(rq,bulk_density);
poly1280.calculate(rq,bulk_density);

poly20.write_V('20');
poly80.write_V('80');
poly320.write_V('320');
poly1280.write_V('1280');


% 
% % V_scale = 4*10^9;
% V_scale = 1;
% 
% x = linspace(-3,3,20); % m
% y = x;
% [X,Y] = meshgrid(x);
% rq = [X(:),Y(:),zeros(length(X(:)),1)];
% 
% polyhedron_method = polyhedron_obj(model);
% polyhedron_method.calculate(rq,1);
% polyhedron_method.plot_V(rq,V_scale,'Units','m');
% 
% 
% a = 1;
% M = 4/3 * pi * a^3;
% G = 6.6743e-11;
% for i = 1:length(rq(:,1))
%     r = norm(rq(i,:));
%     if r > 1
%         V(i) = -G*M/r;
%     else
%         V(i) = -G*M* (3*a^2 - r^2)/(2*a^3);
%     end
% end
% V_sar = reshape(V,[length(x),length(x)]) * V_scale;
% hold on;
% surf(X,Y,V_sar,'FaceAlpha',0.5);


