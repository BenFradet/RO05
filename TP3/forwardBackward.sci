function[posteriors] = forwardBackward(sequence, initialProbs, ...
                            transitionMatrix, emissionMatrix)
    // Author: Benjamin Fradet
    exec('forward.sci', -1);
    exec('backward.sci', -1);

    alph = forward(sequence, initialProbs, transitionMatrix, emissionMatrix);
    bet = backward(sequence, transitionMatrix, emissionMatrix);
    alphaBeta = alph .* bet;
    posteriors = alphaBeta ./ repmat(sum(alphaBeta, 1), size(alphaBeta, 1), 1);
endfunction
