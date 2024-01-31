classdef polyhedron_obj < handle
    properties
        stl_model
        V {mustBeNumeric}
    end

    methods
        function obj = polyhedron_obj(model_name, unit_scale)
            arguments
                model_name string
                unit_scale double
            end
            cd_splitted = split(pwd,'\');
            path_to_model = fullfile(cd_splitted{1:end-1},"model3d",model_name);
            model_temp = stlread(path_to_model);
            model = triangulation(model_temp.ConnectivityList,model_temp.Points * unit_scale);

            obj.stl_model = model;
        end

        function calculate(obj,r,bulk_density, opt1)
            arguments
                obj polyhedron_obj
                r double
                bulk_density double
                opt1.Test_plot char
            end
            if ~isfield(opt1,"Test_plot")
                opt1.Test_plot = 'off';
            end
            
            addpath Functions\

            set_of_edges = obj.stl_model.edges;
            set_of_faces = obj.stl_model.ConnectivityList;
            set_of_n_f = faceNormal(obj.stl_model);
            G = 6.6743e-11;

            sum_e = zeros(length(r(:,1)),1);
            sum_f = zeros(length(r(:,1)),1);

            w_f_check = 0;

            for i = 1:length(r(:,1))
                rq = r(i,:);
                for k = 1:length(set_of_edges(:,1))
                    edge = set_of_edges(k,:);
                    p_a = obj.stl_model.Points(edge(1),:);
                    p_b = obj.stl_model.Points(edge(2),:);
                    E_e = get_E_e(obj.stl_model,edge,opt1.Test_plot);
                    L_e = get_L_e(rq,p_a,p_b);
                    r_e = get_r_ef(rq,p_a);

                    sum_e(i,1) = sum_e(i,1) + (L_e * r_e * E_e * r_e');

                end

                for k = 1:length(set_of_faces(:,1))
                    face = set_of_faces(k,:);
                    face_points = obj.stl_model.Points(face',:);
                    n_f = set_of_n_f(k,:);
                    F_f = get_F_f(n_f);
                    w_f = get_w_f(rq,face_points);
                    w_f_check = w_f_check + w_f;
                    r_f = get_r_ef(rq,face_points(1,:));
                    sum_f(i,1) = sum_f(i,1) + (w_f * r_f * F_f * r_f');
                end
                disp([num2str(i) '/' num2str(length(r(:,1)))]);
            end

            obj.V = -0.5 * G * bulk_density * (sum_e - sum_f);
        end



        function axes = plot_V(obj, r, scale, opt2)
            arguments
                obj polyhedron_obj
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
                z_surf = obj.V*scale*unit_scale;
            elseif strcmp(opt2.Units,'m')
                x_surf = r(:,1)*unit_scale;
                y_surf = r(:,2)*unit_scale;
                z_surf = obj.V*scale*unit_scale;
            end


            xv = linspace(min(x_surf), max(x_surf), 50);
            yv = linspace(min(y_surf), max(y_surf), 50);
            [X_surf,Y_surf] = meshgrid(xv, yv);
            Z_surf = griddata(x_surf,y_surf,z_surf,X_surf,Y_surf);
            surf(X_surf, Y_surf, Z_surf);
            xlabel(['x [',opt2.Units,']'],'Interpreter','latex');
            ylabel(['y [',opt2.Units,']'],'Interpreter','latex');
            zlabel(['z [',opt2.Units,']'],'Interpreter','latex');
            title('Polyhedron Method Gravitational Potential');
            axis equal;
            cb = colorbar;
            set(cb,'TickLabels',cb.Ticks/(scale*unit_scale));
            cb.Label.String = 'V [J/kg]';
            axes = gca;
        end
    end
end