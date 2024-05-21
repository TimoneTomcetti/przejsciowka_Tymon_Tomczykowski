clear;
close all;

unit_scale = 1000;
cd_splitted = split(mfilename('fullpath'),'\');
path_to_model = fullfile(cd_splitted{1:end-2},"model3d","Kleopatra_Ostro.stl");
model_temp = stlread(path_to_model);
model = triangulation(model_temp.ConnectivityList,model_temp.Points * unit_scale);

model_new.vertices = model.Points;
model_new.faces = model.ConnectivityList;
for i = 1:length(model.Points(:,1))
    dist(i) = norm(model.Points(i,:));
end
dist_max = max(dist);