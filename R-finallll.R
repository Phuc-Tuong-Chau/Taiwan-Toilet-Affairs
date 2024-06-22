library(readxl)
library(ggplot2)
library(dplyr)
library(stringr)
library(tidyr)
library(sf)
library(readr)
library(spdep)
library(ggplot2)
library(tmap)
library(leaflet)
library(geosphere)
library(fossil)
library(tidyverse)
library(leaflet)
library(htmlwidgets)
library(writexl)

#DISCLAIMER: We use different sets of data for different purpose. Smaller sets for the interactive maps, while bigger sets for other calculation + heat maps

#Import smaller set: 31 tourist spots + toilets in Taipei
tourist_31 <- read.csv("tourists_with_boundaries_en.csv")
taipei_toilet <- read.csv("Taipei_Toilet_new.csv")

#For calculate the distance by Haversine formula, there're at least two function in R, geosphere::distHaversine and fossil::deg.dist. Both works well with current data but for bigger dataset (1000 tourist spots and 44000 toilet across Taiwan), deg.dist does faster. geosphere::distHaversine calculates distance in meters, while deg.dist in kilometers
#Create a loop to calculate distace from every tourist spot to all toilet, count the number of toilet in 400 m, adding all to a list

distance = list()
number = list()

for (i in 1:nrow(tourist_31))
{
  for (n in 1:nrow(taipei_toilet))
  {
    distance[n] = deg.dist(
      tourist_31$Longitude[i], 
      tourist_31$Latitude[i], 
      taipei_toilet$longitude[n], 
      taipei_toilet$latitude[n]
    ) }
  number[i] = length(distance[distance < 0.4])
}

#add the list into a new column of tourist data (Toilet_400m is the column created by Python)
tourist_31$number_of_toiet <- number

#Breaking down functions: Haversine distance can also be calculated as below
deg2rad <- function(deg) return(deg*pi/180)
#haversine_km results in the same as deg.dist or distHaversine
haversine_km = function(lon1, lat1, lon2, lat2){
  # Convert degrees to radians
  lon1 <- deg2rad(lon1)
  lat1 <- deg2rad(lat1)
  lon2 <- deg2rad(lon2)
  lat2 <- deg2rad(lat2)
  R = 6371 #Mean radius of the earth in km
  diff.lon = (lon2-lon1)
  diff.lat = (lat2-lat1)
  a =(sin(diff.lat/2) * sin(diff.lat/2) + cos(lat1) * cos(lat2) * sin(diff.lon/2)* sin(diff.lon/2))
  c= 2*atan2(sqrt(a),sqrt(1-a))
  d = R*c
  return(d) #Distance in km
}

# Write a function to inquiry for toilets 
# in a distance of j meters from spot i

which_toilet_to_go <- function(i,j) 
{
  for (n in 1:nrow(taipei_toilet)) 
  {
    a = deg.dist(
      tourist_31$Longitude[tourist_31$Sight == i], 
      tourist_31$Latitude[tourist_31$Sight == i], 
      taipei_toilet$longitude[n], 
      taipei_toilet$latitude[n]) #run a loop from that specific tourist spot to all toilet in dataset
    if (a < j/1000) #deg.dist calculates the distance in kilometer unit
    {
      print(paste(toilet$name[n],",", a*1000, "meters")) }
    else
    {next}
  }
}

which_toilet_to_go("故宮博物院", 400)

#Create the interactive maps

#Import TW map

tw_map <- st_read("tw_map.shp")
tpe_map <- tw_map %>%
  filter(COUNTY_ID == "63000")

#Create labels for toilet + tourist spot

tourist_spot_labels <- sprintf(paste(
  tourist_31$Sight, "has", tourist_31$number_of_toiet, "toilets around")
) %>% lapply(htmltools::HTML)

toilet_labels <- sprintf(taipei_toilet$name) %>% lapply(htmltools::HTML)

#Create map that clusters toilets for cleaner visual

