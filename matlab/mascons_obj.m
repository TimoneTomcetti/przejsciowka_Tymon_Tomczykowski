classdef mascons_obj < handle
    properties
        stl_model % model of the asteroid
        points {mustBeNumeric} % positions of the mascons points
        R {mustBeNumeric} % radius of the spheres
        V {mustBeNumeric} % gravitational potential
        M_i {mustBeNumeric} % mass of one point
        r {mustBeNumeric} % query points
    end

    methods
        function obj = mascons_obj(model,mas_r, bulk_density) % constructor, divides objects into mascons
            arguments
                model triangulation
                mas_r double
                bulk_density double
            end

            cub_minmax = [min(model.Points); max(model.Points)];

            mas_p_x = (cub_minmax(1,1)+mas_r:mas_r*2:cub_minmax(2,1)-mas_r)';
            mas_p_y = (cub_minmax(1,2)+mas_r:mas_r*2:cub_minmax(2,2)-mas_r)';
            mas_p_z = (cub_minmax(1,3)+mas_r:mas_r*2:cub_minmax(2,3)-mas_r)';

            [mas_grid_x, mas_grid_y, mas_grid_z] = ndgrid(mas_p_x, mas_p_y, mas_p_z);
            mas_grid_p = [mas_grid_x(:) mas_grid_y(:) mas_grid_z(:)];

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

            Vol = stlVolume(obj.stl_model.Points',obj.stl_model.ConnectivityList');
            M = bulk_density * Vol;
            obj.M_i = M/length(obj.points(:,1));
        end

        function calculate(obj,r) % method calculating gravitational potential

            G = 6.6743e-11;

            obj.V = zeros(length(r(:,1)),1);

            for i = 1:length(r(:,1))
                rq = r(i,:);
                for k = 1:length(obj.points(:,1))
                    obj.V(i,1) = obj.V(i,1) + -(G * obj.M_i/(norm(rq - obj.points(k,:))));
                end
            end
            obj.r = r;
        end

        function axes = plot_mascons(obj,opt1,opt2) % method plotting mascons model
            arguments
                obj mascons_obj
                opt1.Spheres char
                opt2.Units char
            end

            if ~isfield(opt1,"Spheres")
                opt1.Spheres = 'off';
            end
            if ~isfield(opt2,"Units")
                opt2.Units = 'm';
            end

            model_temp = obj.stl_model;
            if strcmp(opt2.Units,'km')
                unit_scale = 1/1000;
                model_temp = triangulation(model_temp.ConnectivityList,model_temp.Points * unit_scale);
            end

            trisurf(model_temp,'FaceColor','black','FaceAlpha',0.2);
            hold on;
            if strcmp(opt1.Spheres,'on')

                for i = 1:length(obj.points(:,1))
                    [x_s, y_s, z_s] = sphere;
                    x_s = x_s * obj.R + obj.points(i,1);
                    y_s = y_s * obj.R + obj.points(i,2);
                    z_s = z_s * obj.R + obj.points(i,3);
                    if strcmp(opt2.Units,'km')
                        surf(x_s./1000,y_s./1000,z_s./1000);
                    elseif strcmp(opt2.Units,'m')
                        surf(x_s,y_s,z_s,'LineWidth',0.1);
                    end
                end
            else
                % scatter3(obj.points(:,1), obj.points(:,2), obj.points(:,3),'red');
            end
            hold off;
            xlabel(['x [',opt2.Units,']'],'Interpreter','latex');
            ylabel(['y [',opt2.Units,']'],'Interpreter','latex');
            zlabel(['z [',opt2.Units,']'],'Interpreter','latex');
            title([num2str(length(obj.points(:,1))), ' points']);
            axis equal;
            axes = gca;
        end

        function axes = plot_V(obj, r, scale, opt2) % method ploting gravitational potential
            arguments
                obj mascons_obj
                r double
                scale double
                opt2.Units char
            end
            if ~isfield(opt2,"Units")
                opt2.Units = 'm';
            end

            unit_scale = 1;

            model_temp = obj.stl_model;
            if strcmp(opt2.Units,'km')
                unit_scale = 1/1000;
                model_temp = triangulation(model_temp.ConnectivityList,model_temp.Points * unit_scale);
            end

            figure();
            trisurf(model_temp,'FaceColor','black','FaceAlpha',0.2);
            hold on;
            
            if strcmp(opt2.Units,'km')
                unit_scale = 1/1000;
                x_surf = r(:,1)*unit_scale;
                y_surf = r(:,2)*unit_scale;
                z_surf = r(:,3)*unit_scale+obj.V*scale*unit_scale;
            elseif strcmp(opt2.Units,'m')
                x_surf = r(:,1)*unit_scale;
                y_surf = r(:,2)*unit_scale;
                z_surf = r(:,3)*unit_scale+obj.V*scale*unit_scale;
            end
            
            

            xv = linspace(min(x_surf), max(x_surf), 50);
            yv = linspace(min(y_surf), max(y_surf), 50);
            [X_surf,Y_surf] = meshgrid(xv, yv);
            Z_surf = griddata(x_surf,y_surf,z_surf,X_surf,Y_surf);
            surf(X_surf, Y_surf, Z_surf);
            xlabel(['x [',opt2.Units,']'],'Interpreter','latex');
            ylabel(['y [',opt2.Units,']'],'Interpreter','latex');
            zlabel(['z [',opt2.Units,']'],'Interpreter','latex');
            title('Mascons Method Gravitational Potential');
            axis equal;
            cb = colorbar;
            set(cb,'TickLabels',cb.Ticks/(scale*unit_scale));
            cb.Label.String = 'V [J/kg]';
            axes = gca;
        end

        function write_V(obj,fname)
            V_fname = ['mass_V_',fname,'.txt'];
            V_fpath = fullfile(pwd,"Input_data","Potential_data",V_fname);
            writematrix([obj.r,obj.V],V_fpath);
        end
    end
end