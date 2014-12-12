data <- read.csv('dataset.csv')
data <- data[c(1, 3, 9, 12, 20, 21, 22)]
data$Mean.Sea.Level.PressureIn <-
    round(data$Mean.Sea.Level.PressureIn * 33.86, 2)
data$PrecipitationIn <- data$PrecipitationIn * 25.4
data$Mean.TemperatureF <- round((data$Mean.TemperatureF - 32) * 5 / 9)

colnames(data) <- c('date',
                    'temperature',
                    'humidite',
                    'pression',
                    'precipitation',
                    'nuage',
                    'temps')

levels(data$temps) <- c(levels(data$temps), 'Cloudy', 'Sunny')
data$temps[data$nuage >= 6 & data$temps == ''] <- 'Cloudy'
data$temps[data$temps == ''] <- 'Sunny'
data$temps[data$temps == 'Fog-Rain-Snow'] <- 'Snow'
data$temps[data$temps == 'Fog-Rain-Thunderstorm'] <- 'Rain'
data$temps[data$temps == 'Rain-Snow'] <- 'Snow'
data$temps[data$temps == 'Thunderstorm'] <- 'Rain'
data$temps[data$temps == 'Fog-Rain'] <- 'Rain'
data$temps[data$temps == 'Fog-Snow'] <- 'Snow'
data$temps[data$temps == 'Rain-Thunderstorm'] <- 'Rain'
noRainSubset <- data[data$temps == 'Rain' & data$precipitation == 0, ]
noRainSubset$temps <- ifelse(noRainSubset$nuage >= 6, 'Cloudy', 'Sunny')
data$temps[data$temps == 'Rain' & data$precipitation == 0] <- noRainSubset$temps
data$temps <- factor(data$temps)

write.csv(data, file = 'processedDataset.csv', quote = F, row.names = F)
