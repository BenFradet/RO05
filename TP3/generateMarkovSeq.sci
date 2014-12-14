function[sequence] = generateMarkovSeq(transitionMatrix, ...
                                        initialProbs, ...
                                        seqLength)
    sequence = zeros(1:seqLength);
    // Cloudy = 1
    // Rain = 2
    // Snow = 3
    // Sunny = 4
    weathers = [1; 2; 3; 4];
    sequence(1) = samplef(1, weathers, initialProbs);
    for i = 2:seqLength
        prevWeather = sequence(i - 1);
        probs = transitionMatrix(prevWeather, :);
        sequence(i) = samplef(1, weathers, probs);
    end
endfunction
