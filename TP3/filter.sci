function[phi, c] = filter(sequence, initialProbs, ...
                            transitionMatrix, emissionMatrix)
    // Author: Benjamin Fradet
    // Credits: Aurelien Garivier
    // http://www.math.univ-toulouse.fr/~agarivie/Telecom/code/index.php

    // phi = P(X(t) = x | Y(1:t) = y (1:t))
    // c(t) = P(Y(t) = y(t) | Y(1:t - 1) = y(1:t - 1))
    n = length(sequence);
    phi = zeros(size(transitionMatrix, 1), n);
    c = zeros(1, n);

    Z = initialProbs .* emissionMatrix(:, sequence(1));
    c(1) = sum(Z);
    phi(:, 1) = Z / c(1);

    for t = 2:n
        Z = (phi(:, t - 1)' * transitionMatrix)' .* ...
            emissionMatrix(:, sequence(t));
        c(t) = sum(Z);
        phi(:, t) = Z / c(t);
    end
endfunction
