function[transitionMatrix, emissionMatrix] = baumWelch(...
        sequence, initialProbs, ...
        emissionMatrix, ...
        tol, maxIt)

    // Author: Benjamin Fradet
    // Credits: Aurelien Garivier
    // http://www.math.univ-toulouse.fr/~agarivie/Telecom/code/index.php

    exec('filter.sci', -1);
    exec('smoother.sci', -1);

    n = length(sequence);
    k = length(initialProbs); 
    r = max(sequence);
    sequence = sequence';
    Y = zeros(n, r);
    Y(sub2ind([n, r], 1:n, sequence)) = 1;

    // initialize randomly transition and emission matrices
    transitionMatrix = rand(k, k);
    transitionMatrix = transitionMatrix ./ ...
        (sum(transitionMatrix, 2) * ones(1, k));
    //emissionMatrix = rand(k, r);
    //emissionMatrix = emissionMatrix ./ ...
    //    (sum(emissionMatrix, 2) * ones(1, r));

    it = 0;
    oldTransitionMatrix = transitionMatrix;
    // adds noise to the emission matrix so that it enters the while loop
    oldEmissionMatrix = emissionMatrix + tol;
    while ((norm(oldTransitionMatrix - transitionMatrix, 1) + ...
            norm(oldEmissionMatrix - emissionMatrix, 1)) > tol & it <= maxIt)
        it = it + 1;
        [phi c] = ...
            filter(sequence, initialProbs, transitionMatrix, emissionMatrix);
        beta = smoother(sequence, transitionMatrix, emissionMatrix, c);
        // computes the posterior distribution
        post = phi .* beta;

        // expectation phase
        // number of transitions
        N = transitionMatrix .* (phi(:, 1:$ - 1) * ...
            (beta(:, 2:$) .* emissionMatrix(:, sequence(2:$)) ./ ...
            (ones(k, 1) * c(2:$)))');
        // number of emissions
        M = post * Y;

        // maximization phase
        oldTransitionMatrix = transitionMatrix;
        oldEmissionMatrix = emissionMatrix;
        transitionMatrix = N ./ (sum(N, 2) * ones(1, k));
        emissionMatrix = M ./ (sum(M, 2) * ones(1, r));
    end
endfunction
