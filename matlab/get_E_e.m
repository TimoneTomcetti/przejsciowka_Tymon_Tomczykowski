function E_e = get_E_e(model,edge,plot)
p_a = model.Points(edge(1),:);
p_b = model.Points(edge(2),:);

faces_id = cell2mat(edgeAttachments(model,edge(1),edge(2)))';
n_f = faceNormal(model,faces_id);

n_ab = (p_b - p_a)/norm(p_b - p_a);

n_e(1,:) = cross(n_ab*(-1),n_f(1,:));
n_e(1,:) = n_e(1,:)/norm(n_e(1,:));
n_e(2,:) = cross(n_ab,n_f(2,:));
n_e(2,:) = n_e(2,:)/norm(n_e(2,:));

face_points_id(1,:) = model.ConnectivityList(faces_id(1),:);

color_i = 1;
p_c = model.Points(face_points_id(1,:),:);
for i = 3:-1:1
    if p_c(i,:) == p_a
        p_c(i,:) = [];
    elseif p_c(i,:) == p_b
        p_c(i,:) = [];
    end
end
v_ac = p_c - p_a;
v_aq = dot(v_ac,n_ab)*n_ab;
p_q = p_a + v_aq;
v_qc = p_c - p_q;
if dot(v_qc,n_e(1,:)) > 0
    n_e = n_e * (-1);
    color_i = 3;
end

E_e = n_f(1,:)' * n_e(1,:) + n_f(2,:)' * n_e(2,:);

% color = ['r','b','y','g'];
% if plot == 1
% p_test = (p_a + p_b)/2;
% scale = 1/10;
% hold on;
% quiver3(p_test(1,1),p_test(1,2),p_test(1,3), n_f(1,1)*scale,n_f(1,2)*scale,n_f(1,3)*scale,0.5,'color',color(color_i));
% quiver3(p_test(1,1),p_test(1,2),p_test(1,3), n_f(2,1)*scale,n_f(2,2)*scale,n_f(2,3)*scale,0.5,'color',color(color_i+1));
% quiver3(p_test(1,1),p_test(1,2),p_test(1,3), n_e(1,1)*scale,n_e(1,2)*scale,n_e(1,3)*scale,0.5,'color',color(color_i));
% quiver3(p_test(1,1),p_test(1,2),p_test(1,3), n_e(2,1)*scale,n_e(2,2)*scale,n_e(2,3)*scale,0.5,'color',color(color_i+1));
% axis equal;
% end
end