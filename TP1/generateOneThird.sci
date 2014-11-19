function[x] = generateOneThird(n)

    if n - floor(n) ~= 0 | n < 0
        error('invalid n');
    end

    x = zeros(n, 1);

    for i = 1:n
        u = rand(1, 1, 'uniform');
        if u < 1 / 3
            x(i) = -1;
        elseif u < 2 / 3
            x(i) = 0;
        else
            x(i) = 1;
        end
    end

endfunction
