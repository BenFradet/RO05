function[alph] = forward(sequence, initialProbs, ...
                            transitionMatrix, emissionMatrix)
    // Author: Benjamin Fradet

    n = length(sequence);
    numberStates = size(transitionMatrix, 1);
    alph = zeros(n, numberStates);
    // we start from state 1
    alph(1, :) = initialProbs';
    for i = 2:n
        for j = 1:numberStates
            alph(i, j) = emissionMatrix(j, sequence(i)) * ...
                sum(alph(i - 1, :) * transitionMatrix(:, j));
        end
    end
endfunction