tourist_cluster <- leaflet() |>
  addTiles() |>
  setView(lng = 121.5654, lat = 25.1, zoom = 11) |>
  addPolygons(data = tpe_map,
              weight = 1,
              opacity = 1,
              color = "white",
              fillOpacity = 0.05) |>
  addMarkers(data = tourist_31, label = tourist_spot_labels,
             labelOptions = labelOptions(
               style = list("font-weight" = "normal", padding = "3px 8px"),
               textsize = "15px",
               direction = "auto")) |>
  addCircles(data = tourist_31, 
             radius = 400, 
             weight = 4, 
             opacity = 0.2, 
             color = "#336699",
             stroke = FALSE) |>
  addCircleMarkers(data = taipei_toilet,
                   radius = 5,
                   stroke = FALSE,
                   color = "#006600",
                   weight = 3,
                   opacity = 2,
                   fill = TRUE,
                   label = toilet_labels,
                   labelOptions = labelOptions(
                     style = list("font-weight" = "normal", padding = "3px 8px"),
                     textsize = "15px",
                     direction = "auto"),
                   clusterOptions = markerClusterOptions(
                     spiderfyOnMaxZoom = TRUE,
                     zoomToBoundsOnClick = TRUE))

tourist_cluster

#No cluster map

tourist_no_cluster <- leaflet() |>
  addTiles() |>
  setView(lng = 121.5654, lat = 25.1, zoom = 11) |>
  addPolygons(data = tpe_map,
              weight = 1,
              opacity = 1,
              color = "white",
              fillOpacity = 0.05) |>
  addMarkers(data = tourist_31, label = tourist_spot_labels,
             labelOptions = labelOptions(
               style = list("font-weight" = "normal", padding = "3px 8px"),
               textsize = "15px",
               direction = "auto")) |>
  addCircles(data = tourist_32, 
             radius = 400, 
             weight = 4, 
             opacity = 0.2, 
             color = "#336699",
             stroke = FALSE) |>
  addCircleMarkers(data = taipei_toilet,
                   radius = 5,
                   stroke = FALSE,
                   color = "#006600",
                   weight = 3,
                   opacity = 2,
                   fill = TRUE,
                   label = toilet_labels,
                   labelOptions = labelOptions(
                     style = list("font-weight" = "normal", padding = "3px 8px"),
                     textsize = "15px",
                     direction = "auto"))

tourist_no_cluster

#save HTML maps
saveWidget(tourist_no_cluster, file="tourist_no_cluster.html")
saveWidget(tourist_cluster, file="toilet_cluster.html")

# CALCULATE FOR ALL TAIWAN 

#Import full dataset of tourist spots and toilet in Taiwan
tourist <- read.csv("tourist_spot_full.csv")
toilet <- read.csv("taiwan_toilet_full.csv")

#get the population data 
#(which also include data about toilet/100k people, toilet/area - calculated by another team member)
tw_pop <- read_xlsx("taiwan_population.xlsx")

#Get data about TPE population
tpe_population <- read.csv("taipei_population.csv")

#Create similar loop to run Haversine formula
distance = list()
number = list()

for (i in 1:nrow(tourist))
{
  for (n in 1:nrow(toilet))
  {
    distance[n] = deg.dist(
      tourist$longitude[i], 
      tourist$latitude[i], 
      toilet$longitude[n], 
      toilet$latitude[n]
    ) }
  number[i] = length(distance[distance < 0.4])
  distance = list()
}

#Merge the list "number" into tourist dataframe
tourist$number_of_toiet <- as.numeric(number)

#Calculate INDEX for Taiwan 
mean(tourist$number_of_toiet) #Answer is 16.7

#Calculate INDEX for all counties
tourist_county <- tourist %>%
  rename(county = X3) %>%
  group_by(county) %>%
  summarise(tourist_spots = n(), index = mean(number_of_toiet))

tourist_county_clean <- 
  tourist_county[-c(11, 17), ]

write_xlsx(tourist_county, "county_index.xlsx")

ggplot(tourist_county, aes(x = X3, y = index)) +
  geom_bar(stat = "identity", fill = "skyblue")

#CREAT HEAT MAP TOILET PERPOPULATION TAIWAN

#get TW map data
tw_map <- st_read("tw_map.shp")

#merge to get map on county level
tw_map_county <- tw_map |>
  group_by(COUNTY) |>
  summarise(geometry = st_combine(geometry))

