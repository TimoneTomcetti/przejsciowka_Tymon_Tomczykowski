function points = mascons(model,mas_r,options)
arguments
    model triangulation
    mas_r double
    options.Plot char
    options.Spheres char
end

if ~isfield(options,"Plot")
      options.Plot = 'off';
end

if ~isfield(options,"Spheres")
      options.Spheres = 'off';
end


cub_minmax = [min(model.Points); max(model.Points)];

mas_p_x = (cub_minmax(1,1):mas_r*2:cub_minmax(2,1))';
mas_p_y = (cub_minmax(1,2):mas_r*2:cub_minmax(2,2))';
mas_p_z = (cub_minmax(1,3):mas_r*2:cub_minmax(2,3))';

[mas_grid_x, mas_grid_y, mas_grid_z] = ndgrid(mas_p_x, mas_p_y, mas_p_z);
mas_grid_p = [mas_grid_x(:) mas_grid_y(:) mas_grid_z(:)];

in = intriangulation(model.Points,model.ConnectivityList,mas_grid_p);

mas_grid_p = [mas_grid_p(in==1,1),mas_grid_p(in==1,2),mas_grid_p(in==1,3)];

model_new.vertices = model.Points;
model_new.faces = model.ConnectivityList;

[dist, ~] = point2trimesh(model_new,'QueryPoints',mas_grid_p);
mas_grid_p = [mas_grid_p(abs(dist)>mas_r,1),mas_grid_p(abs(dist)>mas_r,2),mas_grid_p(abs(dist)>mas_r,3)];

if strcmp(options.Plot,'on')
    f1 = figure();
    trisurf(model,'FaceColor','cyan','FaceAlpha',0.2);
    hold on;
    if strcmp(options.Spheres,'on')

    for i = 1:length(mas_grid_p(:,1))
        [x_s, y_s, z_s] = sphere;
        x_s = x_s * mas_r + mas_grid_p(i,1);
        y_s = y_s * mas_r + mas_grid_p(i,2);
        z_s = z_s * mas_r + mas_grid_p(i,3);
        surf(x_s,y_s,z_s);
    end
    else
        scatter3(mas_grid_p(:,1), mas_grid_p(:,2), mas_grid_p(:,3),'red');
    end
    axis equal;
end

points = mas_grid_p;

end