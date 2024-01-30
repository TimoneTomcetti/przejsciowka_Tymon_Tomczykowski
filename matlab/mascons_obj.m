classdef mascons_obj
    properties
        stl_model
        points {mustBeNumeric}
        R {mustBeNumeric}
    end

    methods
        function obj = mascons_obj(model,mas_r)
            arguments
                model triangulation
                mas_r double
            end

            cub_minmax = [min(model.Points); max(model.Points)];

            mas_p_x = (cub_minmax(1,1)+mas_r:mas_r*2:cub_minmax(2,1)-mas_r)';
            mas_p_y = (cub_minmax(1,2)+mas_r:mas_r*2:cub_minmax(2,2)-mas_r)';
            mas_p_z = (cub_minmax(1,3)+mas_r:mas_r*2:cub_minmax(2,3)-mas_r)';

            [mas_grid_x, mas_grid_y, mas_grid_z] = ndgrid(mas_p_x, mas_p_y, mas_p_z);
            mas_grid_p = [mas_grid_x(:) mas_grid_y(:) mas_grid_z(:)];

            % in = intriangulation(model.Points,model.ConnectivityList,mas_grid_p);
            in = inpolyhedron(model.ConnectivityList,model.Points,mas_grid_p);

            mas_grid_p = [mas_grid_p(in==1,1),mas_grid_p(in==1,2),mas_grid_p(in==1,3)];

            model_new.vertices = model.Points;
            model_new.faces = model.ConnectivityList;
            
            err = 1e-15;

            [dist, ~] = point2trimesh(model_new,'QueryPoints',mas_grid_p);
            in2 = (abs(dist)+err)>=mas_r;

            mas_grid_p = [mas_grid_p(in2==1,1),mas_grid_p(in2==1,2),mas_grid_p(in2==1,3)];
            
            obj.stl_model = model;
            obj.points = mas_grid_p;
            obj.R = mas_r;
        end

        function axes = plot_mascons(obj,options)
            arguments
                obj mascons_obj
                options.Spheres char
            end

            if ~isfield(options,"Spheres")
                options.Spheres = 'off';
            end

            f1 = figure();
            trisurf(obj.stl_model,'FaceColor','black','FaceAlpha',0.2);
            hold on;
            if strcmp(options.Spheres,'on')

                for i = 1:length(obj.points(:,1))
                    [x_s, y_s, z_s] = sphere;
                    x_s = x_s * obj.R + obj.points(i,1);
                    y_s = y_s * obj.R + obj.points(i,2);
                    z_s = z_s * obj.R + obj.points(i,3);
                    surf(x_s,y_s,z_s);
                end
            else
                % scatter3(obj.points(:,1), obj.points(:,2), obj.points(:,3),'red');
            end
            axis equal;
            axes = gca;
        end
    end
end