#calculate the number of toilet per county
toilet_by_county <- toilet |>
  group_by(county) |>
  summarise(number = n())

#merge number of toilet per county to county map
toilet_by_county <- toilet_by_county |>
  full_join(tw_map_county, join_by("county" == "COUNTY"))

#change the object to sf object
toilet_by_county <- st_as_sf(toilet_by_county)

#merge population chart with toilet per county chart
toilet_by_county <- toilet_by_county |>
  left_join(tw_pop, join_by("county"=="city_cn"))

#change the object to sf object
toilet_by_county <- st_as_sf(toilet_by_county)

#create a heat map to show counties on their toilet_per_100k 
toilet_per_100k_tw <- ggplot(toilet_by_county) +
  geom_sf(aes(fill=toilet_per_100k), lwd = 0) +
  scale_fill_gradient(low = "#cccccc", high = "#993000", 
                      guide = "colourbar",
                      space = "Lab", na.value = "white") +
  theme(legend.position = "none") +
  geom_sf_text(aes(label = county), colour = "black", size = 3,
               check_overlap = TRUE) +
  theme_void()

toilet_per_100k_tw

ggsave("toilet_per_100k_tw.jpg", toilet_per_100k_tw,
       width = 8, height = 7, units = "in", dpi = 500)

#Create the map plotting toilet in Taipei with color = district 

#get Taipei map from the TW map
tpe_map <- tw_map %>%
  filter(COUNTY_ID == "63000")

#group rows in Taipei map into district (town)
tpe_map <- tpe_map |>
  group_by(TOWN) |>
  summarise(geometry = st_combine(geometry))

#create a sub table of toilets in Taipei only
taipei_toilet_full <- toilet |> 
  filter(county == "臺北市")

taipei_toilet <- ggplot() +
  geom_sf(data = tpe_map) +
  geom_point(data = taipei_toilet_full,aes(x=longitude,y=latitude,color=city,label=city),alpha = 1/20) +
  theme_void() +
  geom_sf_text(data = tpe_map, aes(label = TOWN), colour = "black", size = 3,
               check_overlap = TRUE)

taipei_toilet

ggsave("taipei_toilet.jpg", taipei_toilet,
       width = 8, height = 7, units = "in", dpi = 900)

#Create the heat map showing toilet per 100k people in Taipei


#Clean the data
tpe_population <- tpe_population[c(3,5,7,9,11,13,15,17,19,21,23,25),]

tpe_population <- tpe_population |>
  rename(township = 1,
         total = 2,
         male = 3,
         female = 4,
         area = 5,
         density = 6)

#merge new data to TPE map
tpe_map <- tpe_map |>
  full_join(tpe_population, join_by("TOWN" == "township"))

#calculate number of toilets per city (district, not county)
toilet_by_town <- toilet |>
  group_by(city) |>
  summarise(number = n())


#merge number to tpe map (only keep number belonging to TPE)
tpe_map <- tpe_map |>
  left_join(toilet_by_town, join_by("TOWN" == "city"))

#calculate people_over_toilet, toilet_over_area, 
#toilet_per_100000 and add them to the map
tpe_map <- tpe_map |>
  mutate(people_over_toilet = total/number,
         toilet_over_area = number/area,
         toilet_per_100000 = number/total*100000)

#create a heat map based on toilet_per_100000
toilet_per_100000 <- ggplot(tpe_map) +
  geom_sf(aes(fill=toilet_per_100000), lwd = 0) +
  scale_fill_gradient(low = "#cccccc", high = "#00ccff", 
                      guide = "colourbar",
                      space = "Lab", na.value = "white") +
  theme(legend.position = "none") +
  geom_sf_text(aes(label = TOWN), colour = "black", size = 3,
               check_overlap = TRUE) +
  theme_void()

toilet_per_100000

#save it
ggsave("toilet_per_100000.jpg", toilet_per_100000,
       width = 8, height = 7, units = "in", dpi = 500)

#final table

tourist_county_clean$X3[c(2,3,4,5)] <- c("臺中市","臺北市","臺南市","臺東縣")

result <- tourist_county_clean |>
  left_join(tw_pop, join_by("X3" == "city_cn"))

write_xlsx(result, "result.xlsx")
