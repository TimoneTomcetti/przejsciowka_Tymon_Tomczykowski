function [rq, rqn, i] = gen_points(a,b,n,mode,r)
    if strcmp(mode,"out")
        rq = (b-a).*rand(n,3) + a;
        rqn = vecnorm(rq,2,2);
        while any(rqn < r)
            n_temp = length(rqn(rqn < r));
            rq(rqn < r,:) = (b-a).*rand(n_temp,3) + a;
            rqn = vecnorm(rq,2,2);
        end
        i = n;
    elseif strcmp(mode,"in")
        rq = (b-a).*rand(n,3) + a;
        rqn = vecnorm(rq,2,2);
        while any(rqn > r)
            n_temp = length(rqn(rqn > r));
            rq(rqn > r,:) = (b-a).*rand(n_temp,3) + a;
            rqn = vecnorm(rq,2,2);
        end
        i = 0;
    else
        rq = (b-a).*rand(n,3) + a;
        rqn = vecnorm(rq,2,2);
        i = length(rqn(rqn > r));
    end
end