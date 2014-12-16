data <- read.csv('dataset.csv', stringsAsFactors = F)

# throw away the data we don't need
data <- data[c(1, 3, 9, 12, 20, 21, 22)]

# conversion from inches of mercury to hPa
data$Mean.Sea.Level.PressureIn <-
    round(data$Mean.Sea.Level.PressureIn * 33.86, 2)
# conversion from inches to mm
data$PrecipitationIn <- data$PrecipitationIn * 25.4
# conversion from Farenheit to Celsius
data$Mean.TemperatureF <- round((data$Mean.TemperatureF - 32) * 5 / 9)

# renaming of the columns
colnames(data) <- c('date',
                    'temperature',
                    'humidity',
                    'pressure',
                    'precipitation',
                    'cloudLevel',
                    'weather')

levels(data$weather) <- c(levels(data$weather), 'Cloudy', 'Sunny')
# replace nas in cloudLevel by its mean
data$cloudLevel[is.na(data$cloudLevel)] <- mean(data$cloudLevel, na.rm = T)
data$weather[data$weather == '' & data$cloudLevel >= 6] <- 'Cloudy'
data$weather[data$weather == ''] <- 'Sunny'
data$weather[data$weather == 'Fog'] <- 'Cloudy'
data$weather[data$weather == 'Fog-Rain-Snow'] <- 'Snow'
data$weather[data$weather == 'Fog-Rain-Thunderstorm'] <- 'Rain'
data$weather[data$weather == 'Rain-Snow'] <- 'Snow'
data$weather[data$weather == 'Thunderstorm'] <- 'Rain'
data$weather[data$weather == 'Fog-Rain'] <- 'Rain'
data$weather[data$weather == 'Fog-Snow'] <- 'Snow'
data$weather[data$weather == 'Rain-Thunderstorm'] <- 'Rain'
noRainSubset <- data[data$weather == 'Rain' & data$precipitation == 0, ]
noRainSubset$weather <- ifelse(noRainSubset$cloudLevel >= 6, 'Cloudy', 'Sunny')
data$weather[data$weather == 'Rain' & data$precipitation == 0] <-
    noRainSubset$weather
data$weather <- factor(data$weather)
normalPressure <- 1013.25
data$state <- ifelse(data$pressure <= normalPressure, 1, 2)
data$state <- factor(data$state)
# 1 = Cloudy
# 2 = Rain
# 3 = Snow
# 4 = Sunny
data$weather2 <- unclass(data$weather)
# 1 = Low pressure
# 2 = High pressure
data$state2 <- unclass(data$state)
data$dayOfYear <- c(1:365)

write.csv(data, file = 'processedDataset.csv', quote = F, row.names = F)
