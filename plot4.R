#Exploratory Data Analysis - JH
#Programming Assignment 1.4: Create plot4.png

#Load required packages
library(data.table)
library(lubridate)

### Download data ######################################################################################


if(!file.exists("household_power_consumption.txt")){
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  path <- getwd()
  download.file(url, file.path(path, "data.zip"), method = "curl")
  
  unzip("data.zip")
  file.remove("data.zip")
}

### Read data into R ####################################################################################



#Read only the required rows
if(!exists("plot_data")){
  
  #Determine number of rows to skip (start) and number of rows to read (read) when reading into R
  date_doc <- "2006-12-16 17:24:00"
  date_start <- "2007-02-01 00:00:00"
  start <- as.integer(difftime(date_start, date_doc, units = "mins") + 1) 
  
  read <- (24 * 60 * 2)
  
  plot_data <- fread(file.path(path, "household_power_consumption.txt"),
                     skip = start, nrows = read,
                     col.names = c("date", "time", "global_active_power", "global_reactive_power",
                                   "voltage", "global_intensity", "sub_metering_1", "sub_metering_2",
                                   "sub_metering_3"),
                     na.strings = "?")
  
  remove(date_doc, date_start,start, read)
}


### Create plot4.png #############################################################

if(!exists("date_time")){
  date_time <- strptime(paste(plot_data$date, plot_data$time, sep = " "),
                        "%d/%m/%Y %H:%M:%S")
}

png(file.path(path, "plot4.png"))

par(mfrow = c(2,2))

plot(date_time, plot_data$global_active_power, 
     type = "l", 
     xlab = "",
     ylab = "Global Active Power")

plot(date_time, plot_data$voltage, 
     type = "l", 
     xlab = "datetime",
     ylab = "Voltage")

plot(date_time, plot_data$sub_metering_1,
     type = "l", 
     col = "black", 
     xlab = "", 
     ylab = "Energy sub metering")

lines(date_time, plot_data$sub_metering_2,
      col = "red")

lines(date_time, plot_data$sub_metering_3,
      col = "blue")

legend("topright", col = c("black", "red", "blue"),
       legend = c("Sub_metering_1",
                  "Sub_metering_2",
                  "Sub_metering_3"),
       lty = c(1,1,1), cex = 0.5,
       bty = "n")

plot(date_time, plot_data$global_reactive_power, 
     type = "l", 
     xlab = "datetime",
     ylab = "Global_reactive_power")
dev.off()
