close all;
clear;


V_fpath_20 = fullfile(pwd,"Input_data","Potential_data","poly_V_20.txt");
V_fpath_80 = fullfile(pwd,"Input_data","Potential_data","poly_V_80.txt");
V_fpath_320 = fullfile(pwd,"Input_data","Potential_data","poly_V_320.txt");
V_fpath_1280 = fullfile(pwd,"Input_data","Potential_data","poly_V_1280.txt");

V20 = readmatrix(V_fpath_20);
V80 = readmatrix(V_fpath_80);
V320 = readmatrix(V_fpath_320);
V1280 = readmatrix(V_fpath_1280);
rq = V20(:,1:3);

x_surf = rq(:,1);
y_surf = rq(:,2);
% z_surf = obj.V;

X_surf = reshape(x_surf,[sqrt(length(x_surf)),sqrt(length(x_surf))]);
Y_surf = reshape(y_surf,[sqrt(length(x_surf)),sqrt(length(x_surf))]);
% Z_surf = reshape(z_surf,[sqrt(length(x_surf)),sqrt(length(x_surf))]);

%% Calculating true potential of a unit sphere
a = 1; % radius
M = 4/3 * pi * a^3; % mass of a sphere
G = 6.6743e-11; % gravitational constant
for i = 1:length(rq(:,1))
    r = norm(rq(i,:));
    if r > 1
        V(i) = -G*M/r;
    else
        V(i) = -G*M* (3*a^2 - r^2)/(2*a^3);
    end
end
V_true = reshape(V,[sqrt(length(x_surf)),sqrt(length(x_surf))]);
V20 = reshape(V20(:,4),[sqrt(length(x_surf)),sqrt(length(x_surf))]);
V80 = reshape(V80(:,4),[sqrt(length(x_surf)),sqrt(length(x_surf))]);
V320 = reshape(V320(:,4),[sqrt(length(x_surf)),sqrt(length(x_surf))]);
V1280 = reshape(V1280(:,4),[sqrt(length(x_surf)),sqrt(length(x_surf))]);

z_scale = 1/10;
v_scale = 10^9;

[x_s,y_s,z_s] = sphere(20);
z_s = z_s * z_scale;

f1 = figure();
surf(X_surf,Y_surf,V_true*v_scale,'FaceColor','#1d4877');
hold on;
surf(X_surf,Y_surf,V20*v_scale,'FaceAlpha',1,'FaceColor','#ee3e32');
surf(X_surf,Y_surf,V80*v_scale,'FaceAlpha',1,'FaceColor','#f68838');
surf(X_surf,Y_surf,V320*v_scale,'FaceAlpha',1,'FaceColor','#fbb021');
surf(X_surf,Y_surf,V1280*v_scale,'FaceAlpha',1,'FaceColor','#1b8a5a');
surf(x_s,y_s,z_s,'FaceColor',"#7E2F8E");
daspect([1 1 z_scale]);
f1.Position = [100 100 700 700];
xlim([0,3]);
ylim([-3,3]);
xlabel('x [m]','Interpreter','latex');
ylabel('y [m]','Interpreter','latex');
zlabel('V [nJ/kg]','Interpreter','latex');
legend('true','20','80','320','1280','Location','southoutside','Orientation','horizontal');
view(-65,20)

