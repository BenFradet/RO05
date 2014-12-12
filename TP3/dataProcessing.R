data <- read.csv('dataset.csv')
data <- data[c(1, 3, 9, 12, 20, 21, 22)]
data$Mean.Sea.Level.PressureIn <-
    round(data$Mean.Sea.Level.PressureIn * 33.86, 2)
data$PrecipitationIn <- data$PrecipitationIn * 25.4
data$Mean.TemperatureF <- round((data$Mean.TemperatureF - 32) * 5 / 9)

colnames(data) <- c('date',
                    'temperature',
                    'humidity',
                    'pressure',
                    'precipitation',
                    'cloudLevel',
                    'weather')

levels(data$weather) <- c(levels(data$weather), 'Cloudy', 'Sunny')
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

write.csv(data, file = 'processedDataset.csv', quote = F, row.names = F)
