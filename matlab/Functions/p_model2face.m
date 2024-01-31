function p_c = p_model2face(p,n_f,p_a,p_b,rq)
k = n_f;
i = (p_b - p_a)/norm(p_b - p_a);
j = cross(k,i);
F = [i', j', k'];
M = [[1,0,0]',[0,1,0]',[0,0,1]'];

p_r =  - rq;
p_c = (F \ M * p_r')';
end