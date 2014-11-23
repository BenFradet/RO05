function[] = trace()

    exec('generatePoisson.sci', -1);
    exec('generateOneThird.sci', -1);
    exec('generateGaussian.sci', -1);
    exec('generateWeibull.sci', -1);

    n = 500;

    lambda = 3;
    mu = 2;
    sigma = 4;
    alpha = 3;
    beta = 3;

    poisson = generatePoisson(lambda, n);
    sPoisson = grand(n, 1, 'poi', lambda);
    oneThird = generateOneThird(n);
    gaussian = generateGaussian(mu, sigma, n);
    sGaussian = grand(n, 1, 'nor', mu, sigma);
    weibull = generateWeibull(alpha, beta, n);

    // poisson plot
    xPoisson = linspace(min(poisson), max(poisson), n);
    f1Poisson = zeros(1:n);
    f2Poisson = zeros(1:n);
    for i = 1:n
        f1Poisson(i) = size(find(poisson <= xPoisson(i)), 2) / n;
        f2Poisson(i) = size(find(sPoisson <= xPoisson(i)), 2) / n;
    end
    // density of the poisson distrib
    deff('[p] = f(x, lambda)', ...
        'p = exp(-lambda) .* lambda .^ x ./ gamma(x + 1)')
    x2Poisson = [1:floor(max(xPoisson))]
    d3Poisson = f(x2Poisson, lambda);
    f3Poisson = []
    for i = 1:floor(max(xPoisson))
        f3Poisson = [f3Poisson sum(d3Poisson(1:i))];
    end

    f = figure(0);
    f.background = -2;
    gc = gca();
    gc.data_bounds = [1, 0; 11, 1];
    plot(xPoisson, f1Poisson, 'r');
    plot(xPoisson, f2Poisson, 'b');
    plot(x2Poisson, f3Poisson, 'k');

    // third plot
    xThird = linspace(min(oneThird) - 1, max(oneThird) + 1, n);
    f1Third = zeros(1:n);
    for i = 1:n
        f1Third(i) = size(find(oneThird <= xThird(i)), 2) / n;
    end
    f = figure(1);
    f.background = -2;
    gc = gca();
    gc.data_bounds = [min(oneThird) - 1, min(f1Third) - 0.2; ...
        max(oneThird) + 1, max(f1Third) + 0.2];
    x = [-2, -1, -1, 0, 0, 1, 1, 2];
    y = [0, 0, 1 / 3, 1 / 3, 2 / 3, 2 / 3, 1, 1];
    plot(xThird, f1Third, 'r--');
    xpoly(x, y);

    // gaussian plot
    xGaussian = linspace(min(gaussian), max(gaussian), n);
    f1Gaussian = zeros(1:n);
    f2Gaussian = zeros(1:n);
    for i = 1:n
        f1Gaussian(i) = size(find(gaussian <= xGaussian(i)), 2) / n;
        f2Gaussian(i) = size(find(sGaussian <= xGaussian(i)), 2) / n;
    end
    f3Gaussian = cdfnor("PQ", xGaussian, mu * ones(xGaussian), ...
        sigma * ones(xGaussian));
    f = figure(2);
    f.background = -2;
    plot(xGaussian, f1Gaussian, 'r--');
    plot(xGaussian, f2Gaussian, 'b:');
    plot(xGaussian, f3Gaussian, 'k');

    // weibull plot
    xWeibull = linspace(min(weibull), max(weibull), n);
    f1Weibull = zeros(1:n);
    for i = 1:n
        f1Weibull(i) = size(find(weibull <= xWeibull(i)), 2) / n;
    end
    f2Weibull = 1 - exp(-(xWeibull ./ beta) .^ alpha);
    f = figure(3);
    f.background = -2;
    plot(xWeibull, f1Weibull, 'r--');
    plot(xWeibull, f2Weibull, 'k');

endfunction
