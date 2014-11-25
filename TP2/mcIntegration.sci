function[int] = mcIntegration(n)
    exec('generateWeibull.sci', -1);
    deff('[y] = g(x)', 'y = x .^ 2 / 4');

    alpha = 4;
    beta = 1;

    x = generateWeibull(alpha, beta, n);
    gx = g(x);
    int = sum(gx) / n;
endfunction
