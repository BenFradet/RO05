// Author: Benjamin Fradet
// To execute with Scilab 5.5.1

exec('generateMarkovSeq.sci', -1);
exec('generateHMMSeq.sci', -1);
exec('viterbi.sci', -1);
exec('baumWelch.sci', -1);
exec('forward.sci', -1);

// preprocessing

// read csv file
data = csvRead('processedDataset.csv');

n = size(data, 1);
// remove header line
data(1, :) = [];
// remove strings columns
data(:, 1) = data(:, 11);
data(:, [7, 8, 11]) = [];

// matrix is now day of year, temperature, humidity, pressure, precipitation,
// cloud level, weather, pressure type
// weather is coded as follows:
// 1 = Cloudy
// 2 = Rain
// 3 = Snow
// 4 = Sunny
weathers = [1; 2; 3; 4];
// pressure type is coded as follows:
// 1 = Low pressure
// 2 = High pressure
pressures = [1; 2];
nSeq = 15;


// computes the intial probabilities
// computes the probabilities of each type of weather
pCloudy = size(data(data(:, 7) == 1, :), 1) / n;
pRain = size(data(data(:, 7) == 2, :), 1) / n;
pSnow = size(data(data(:, 7) == 3, :), 1) / n;
pSunny = size(data(data(:, 7) == 4, :), 1) / n;
disp(pCloudy, 'cloudy: ');
disp(pRain, 'rain: ');
disp(pSnow, 'snow: ');
disp(pSunny, 'sunny: ');
initialProbsWeather = [pCloudy; pRain; pSnow; pSunny];
// computes the probabilites of each state
normalPressure = 1013.25;
pLow = size(data(data(:, 4) <= normalPressure, :), 1) / n;
pHigh = 1 - pLow;
initialProbsPressure = [pLow; pHigh];


// multinomial model

// generates a 15 long sequence of weather types with the multinomial model
disp(samplef(nSeq, weathers, initialProbsWeather), 'multinomial sequence: ');


// Markov model

// computes the transition matrix p
// Cloudy = 1
cloudyIndices = find(data(:, 7) == 1);
nCloudy = length(cloudyIndices);
weathersAfterCloudy = data(cloudyIndices + 1, 7);
cloudyToCloudy = length(weathersAfterCloudy(weathersAfterCloudy == 1)) / nCloudy;
cloudyToRain = length(weathersAfterCloudy(weathersAfterCloudy == 2)) / nCloudy;
cloudyToSnow = length(weathersAfterCloudy(weathersAfterCloudy == 3)) / nCloudy;
cloudyToSunny = length(weathersAfterCloudy(weathersAfterCloudy == 4)) / nCloudy;

// Rain = 2
rainIndices = find(data(:, 7) == 2);
rainIndices = rainIndices(1:length(rainIndices) - 1);
nRain = length(rainIndices);
weathersAfterRain = data(rainIndices + 1, 7);
rainToCloudy = length(weathersAfterRain(weathersAfterRain == 1)) / nRain;
rainToRain = length(weathersAfterRain(weathersAfterRain == 2)) / nRain;
rainToSnow = length(weathersAfterRain(weathersAfterRain == 3)) / nRain;
rainToSunny = length(weathersAfterRain(weathersAfterRain == 4)) / nRain;

// Snow = 3
snowIndices = find(data(:, 7) == 3);
nSnow = length(snowIndices);
weathersAfterSnow = data(snowIndices + 1, 7);
snowToCloudy = length(weathersAfterSnow(weathersAfterSnow == 1)) / nSnow;
snowToRain = length(weathersAfterSnow(weathersAfterSnow == 2)) / nSnow;
snowToSnow = length(weathersAfterSnow(weathersAfterSnow == 3)) / nSnow;
snowToSunny = length(weathersAfterSnow(weathersAfterSnow == 4)) / nSnow;

sunnyIndices = find(data(:, 7) == 4);
nSunny = length(sunnyIndices);
weathersAfterSunny = data(sunnyIndices + 1, 7);
sunnyToCloudy = length(weathersAfterSunny(weathersAfterSunny == 1)) / nSunny;
sunnyToRain = length(weathersAfterSunny(weathersAfterSunny == 2)) / nSunny;
sunnyToSnow = length(weathersAfterSunny(weathersAfterSunny == 3)) / nSunny;
sunnyToSunny = length(weathersAfterSunny(weathersAfterSunny == 4)) / nSunny;

