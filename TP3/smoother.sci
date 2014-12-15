function[beta] = smoother(sequence, transitionMatrix, emissionMatrix, filter)
    // Author: Benjamin Fradet
    // Credits: Aurelien Garivier
    // http://www.math.univ-toulouse.fr/~agarivie/Telecom/code/index.php

    // beta = smoothing factors
    // beta(x, t) = P(Y(t + 1:n) = y(t + 1:n) | X(t) = x) /
    //      P(Y(t + 1:n) = y(t + 1:n) | Y(1:t) = y(1:t))
    n = length(sequence);
    beta = ones(size(transitionMatrix, 1), n);
    for t = (n-1):-1:1
        beta(:, t) = transitionMatrix * ...
            (emissionMatrix(:, sequence(t + 1)) .* beta(:, t + 1)) / ...
            filter(t + 1);
    end
endfunction
