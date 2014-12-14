exec('generateMarkovSeq.sci', -1);

// read csv file
data = csvRead('processedDataset.csv');

// remove header line
data(1, :) = [];
// remove strings columns
data(:, 1) = data(:, 9);
data(:, [7, 9]) = [];
// matrix is now day of year, temperature, humidity, pressure, precipitation,
// cloud level, weather
// weather is coded as follows:
// 1 = Cloudy
// 2 = Rain
// 3 = Snow
// 4 = Sunny
weathers = [1; 2; 3; 4];
nSeq = 15;


// multinomial model
n = size(data, 1);
// computes the frequency of each type of weather
pCloudy = size(data(data(:, 7) == 1, :), 1) / n;
pRain = size(data(data(:, 7) == 2, :), 1) / n;
pSnow = size(data(data(:, 7) == 3, :), 1) / n;
pSunny = size(data(data(:, 7) == 4, :), 1) / n;
disp(pCloudy, 'cloudy: ');
disp(pRain, 'rain: ');
disp(pSnow, 'snow: ');
disp(pSunny, 'sunny: ');
initialProbs = [pCloudy; pRain; pSnow; pSunny];

// generates a 15 long sequence of weather types with the multinomial model
disp(samplef(nSeq, weathers, initialProbs), 'multinomial sequence: ');


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

p = [cloudyToCloudy, cloudyToRain, cloudyToSnow, cloudyToSunny; ...
    rainToCloudy, rainToRain, rainToSnow, rainToSunny; ...
    snowToCloudy, snowToRain, snowToSnow, snowToSunny; ...
    sunnyToCloudy, sunnyToRain, sunnyToSnow, sunnyToSunny];
disp(p, 'transition matrix: ');

// generates a markov sequence
disp(generateMarkovSeq(p, initialProbs, nSeq), 'markov sequence: ');
