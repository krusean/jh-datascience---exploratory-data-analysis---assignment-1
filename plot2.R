#Exploratory Data Analysis - JH
#Programming Assignment 1.2: Create plot2.png

#Load required packages
library(data.table)
library(lubridate)

### Download data ######################################################################################

if(!file.exists("household_power_consumption.txt")){
  path <- getwd()
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  
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
  
  remove(date_doc, date_start,start, read, url)
}

### Create plot2.png ###########################################################################

date_time <- strptime(paste(plot_data$date, plot_data$time, sep = " "),
                      "%d/%m/%Y %H:%M:%S")

png(file.path(path, "plot2.png"))

plot(date_time, plot_data$global_active_power, 
     type = "l", 
     xlab = "",
     ylab = "Global Active Power (kliowatts)")

#Note: Do, Fr, Sa = Thu, Fr, Sat in german

dev.off()






