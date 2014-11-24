function[] = traceCauchy()
    exec('generateCauchy.sci', -1);

    n = 1000;
    a = 1;
    x0 = 0;

    cauchy = generateCauchy(x0, a, n);

    k = [1:n];
    means = cumsum(cauchy') ./ k;

    x = linspace(-10, 10, n);
    f1Cauchy = zeros(1:n);
    for i = 1:n
        f1Cauchy(i) = size(find(cauchy <= x(i)), 2) / n;
    end
    f2Cauchy = atan((x - x0) / a) / %pi + 1 / 2;

    f = figure(0);
    f.background = -2;
    plot(x, f1Cauchy, 'r--');
    plot(x, f2Cauchy, 'k');

    f = figure(1);
    f.background = -2;
    plot(k, means);
    plot([1 n], [0 0], 'r');
endfunction
