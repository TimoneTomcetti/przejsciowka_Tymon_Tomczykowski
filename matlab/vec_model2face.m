function r_t = vec_model2face(r,n_f,p_a,p_b)
k = n_f;
i = (p_b - p_a)/norm(p_b - p_a);
j = cross(k,i);
F = [i', j', k'];
M = [[1,0,0]',[0,1,0]',[0,0,1]'];
r_t = (F \ M * r')';
end