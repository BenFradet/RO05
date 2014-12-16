function[posteriors] = forward(sequence, transitionMatrix, emissionMatrix)
    // Author: Benjamin Fradet

    n = length(sequence);
    numberStates = size(transitionMatrix, 1);
    posteriors = zeros(n, numberStates);
    // we start from state 1
    posteriors(1, 1) = 1;
    for i = 2:n
        for j = 1:numberStates
            prob = emissionMatrix(j, sequence(i))
            posteriors(i, j) = prob * ...
                sum(posteriors(i - 1, :) * transitionMatrix(:, j));
        end
    end
endfunction
