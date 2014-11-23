function[] = traceWeibull()
    exec('generateWeibull.sci', -1);

    n = 1000;
    alpha = 4;
    beta = 1;

    weibull = generateWeibull(alpha, beta, n);
    
    x = linspace(min(weibull), max(weibull), n);
    f1Weibull = zeros(1:n);
    for i = 1:n
        f1Weibull(i) = size(find(weibull <= x(i)), 2) / n;
    end
    f2Weibull = 1 - exp(-(x ./ beta) .^ alpha);

    plot(x, f1Weibull, 'r--');
    plot(x, f2Weibull, 'k');
endfunction
