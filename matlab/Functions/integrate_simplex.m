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