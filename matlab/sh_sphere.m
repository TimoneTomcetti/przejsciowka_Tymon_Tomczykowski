clear;
% close all;
addpath 'C:\Projects\personal\przejsciowka\matlab\Functions'
addpath 'C:\Projects\personal\przejsciowka\matlab\Input_data'

%% Reading model
model_fname = 'sphere320.stl';
cd_splitted = split(mfilename('fullpath'),'\');
model_path = fullfile(cd_splitted{1:end-2},"model3d",model_fname);
model_temp = stlread(model_path);
model = triangulation(model_temp.ConnectivityList,model_temp.Points);
clear model_fname cd_splitted model_path model_temp centroid

V_scale = 4*10^9;
% V_scale = 1;

x = linspace(-3,3,20); % m
y = x;
[X,Y] = meshgrid(x);
rq = [X(:),Y(:),zeros(length(X(:)),1)];

sh_method = spherical_harmonics_obj(model,1,8,1);
sh_method.calculate_coefs();
sh_method.calculate(sh_method.C_nm,sh_method.S_nm,rq);
sh_method.plot_V(rq,V_scale,'Units','m');


a = 1;
M = 4/3 * pi * a^3;
G = 6.6743e-11;
for i = 1:length(rq(:,1))
    r = norm(rq(i,:));
    if r > 1
        V(i) = -G*M/r;
    else
        V(i) = -G*M* (3*a^2 - r^2)/(2*a^3);
    end
end
V_sar = reshape(V,[length(x),length(x)]) * V_scale;
hold on;
surf(X,Y,V_sar,'FaceAlpha',0.5);
