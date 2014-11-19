function[x] = generateWeibull(alpha, beta, n)

    if n - floor(n) ~= 0 | n < 0
        error('wrong n');
    end

    if alpha < 0 | beta < 0
        error('wrong alpha / beta');
    end

    u = rand(n, 1, 'uniform');
    x = ((-log(1 - u)) .^ (1 / alpha)) * beta;

endfunction