pMarkov = [cloudyToCloudy, cloudyToRain, cloudyToSnow, cloudyToSunny; ...
            rainToCloudy, rainToRain, rainToSnow, rainToSunny; ...
            snowToCloudy, snowToRain, snowToSnow, snowToSunny; ...
            sunnyToCloudy, sunnyToRain, sunnyToSnow, sunnyToSunny];
disp(pMarkov, 'transition matrix: ');

// generates a markov sequence
disp(...
    generateMarkovSeq(pMarkov, initialProbsWeather, nSeq), 'markov sequence: ');


// Hidden Markov model

// Low pressure = 1
lowIndices = find(data(:, 4) <= normalPressure);
nLow = length(lowIndices);
weathersLow = data(lowIndices, 7);
pLowCloudy = length(weathersLow(weathersLow == 1)) / nLow;
pLowRain = length(weathersLow(weathersLow == 2)) / nLow;
pLowSnow = length(weathersLow(weathersLow == 3)) / nLow;
pLowSunny = length(weathersLow(weathersLow == 4)) / nLow;

// High pressure = 2
highIndices = find(data(:, 4) > normalPressure);
nHigh = length(highIndices);
weathersHigh = data(highIndices, 7);
pHighCloudy = length(weathersHigh(weathersHigh == 1)) / nHigh;
pHighRain = length(weathersHigh(weathersHigh == 2)) / nHigh;
pHighSnow = length(weathersHigh(weathersHigh == 3)) / nHigh;
pHighSunny = length(weathersHigh(weathersHigh == 4)) / nHigh;

// computes the probs to change states high/low pressures
lowIndices = lowIndices(1:length(lowIndices) - 1);
pressuresAfterLow = data(lowIndices + 1, 4);
lowToLow = length(pressuresAfterLow(pressuresAfterLow <= normalPressure)) / ...
    nLow;
lowToHigh = length(pressuresAfterLow(pressuresAfterLow > normalPressure)) / ...
    nLow;

pressuresAfterHigh = data(highIndices + 1, 4);
highToLow = length(pressuresAfterHigh(pressuresAfterHigh <= normalPressure)) ...
    / nHigh;
highToHigh = ...
    length(pressuresAfterHigh(pressuresAfterHigh > normalPressure)) / nHigh;

// transition matrix
transitionHMM = [lowToLow, lowToHigh; ...
                highToLow, highToHigh];
// emission matrix
emissionHMM = [pLowCloudy, pLowRain, pLowSnow, pLowSunny; ...
                pHighCloudy, pHighRain, pHighSnow, pHighSunny];

// generates a hidden markov sequence
[weatherSeq stateSeq] = ...
    generateHMMSeq(transitionHMM, emissionHMM, initialProbsPressure, nSeq);
// model exploitation

// posterior state probabilities of an emission sequence
posteriors = forward(data(1:20, 7), transitionHMM, emissionHMM);
disp(posteriors, 'posterior state probabilities: ');

// decoding of sequence of weathers:
// given the weathers for a whole year, tries to find the sequence of states
// associated (high or low pressure)
[path stateMatrix] = viterbi(data(:, 7), transitionHMM, emissionHMM);
// actual state vector
actualState = data(:, 8);
probaError = sum(actualState == path') / n;
disp(probaError, ...
        'proba of error between the most likely path and the real path: ');
disp(path(1:20), 'most probable state path: ');
disp(stateMatrix(1:5, :), 'positions states matrix: ');

// to compute: proba of error between the most probable path and real pressures

// learning of the model
disp(initialProbsWeather);
tMatrix = zeros(2, 2);
eMatrix = zeros(2, 4);
nIter = 20;
for i = 1:nIter
    [tmpTMatrix tmpEMatrix] = baumWelch(data(:, 7), ...
        initialProbsPressure, ...
        [initialProbsWeather'; initialProbsWeather'], ...
        10e-8, 1000);
    tMatrix = tMatrix + tmpTMatrix;
    eMatrix = eMatrix + tmpEMatrix;
end
tMatrix = tMatrix / nIter;
eMatrix = eMatrix / nIter;

disp(tMatrix, 'learned transition matrix: ');
disp(transitionHMM, 'empirical transition matrix: ');
disp(eMatrix, 'learned emission matrix: ');
disp(emissionHMM, 'empirical emission matrix: ');
