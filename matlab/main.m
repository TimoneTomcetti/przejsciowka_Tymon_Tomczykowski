clear;
close all;
addpath 'C:\Projects\personal\przejsciowka\matlab\Functions'
addpath 'C:\Projects\personal\przejsciowka\matlab\Input_data'

% Configuration file name
config_fname = "sh.json";

%% Reading config
config_path = fullfile(pwd,"Input_data","Config",config_fname);
config_fid = fopen(config_path);
config_raw = fread(config_fid);
config = jsondecode(char(config_raw'));
fclose(config_fid);
clear config_raw config_fid config_path config_fname

r_fname = config.main_configuration.query_points_file;
r_path = fullfile(pwd,"Input_data","Query_points",r_fname);
r = readmatrix(r_path);
clear r_fname r_path

%% Reading model
model_fname = config.main_configuration.model_file;
cd_splitted = split(mfilename('fullpath'),'\');
model_path = fullfile(cd_splitted{1:end-2},"model3d",model_fname);
model_temp = stlread(model_path);
model_temp = triangulation(model_temp.ConnectivityList,model_temp.Points * config.main_configuration.unit_scale);
centroid = calculate_centroid(model_temp);
model = triangulation(model_temp.ConnectivityList,model_temp.Points - centroid);
clear model_fname cd_splitted model_path model_temp centroid

%% Calculating gracitational potential
method = config.method.method_name;
if strcmp(method,"Spherical Harmonics")
        spherical_harmonics_method = spherical_harmonics_obj(model,config.main_configuration.bulk_density,config.method.degree,config.method.a);
        if strcmp(config.method.calculation_algorithm,"werner")
            if exist(fullfile(pwd,"Input_data","Coefs",['C_werner_',num2str(config.method.degree),'.txt']),'file') == 2
                spherical_harmonics_method.read_coefs_werner();
            else
            spherical_harmonics_method.calculate_coefs();
            spherical_harmonics_method.write_coefs_werner();
            end
        else
            mas_r = config.method.mas_r;
            if exist(fullfile(pwd,"Input_data","Coefs",['C_mas_',num2str(config.method.degree),'_',num2str(mas_r),'.txt']),'file') == 2
                spherical_harmonics_method.read_coefs_mas(mas_r)
            else
            mascons_method = mascons_obj(model,mas_r,config.main_configuration.bulk_density);
            spherical_harmonics_method.calculate_coefs_point_masses(mascons_method.points,mascons_method.M_i);
            spherical_harmonics_method.write_coefs_mas(mas_r);
            end
        end
elseif strcmp(method,"Mascons")
mascons_method = mascons_obj(model,config.method.mas_r,config.main_configuration.bulk_density);
mascons_method.calculate(r);
elseif strcmp(method,"Polyhedron")
polyhedron_method = polyhedron_obj(model);
polyhedron_method.calculate(r,config.main_configuration.bulk_density);

else
    disp("Wrong method chosen. Available methods: Spherical Harmonics, Mascons or Polyhedron");
end
clear method