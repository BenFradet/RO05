// read csv file
data = csvRead('processedDataset.csv');

// remove header line
data(1, :) = [];
// remove strings columns
data(:, 1) = data(:, 9);
data(:, [7, 9]) = [];
// matrix is now day of year, temperature, humidity, pressure, precipitation,
// cloud level, weather
// weather is coded as follows: 1 = Cloudy, 2 = Rain, 3 = Snow, 4 = Sunny


// multinomial model
n = size(data, 1);
// computes the frequency of each type of weather
fCloudy = size(data(data(:, 7) == 1, :), 1);
fRain = size(data(data(:, 7) == 2, :), 1);
fSnow = size(data(data(:, 7) == 3, :), 1);
fSunny = size(data(data(:, 7) == 4, :), 1);
disp('cloudy: ' + fCloudy);
disp('rain: ', fRain);
disp('snow: ', fSnow);
disp('sunny: ', fSunny);

// generates a 15 long sequence of weather types with the multinomial model
disp(sample(15, [1; 2; 3; 4], [fCloudy; fRain; fSnow; fSunny]));
