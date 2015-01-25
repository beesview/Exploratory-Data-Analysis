#### Download and unzip file
````
url <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url,"NEI_data.zip")
unzip("NEI_data.zip")
````
#### Read files
````
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
aggNEI <- aggregate(Emissions ~ year,NEI, sum)
````
#### Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008
````
png(filename='plot1.png')
barplot(
  (aggNEI$Emissions)/10^6,
   names.arg=aggNEI$year,
   xlab="Year",
   ylab="PM2.5 Emissions (10^6 Tons)",
   main="Total PM2.5 Emissions From All US Sources"
)

dev.off()
````
#### Answer to Q1: total emissions have decreased in the US from 1999 to 2008.

#### aggregate total emissions from PM2.5 for Baltimore City, Maryland (fips="24510") from 1999 to 2008.
````
baltimoreNEI <- NEI[NEI$fips=="24510",]
aggBaltimore <- aggregate(Emissions ~ year, baltimoreNEI,sum)

png(filename='plot2.png')
barplot(
  aggBaltimore$Emissions,
  names.arg=aggBaltimore$year,
  xlab="Year",
  ylab="PM2.5 Emissions (Tons)",
  main="Total PM2.5 Emissions From All Baltimore City Sources"
)

dev.off()
````
#### Answer to Q2: Overall total emissions from PM2.5 have decreased in Baltimore City, Maryland from 1999 to 2008.

#### Using the ggplot2 plotting system
````
library(ggplot2)

ggp <- ggplot(baltimoreNEI,aes(factor(year),Emissions,fill=type)) +
  geom_bar(stat="identity") +
  theme_bw() + guides(fill=FALSE)+
  facet_grid(.~type,scales = "free",space="free") + 
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
  labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))

png(filename='plot3.png')
print(ggp)
dev.off()
````
#### Answer to Q3: The non-road, nonpoint, on-road source types have all seen decreased emissions overall from 1999-2008 in Baltimore. The point source show a significant increase until 2005 then decreases in 2008 to just above the starting values.

#### Subseting coal combustion related NEI data, assuming that coal combustion related SCC records are those where SCC.Level.One contains the substring 'comb' and SCC.Level.Four contains the substring 'coal'.
````
library(ggplot2)
combustionRelated <- grepl("comb", SCC$SCC.Level.One, ignore.case=TRUE)
coalRelated <- grepl("coal", SCC$SCC.Level.Four, ignore.case=TRUE) 
coalCombustion <- (combustionRelated & coalRelated)
combustionSCC <- SCC[coalCombustion,]$SCC
combustionNEI <- NEI[NEI$SCC %in% combustionSCC,]

ggp <- ggplot(combustionNEI,aes(factor(year),Emissions/10^5)) +
  geom_bar(stat="identity",fill="grey",width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Coal Combustion Source Emissions Across US from 1999-2008"))

png(filename='plot4.png')
print(ggp)
dev.off()
````
#### Answer to Q4: Emissions from coal combustion related sources have decreased by about 1/3 from 1999-2008

#### assuming motor vehicles is something like Motor Vehicle in SCC.Level.Two
````
library(ggplot2)
vehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehiclesSCC <- SCC[vehicles,]$SCC
vehiclesNEI <- NEI[NEI$SCC %in% vehiclesSCC,]
baltimoreVehiclesNEI <- vehiclesNEI[vehiclesNEI$fips==24510,]

ggp <- ggplot(baltimoreVehiclesNEI,aes(factor(year),Emissions)) +
  geom_bar(stat="identity",fill="grey",width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore from 1999-2008"))

png(filename='plot5.png')
print(ggp)
dev.off()
````
#### Answer to Q5: Emissions from motor vehicle sources have dropped from 1999-2008 in Baltimore City
````
library(ggplot2)

vehiclesBaltimoreNEI <- vehiclesNEI[vehiclesNEI$fips == 24510,]
vehiclesBaltimoreNEI$city <- "Baltimore City"
vehiclesLANEI <- vehiclesNEI[vehiclesNEI$fips=="06037",]
vehiclesLANEI$city <- "Los Angeles County"
bothNEI <- rbind(vehiclesBaltimoreNEI,vehiclesLANEI)

ggp <- ggplot(bothNEI, aes(x=factor(year), y=Emissions, fill=city)) +
 geom_bar(aes(fill=year),stat="identity") +
 facet_grid(scales="free", space="free", .~city) +
 guides(fill=FALSE) + theme_bw() +
 labs(x="year", y=expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + 
 labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))

png(filename='plot6.png')
print(ggp)
dev.off()
````
#### Comparing to Baltimore, Los Angeles County has seen the greater changes over time in motor vehicle emissions from 1999-2008
