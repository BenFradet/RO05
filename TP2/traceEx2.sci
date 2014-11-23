function[] = traceEx2()
    exec('generateEx2.sci', -1);

    n = 1000;
    generated = generateEx2(n);

    x = linspace(min(generated), max(generated), n);
    f1 = zeros(1:n);
    for i = 1:n
        f1(i) = size(find(generated <= x(i)), 2) / n;
    end
    f2 = asin(x) / %pi + 1 / 2;

    plot(x, f1, 'r--');
    plot(x, f2, 'k');
endfunction
