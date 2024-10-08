clear;
close all;

unit_scale = 1000;

model_fname = 'Kleopatra_Ostro.stl';
cd_splitted = split(mfilename('fullpath'),'\');
model_path = fullfile(cd_splitted{1:end-2},"model3d",model_fname);
model_temp = stlread(model_path);
model_temp = triangulation(model_temp.ConnectivityList,model_temp.Points * unit_scale);
centroid = calculate_centroid(model_temp);
model = triangulation(model_temp.ConnectivityList,model_temp.Points - centroid);
clear model_fname cd_splitted model_path model_temp centroid

model_new.vertices = model.Points;
model_new.faces = model.ConnectivityList;
for i = 1:length(model.Points(:,1))
    dist(i) = norm(model.Points(i,:));
end
dist_max = max(dist);