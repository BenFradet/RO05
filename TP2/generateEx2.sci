function[x] = generateEx2(n)
    
    if n - floor(n) ~= 0 | n < 0
        error('wrong n');
    end

    u = rand(n, 1, 'uniform');
    x = sin((u - 1 / 2) * %pi);

endfunction
