function[bet] = backward(sequence, transitionMatrix, emissionMatrix)
    // Author: Benjamin Fradet

    n = length(sequence);
    numberStates = size(transitionMatrix, 1);
    bet = zeros(n, numberStates);
    // we start from state 1
    bet(n, :) = [1, 1];
    for i = n-1:-1:1
        for j = 1:numberStates
            bet(i, j) = sum(emissionMatrix(j, sequence(i + 1)) * ...
                            bet(i + 1, :) * transitionMatrix(:, j));
        end
    end
endfunction
