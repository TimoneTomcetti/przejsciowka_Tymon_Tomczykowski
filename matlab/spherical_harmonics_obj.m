classdef spherical_harmonics_obj < handle
    properties
        stl_model
        V {mustBeNumeric}
        C_nm
        S_nm
        M
        a
        n_max
        bulk_density
    end

    methods
        function obj = spherical_harmonics_obj(model, bulk_density, n_max, a)
            arguments
                model triangulation
                bulk_density double
                n_max double
                a double
            end
            obj.n_max = n_max;
            obj.bulk_density = bulk_density;
            obj.stl_model = model;
            Vol = stlVolume(obj.stl_model.Points',obj.stl_model.ConnectivityList');
            obj.M = bulk_density * Vol;
            obj.a = a;
        end

        function calculate_coefs_point_masses(obj,mas_grid_p,M_i)
            arguments
                obj spherical_harmonics_obj
                mas_grid_p double
                M_i double
            end

            G = 6.6743e-11;

            n_max = obj.n_max;
            obj.C_nm = zeros(n_max+1,n_max+1);
            obj.S_nm = zeros(n_max+1,n_max+1);

            c = zeros(n_max+1,n_max+1,length(mas_grid_p(:,1)));
            s = zeros(n_max+1,n_max+1,length(mas_grid_p(:,1)));

            a = obj.a;

                for n = 0:n_max
                    for m = 0:n
                        for i = 1:length(mas_grid_p(:,1))
                            mas_point = mas_grid_p(i,:);
                            x_prim = mas_point(1);
                            y_prim = mas_point(2);
                            z_prim = mas_point(3);
                            r_prim = norm(mas_point);
                            if n == m
                                if n == 0
                                    c(1,1,i) = 1/obj.M;
                                    s(1,1,i) = 0;
                                elseif n == 1
                                    c(2,2,i) = 1/(sqrt(3)*obj.M*a)*x_prim;
                                    s(2,2,i) = 1/(sqrt(3)*obj.M*a)*y_prim;
                                else
                                    h_temp = (2*n-1)/(sqrt(2*n*(2*n+1))) * [x_prim/a, -y_prim/a; y_prim/a, x_prim/a] * [c(n,n,i); s(n,n,i)];
                                    c(n+1,n+1,i) = h_temp(1);
                                    s(n+1,n+1,i) = h_temp(2);
                                    h_temp = [];
                                end
                            elseif m == n-1
                                h_temp = (2*n-1)/(sqrt(2*n+1)) * z_prim/a * [c(n,n,i); s(n,n,i)];
                                c(n+1,n,i) = h_temp(1);
                                s(n+1,n,i) = h_temp(2);
                                h_temp = [];
                            elseif m < n-1
                                h_temp = (2*n-1)*sqrt((2*n-1)/((2*n+1)*(n+m)*(n-m))) * z_prim/a * [c(n,m+1,i); s(n,m+1,i)] - sqrt((2*n-3)*(n+m-1)*(n-m-1)/((2*n+1)*(n+m)*(n-m))) * (r_prim/a)^2 * [c(n-1,m+1,i); s(n-1,m+1,i)];
                                c(n+1,m+1,i) = h_temp(1);
                                s(n+1,m+1,i) = h_temp(2);
                                h_temp = [];
                            end
                        end
                    end
                end

                for i = 1:length(mas_grid_p(:,1))
                    if i == 1
                        obj.C_nm(:,:) = c(:,:,i) .* M_i;
                        obj.S_nm(:,:) = s(:,:,i) .* M_i;
                    else
                        obj.C_nm(:,:) = obj.C_nm(:,:) + c(:,:,i) .* M_i;
                        obj.S_nm(:,:) = obj.S_nm(:,:) + s(:,:,i) .* M_i;
                    end
                end




        end

        function calculate_coefs(obj)
            arguments
                obj spherical_harmonics_obj
            end
            set_of_edges = obj.stl_model.edges;
            set_of_faces = obj.stl_model.ConnectivityList;
            set_of_n_f = faceNormal(obj.stl_model);
            num_of_faces = length(set_of_faces(:,1));
            G = 6.6743e-11;

            n_max = obj.n_max;
            obj.C_nm = zeros(n_max+1);
            obj.S_nm = zeros(n_max+1);

            for n = 0:n_max
                if n > 1
                    c_prev2 = [];
                    s_prev2 = [];
                    c_prev2 = c_prev1;
                    s_prev2 = s_prev1;
                end
                if n > 0
                    c_prev1 = [];
                    s_prev1 = [];
                    c_prev1 = c;
                    s_prev1 = s;
                end
                t = (n+2)*(n+1)*0.5;
                c = zeros(t,n+1,num_of_faces);
                s = zeros(t,n+1,num_of_faces);
                for m = 0:n
                    for f = 1:num_of_faces
                        face = set_of_faces(f,:);
                        face_points = obj.stl_model.Points(face',:);
                        J = face_points';
                        x_prim = J(1,:);
                        y_prim = J(2,:);
                        z_prim = J(3,:);
                        if n == m
                            if n == 0
                                c(:,1,f) = 1/obj.M;
                                s(:,1,f) = 0;
                            elseif n == 1
                                c(:,2,f) = 1/(sqrt(3)*obj.M*obj.a)*x_prim;
                                s(:,2,f) = 1/(sqrt(3)*obj.M*obj.a)*y_prim;
                            else
                                c(:,m+1,f) = (2*n-1)/(sqrt(2*n*(2*n+1))*obj.a) * (tri_mult(x_prim,c_prev1(:,m,f)) - tri_mult(y_prim,s_prev1(:,m,f)));
                                s(:,m+1,f) = (2*n-1)/(sqrt(2*n*(2*n+1))*obj.a) * (tri_mult(y_prim,c_prev1(:,m,f)) + tri_mult(x_prim,s_prev1(:,m,f)));
                            end
                        elseif m == n-1
                            c(:,m+1,f) = (2*n - 1)/(sqrt(2*n+1) * obj.a) * tri_mult(z_prim,c_prev1(:,m + 1,f));
                            s(:,m+1,f) = (2*n - 1)/(sqrt(2*n+1) * obj.a) * tri_mult(z_prim,s_prev1(:,m + 1,f));
                        elseif m < n-1
                            c(:,m+1,f) = (2*n-1)*sqrt((2*n-1)/((2*n+1)*(n+m)*(n-m)))/obj.a * tri_mult(z_prim,c_prev1(:,m + 1,f)) - sqrt((2*n-3)*(n+m-1)*(n-m-1)/((2*n+1)*(n+m)*(n-m)))/(obj.a^2) * (tri_mult((tri_mult(x_prim,x_prim) + tri_mult(y_prim,y_prim) + tri_mult(z_prim,z_prim)),c_prev2(:,m + 1,f)));
                            s(:,m+1,f) = (2*n-1)*sqrt((2*n-1)/((2*n+1)*(n+m)*(n-m)))/obj.a * tri_mult(z_prim,s_prev1(:,m + 1,f)) - sqrt((2*n-3)*(n+m-1)*(n-m-1)/((2*n+1)*(n+m)*(n-m)))/(obj.a^2) * (tri_mult((tri_mult(x_prim,x_prim) + tri_mult(y_prim,y_prim) + tri_mult(z_prim,z_prim)),s_prev2(:,m + 1,f)));

                        end
                        obj.C_nm(n+1,m+1) = obj.C_nm(n+1,m+1) + integrate_simplex(c(:,m+1,f),det(J));
                        obj.S_nm(n+1,m+1) = obj.S_nm(n+1,m+1) + integrate_simplex(s(:,m+1,f),det(J));
                        disp(['face ', num2str(f), ' of ', num2str(num_of_faces), ', n = ', num2str(n)]);
                    end
                end
            end
            obj.C_nm = obj.C_nm*obj.bulk_density;
            obj.S_nm = obj.S_nm*obj.bulk_density;

        end

        function calculate(obj,C,S,r_query,centroid)
            obj.V = zeros(length(r_query(:,1)),1);
            G = 6.6743e-11;
            for i = 1:length(r_query(:,1))
                rq = r_query(i,:) - centroid;
                r = norm(rq);
                lat = asin(rq(3)/r);
                lon = atan2(rq(2),rq(1));
                n_max = obj.n_max;
                sum_m = 0;
                sum_n = 0;
                for n = 1:n_max
                    P = legendre(n,sin(lat));
                    for m = 0:n
                        N = sqrt((2-double(n==m)) * (2*n+1) * factorial(n-m) / factorial(n+m));
                        sum_m = sum_m + N * P(m+1) * (C(n+1,m+1)*cos(m*lon) + S(n+1,m+1)*sin(m*lon));
                    end
                    sum_n = sum_n + (obj.a/r)^n * sum_m;
                    sum_m = 0;
                end
                obj.V(i,1) = G*obj.M/r * (1+sum_n);
                sum_n = 0;
            end
        end

        function write_coefs_werner(obj)
            C_fname = ['C_werner_',num2str(obj.n_max),'.txt'];
            C_fpath = fullfile(pwd,"Input_data","Coefs",C_fname);
            writematrix(obj.C_nm,C_fpath)

            S_fname = ['S_werner_',num2str(obj.n_max),'.txt'];
            S_fpath = fullfile(pwd,"Input_data","Coefs",S_fname);
            writematrix(obj.S_nm,S_fpath)
        end

        function write_coefs_mas(obj, mas_r)
            C_fname = ['C_mas_',num2str(obj.n_max),'_',num2str(mas_r),'.txt'];
            C_fpath = fullfile(pwd,"Input_data","Coefs",C_fname);
            writematrix(obj.C_nm,C_fpath)

            S_fname = ['S_mas_',num2str(obj.n_max),'_',num2str(mas_r),'.txt'];
            S_fpath = fullfile(pwd,"Input_data","Coefs",S_fname);
            writematrix(obj.S_nm,S_fpath)
        end

        function read_coefs_werner(obj)
            C_fname = ['C_werner_',num2str(obj.n_max),'.txt'];
            C_fpath = fullfile(pwd,"Input_data","Coefs",C_fname);
            S_fname = ['S_werner_',num2str(obj.n_max),'.txt'];
            S_fpath = fullfile(pwd,"Input_data","Coefs",S_fname);

            obj.C_nm = readmatrix(C_fpath);
            obj.S_nm = readmatrix(S_fpath);
        end

        function read_coefs_mas(obj, mas_r)
            C_fname = ['C_mas_',num2str(obj.n_max),'_',num2str(mas_r),'.txt'];
            C_fpath = fullfile(pwd,"Input_data","Coefs",C_fname);
            S_fname = ['S_mas_',num2str(obj.n_max),'_',num2str(mas_r),'.txt'];
            S_fpath = fullfile(pwd,"Input_data","Coefs",S_fname);

            obj.C_nm = readmatrix(C_fpath);
            obj.S_nm = readmatrix(S_fpath);
        end


        function axes = plot_V(obj, r, scale, opt2)
            arguments
                obj spherical_harmonics_obj
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
                z_surf = r(:,3)*unit_scale-obj.V*scale*unit_scale;
            elseif strcmp(opt2.Units,'m')
                x_surf = r(:,1)*unit_scale;
                y_surf = r(:,2)*unit_scale;
                z_surf = r(:,3)*unit_scale-obj.V*scale*unit_scale;
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