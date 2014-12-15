// Author: Benjamin Fradet
function[viterbi] = makeViterbiMatrix(sequence, ...
                                        transitionMatrix, ...
                                        emissionMatrix)
    numberStates = size(transitionMatrix, 1);
    viterbi = zeros(length(sequence), numberStates);
    viterbi(1, 1) = 1;
    for i = 2:length(sequence)
        for j = 1:numberStates
            // probability that, given that we are in state j, we get the ith
            // weather
            prob = emissionMatrix(j, sequence(i));
            viterbi(i, j) = prob * ...
                max(viterbi(i - 1, :) * transitionMatrix(:, j));
        end
    end
endfunction
