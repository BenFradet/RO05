function[x] = generateGaussian(mu, sigma, n)

    if n - floor(n) ~= 0 | n < 0
        error('wrong n');
    end

    u1 = rand(n, 1, 'uniform');
    u2 = rand(n, 1, 'uniform');
    r = sqrt(-2 * log(u1));
    sig = 2 * %pi * u2;
    x = r .* sin(sig);
    x = x * sigma;
    x = x + mu;

endfunction
