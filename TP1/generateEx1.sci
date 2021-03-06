function[] = generateEx1(n)

    if n - floor(n) ~= 0 | n < 0
        error('wrong n');
    end

    u = rand(n, 1, 'uniform');
    x = log(u);

    t = linspace(-7, 0, n);
    f = zeros(n, 1);

    for i = 1:n
        f(i) = size(find(x <= t(i)), 2) / n;
    end

    plot(t, f, 'r');
    plot(t, exp(t), 'b');

endfunction
