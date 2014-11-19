function[] = trace()

    exec('generatePoisson.sci', -1);
    exec('generateOneThird.sci', -1);
    exec('generateGaussian.sci', -1);
    exec('generateWeibull.sci', -1);

    n = 500;
    lambdaPoisson = 3;
    poisson = generatePoisson(lambdaPoisson, n);
    sPoisson = grand(n, 1, 'poi', lambdaPoisson);
    oneThird = generateOneThird(n);
    gaussian = generateGaussian(2, 4, n);
    weibull = generateWeibull(3, 3, n);

    // poisson plot
    xPoisson = linspace(min(poisson), max(poisson), n);
    f1Poisson = zeros(1:n);
    f2Poisson = zeros(1:n);
    deff('[p] = f(x, lambda)',
        'p = exp(-lambda) .* lambda .^ x ./ gamma(x + 1)')
    f3Poisson = f(xPoisson, lambdaPoisson);
    for i = 1:n
        f1Poisson(i) = size(find(poisson <= xPoisson(i)), 2) / n;
        f2Poisson(i) = size(find(sPoisson <= xPoisson(i)), 2) / n;
    end

    // density of the poisson distrib
    //figure(0);
    plot(xPoisson, f1Poisson, 'r--');
    plot(xPoisson, f2Poisson, 'b');

endfunction
