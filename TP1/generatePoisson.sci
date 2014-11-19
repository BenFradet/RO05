function[x] = generatePoisson(lambda, n)

if n - floor(n) ~= 0 | n < 0
    error('wrong n');
end

x = zeros(n, 1);

for i = 1:n
    k = 1;
    produ = 1;
    produ = produ * rand(1, 1, 'uniform');
    while produ >= exp(-lambda)
        produ = produ * rand(1, 1, 'uniform');
        k = k + 1;
    end
    x(i) = k;
end

endfunction
