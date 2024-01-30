% close all;
clear;

path_to_model = 'model3d\Kleopatra_Ostro.stl';
model_temp = stlread(path_to_model);
unit_scale = 1000;
model = triangulation(model_temp.ConnectivityList,model_temp.Points * unit_scale);

plot = 1;

if plot == 1
f1 = figure();
trisurf(model,'FaceColor','black','FaceAlpha',0.2);
axis equal;
end

%% test
% r = [0, 8000, 0; 0, -8000, 0] * 1;
% r = [100,0,0];
x = linspace(-300000,300000,50);
y = x;
[X,Y] = meshgrid(x);
r = [X(:),Y(:),zeros(length(X(:)),1)];

set_of_edges = model.edges;
set_of_faces = model.ConnectivityList;
set_of_n_f = faceNormal(model);
G = 6.6743e-11;
bulk_density = 3600; % kg/m^3

sum_e = zeros(length(r(:,1)),1);
sum_f = zeros(length(r(:,1)),1);

w_f_check = 0;

% file = fopen('debug.txt','w');
for i = 1:length(r(:,1))
    rq = r(i,:);
    for k = 1:length(set_of_edges(:,1))
        edge = set_of_edges(k,:);
        p_a = model.Points(edge(1),:);
        p_b = model.Points(edge(2),:);
        E_e = get_E_e(model,edge,plot);
        L_e = get_L_e(rq,p_a,p_b);
        r_e = get_r_ef(rq,p_a);

        sum_e(i,1) = sum_e(i,1) + (L_e * r_e * E_e * r_e');
        
        % fprintf(file,'sum_i = %e, sum_e = %e, r_e = %f %f %f, k = %d, i = %d\n', L_e * r_e * E_e * r_e', sum_e(i,1), r_e(1), r_e(2), r_e(3), k, i);
    end

    for k = 1:length(set_of_faces(:,1))
        face = set_of_faces(k,:);
        face_points = model.Points(face',:);
        n_f = set_of_n_f(k,:);
        F_f = get_F_f(n_f);
        w_f = get_w_f(rq,face_points);
        w_f_check = w_f_check + w_f;
        r_f = get_r_ef(rq,face_points(1,:));
        sum_f(i,1) = sum_f(i,1) + (w_f * r_f * F_f * r_f');
    end
    disp([num2str(i) '/' num2str(length(x)^2)]);
end
% fclose(file);

V = -0.5 * G * bulk_density * (sum_e - sum_f);

x_surf = X(:);
y_surf = Y(:);
z_surf = V*10^2;

xv = linspace(min(x_surf), max(x_surf), 50);
yv = linspace(min(y_surf), max(y_surf), 50);
[X_surf,Y_surf] = meshgrid(xv, yv);
Z_surf = griddata(x_surf,y_surf,z_surf,X_surf,Y_surf);
hold on;
surf(X_surf, Y_surf, Z_surf);