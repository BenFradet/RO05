function[] = draw(n, lambda, p, bins, fig)
    poisson = grand(n, 1, 'poi', lambda);
    binom = grand(n, 1, 'bin', n, p);

    x = ones(1:bins)';
    mini = min([poisson; binom]);
    range = max([poisson; binom]) - mini;
    offset = range / bins;
    for i = 1:bins
        x(i) = mini + i * offset;
    end

    figure(fig);
    histplot(x, poisson, style = 5);
    histplot(x, binom);
endfunction

function[] = trace2()

    n = 400;
    draw(n, 1.48, 0.0037, 10, 0);
    draw(n, 15.6, 0.039, 20, 1);

endfunction
