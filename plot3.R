################################################################################
# Filename : plot3.R
# Author   : Carlomagno Anastacio
# Date     : 2018/2/22
# Version  : 1.0 
# Remarks  : Creates a plot with lines corresponding to sub metering 1,2, and 3
#            energy values across Feb 1,2017 and Feb 2,2017.
################################################################################

#Download the file and extract the contents
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
downloadFilename <- "exdata%2Fdata%2Fhousehold_power_consumption.zip"
baseFile <- "household_power_consumption.txt"

#remove existing files to ensure that the latest data will always be used
if(!file.exists(downloadFilename)){                           
    unlink(downloadFilename)
}

#Download the latest version of the file and extract the content
download.file(fileURL,downloadFilename, mode ="wb")
unzip(downloadFilename)    
unlink(downloadFilename)

#Read the file and clean it to contain only needed observations
filterPattern <- "\\b2/2/2007\\b|\\b1/2/2007\\b"   #Feb 1 - Feb 2 2017 only
dummyFile <- "dummyFiltered.csv"                   #temporary clean file

header=readLines(baseFile,n=1)
filteredDates <- grep(filterPattern,readLines(baseFile),value=TRUE)
unlink(baseFile)

#Write the cleaned data frame to a clean file
write(header,dummyFile,sep=";")
write(filteredDates,dummyFile,sep=";",append = TRUE)

#Read clean data to a dataframe
energyConsumption <- read.csv(dummyFile,sep=";",header=TRUE)
unlink(dummyFile)

#Convert Date and Time fields to Date class to make it consistent for future 
#explorations
energyConsumption$Time <- strptime(paste(energyConsumption$Date, energyConsumption$Time), "%d/%m/%Y %H:%M:%S")
energyConsumption$Date <- as.Date(energyConsumption$Date,format="%d/%m/%Y")


#create the plot based on the requirement (use Ttime field for the correct days)
xLabel <- ""                                 #plot X-axis Label
yLabel <-"Global Active Power (kilowatts)"
plotType <- "l"                              #line chart
par(mfrow=c(1,1),oma=c(2,2,3,0),bg=NA)       #plot background color


plot(energyConsumption$Time,energyConsumption$Sub_metering_1,type="l",col="black",xlab="",ylab="Energy sub metering")
lines(energyConsumption$Time,energyConsumption$Sub_metering_2,type=plotType,col="red")
lines(energyConsumption$Time,energyConsumption$Sub_metering_3,type=plotType,col="blue")

#build the legend table
variables <- c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
legendColor <- c("black","blue","red")

#suppress warnings when calling legend
options(warn = -1)
legend("topright",variables,col=legendColor,lty=1,bg=par(bg=NA),cex=0.9,y.intersp = 0.5)
               #plot along the time (date time)
options(warn = getOption("warn"))

#export the plot as PNG file
dev.copy(png,file="plot3.png",width=480,height=480)
dev.off()                                    #close the device


#
#environment cleanup
rm(list=ls())

#EOF
