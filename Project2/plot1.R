# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008
source(load_data.R)
aggNEI <- aggregate(Emissions ~ year,NEI, sum)

#Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008
png(filename='plot1.png')
barplot(
  (aggNEI$Emissions)/10^6,
   names.arg=aggNEI$year,
   xlab="Year",
   ylab="PM2.5 Emissions (10^6 Tons)",
   main="Total PM2.5 Emissions From All US Sources"
)

dev.off()
