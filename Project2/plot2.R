#aggregate total emissions from PM2.5 for Baltimore City, Maryland (fips="24510") from 1999 to 2008.
source(load_data.R)
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
