function[integrale] = mcIntegration(n)
    exec('generateWeibull.sci', -1);
    deff('[y] = g(x)', 'y = x .^ 2 / 4');

    a = 4;
    b = 1;

    x = generateWeibull(a, b, n);
    gx = g(x);
    integrale = sum(gx) / n;

    k = [1:n];
    ints = cumsum(gx') ./ k;
    plot(k, ints);
endfunction
