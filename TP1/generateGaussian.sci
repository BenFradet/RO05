function[x] = generateGaussian(mu, sigma, n)

    if n - floor(n) ~= 0 | n < 0
        error('wrong n');
    end

    u = rand(n, 1, 'uniform');
    x = mu + sqrt(2) * sigma * erfinv(2 * u - 1);

endfunction
