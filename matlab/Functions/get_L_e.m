function L_e = get_L_e(r,p_a,p_b)
e = norm(p_a-p_b);
a = norm(r-p_a);
b = norm(r-p_b);
L_e = log((a+b+e)/(a+b-e));
end