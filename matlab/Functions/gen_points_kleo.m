function rq = gen_points_kleo(a,b,n,model)
    rq = (b-a).*rand(n,3) + a;
    in = inpolyhedron(model.ConnectivityList,model.Points,rq);

    while any(in == 1)
    n_temp = length(in(in == 1));
    rq(in == 1,:) = (b-a).*rand(n_temp,3) + a;
    in = inpolyhedron(model.ConnectivityList,model.Points,rq);
    end
end