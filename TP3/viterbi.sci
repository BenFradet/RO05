// Author: Benjamin Fradet
function[mostProbableStatePath, positionsStatesMatrix] = viterbi(...
        sequence, ...
        transitionMatrix, ...
        emissionMatrix)
    exec('makeViterbiMatrix.sci', -1);
    viterbi = makeViterbiMatrix(sequence, transitionMatrix, emissionMatrix);
    // finds the state with the highest probability
    [m mostProbableStatePath] = max(viterbi, 'c')';

    prevMostProbableState = mostProbableStatePath(1);
    startPos = 1;
    idx = 1;
    for i = 2:length(sequence)
        mostProbableState = mostProbableStatePath(i);
        if mostProbableState ~= prevMostProbableState
            positionsStatesMatrix(idx, :) = ...
                [prevMostProbableState, startPos, i - 1];
            startPos = i;
            idx = idx + 1;
        end
        prevMostProbableState = mostProbableState;
    end
    positionsStatesMatrix(idx, :) = [prevMostProbableState, startPos, i];
endfunction
