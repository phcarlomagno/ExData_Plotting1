################################################################################
# Filename : plot4.R
# Author   : Carlomagno Anastacio
# Date     : 2018/2/22
# Version  : 1.0 
# Remarks  : Creates 4 plots in a single canvas
################################################################################
setwd("D:/Working_Dir/R/Exploaratory Data Analysis")

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


#create the plots based on the requirement (use Time field for the correct days)
#adjust the margins for a whole view
par(mfrow=c(2,2),mar=c(4,6,5,1),oma=c(1,1,0,0),bg=NA)

with(energyConsumption,{
    #draw the Global Active Power line plot (same as plot2)
    plot(Time,Global_active_power,type="l",xlab="",ylab="Global Active Power")
    
    #draw the Voltage line plot
    plot(Time,Voltage,type="l",xlab="datetime",ylab="Voltage")

    #draw the Energy sub metering plot (same as plot3)
    plot(Time,Sub_metering_1,type="l",col="black",xlab="",ylab="Energy sub metering")
    lines(Time,Sub_metering_2,type="l",col="red")
    lines(Time,Sub_metering_3,type="l",col="blue")
    legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
           col=c("black","blue","red"),lty=1,cex=0.9, y.intersp = 0.5,bty="n",
           yjust = 0.5,xjust=1)

    #draw the Global reactive power plot
    plot(Time,Global_reactive_power,type="l",xlab="datetime",
         ylab="Global_reactive_power")          #plot along the time (date time)
})

#export the plot as PNG file
dev.copy(png,file="plot4.png",width=480,height=480)
dev.off()                                    #close the device


#
#environment cleanup
rm(list=ls())

#EOF