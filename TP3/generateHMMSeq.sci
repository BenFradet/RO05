// Author: Benjamin Fradet
// To execute with Scilab 5.5.1
function[weatherSeq, stateSeq] = generateHMMSeq(transitionMatrix, ...
                                                emissionMatrix, ...
                                                initialProbs, ...
                                                seqLength)
    weatherSeq = zeros(1:seqLength);
    stateSeq = zeros(1:seqLength);
    // Cloudy = 1
    // Rain = 2
    // Snow = 3
    // Sunny = 4
    weathers = [1; 2; 3; 4];
    // Low pressure = 1
    // High pressure = 2
    pressures = [1; 2];

    // chooses a first state
    stateSeq(1) = samplef(1, pressures, initialProbs);
    // probabilities of each weather type given that we are in stateSeq(1)
    probabilities = emissionMatrix(stateSeq(1), :);
    // chooses a weather type
    weatherSeq(1) = samplef(1, weathers, probabilities);

    for i = 2:seqLength
        prevState = stateSeq(i - 1);
        // gets the probabilities of changing states
        stateProbabilities = transitionMatrix(prevState, :);
        // chooses a new state
        stateSeq(i) = samplef(1, pressures, stateProbabilities);
        // probabilities of each weather type given that we are in stateSeq(i)
        probabilities = emissionMatrix(stateSeq(i), :);
        // chooses a weather type
        weatherSeq(i) = samplef(1, weathers, probabilities);
    end

endfunction
