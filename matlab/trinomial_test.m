close all; clear;

tri1 = make_trinomial(1);
tri2 = make_trinomial(2);

tri3 = tri_mult(tri1, tri2);

integration = integrate_simplex(tri3,2);

function tri = make_trinomial(n)
    t = (n+2)*(n+1)*0.5;
    tri = zeros(1,t);
    for i = n:-1:0
        for k = 0:(n-i)
            j = n-i-k;
            index = (j+k)*(j+k+1)/2 + k + 1;
            coef = factorial(n)/(factorial(i)*factorial(j)*factorial(k));
            tri(index) = coef;
        end
    end
end

function tri_result = tri_mult(tri1, tri2)
    n1 = (-3+sqrt(9-(8*(1-length(tri1)))))/2;
    n2 = (-3+sqrt(9-(8*(1-length(tri2)))))/2;
    n = n1 + n2;
    t_result = (n+2)*(n+1)*0.5;
    tri_result = zeros(1,t_result);
    for i = n1:-1:0
        for k = 0:(n1-i)
            j = n1-i-k;
            for r = n2:-1:0
                for s = 0:(n2-r)
                    t = n2-r-s;
                    index = (j+s+k+t)*(j+s+k+t+1)/2 + k + t + 1;
                    index1 = (j+k)*(j+k+1)/2 + k + 1;
                    index2 = (s+t)*(s+t+1)/2 + t + 1;
                    tri_result(index) = tri_result(index) + tri1(index1) * tri2(index2);
                end
            end
        end
    end
end

function int_result = integrate_simplex(tri,det_J)
    n = (-3+sqrt(9-(8*(1-length(tri)))))/2;
    for i = n:-1:0
        for k = 0:(n-i)
            j = n-i-k;
            index = (j+k)*(j+k+1)/2 + k + 1;
            mix_factor = factorial(i)*factorial(j)*factorial(k)/factorial(n+3);
            tri(index) = tri(index)*mix_factor;
        end
    end
    int_result = det_J * sum(tri);
end