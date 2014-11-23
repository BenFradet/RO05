function[x] = generateCauchy(x0, a, n)

    if n - floor(n) ~= 0 | n < 0
        error('wrong n');
    end

    if abs(a) < %eps | a < 0
        error('wrong a');
    end

    u = rand(n, 1, 'uniform');
    x = a * tan((u - 1 / 2) * %pi) + x0;

endfunction
