# Taiwan Toilet Affairs

## Project Description
[Enter a brief description of your project, including the data you used and the analytical methods you applied. Be sure to provide context for your project and explain why it is important.]

<p>This project seeks to examine Taiwan through the lens of a fundamental human need: the provision of public toilets. Access to public bathrooms shapes the experience of being a human in a city and should be an essential part in urban planning. As there haven't been an analysis about Taiwan's toilet so far, we want to explore it and make the data useful for the public and researchers.</p>

### Goal
This project has three goals:
- First, we want to examine the density and distribution of public toilets across Taiwan. We will calculate and visualize it through to index: toilets per population and toilets per area
- Second, we aim to create *Tourist Toilet Index* - a new variable that shows the number of public toilets around tourist spots in Taipei/Taiwan. This can serve as an index to measure the quality of urban planning across cities/countries
- And third, we want to make an interactive map that shows every public toilet in Taipei around the walking distance of popular tourist spots. This is hopefully useful for somebody in need when nature calls. We can only do Taipei due to technical capacity.

### Data & the use of data

| Data | Source | Description |
|---|---|---|
| Taiwan's nationwide toilets data | Environmental Protection Administration, Ministry of Environment | Main dataset. This contains details of 44876 public toilets across the nation, including (1) city and village level, (2) name, (3) address, (4) longitude & latitude, (5) quality (4 levels), (6) location types (26 types), (7) designated users (6 types = male, female, handicapped, gender friendly, both, family). |
| Taiwan's Tourists Spots Coordinates | Tourism Administration, Taipei City Government, Google Maps, Shaowei Wu's blog | We need coordinates of tourist spots to calculate the distance to toilets. We use data provided by Taipei City government & Google Maps. We collect manually for 32 spots in Taipei and use Shaowei Wu's dataset for 1183 spots in Taiwan |
| Taiwan's cities population and area | Ministry of Interior, Republic of China (Taiwan); National Statistics | To calculate the density of toilets per population and area at cities levels |

## Getting Started
[Provide instructions on how to get started with your project, including any necessary software or data. Include installation instructions and any prerequisites or dependencies that are required.]
1. Data collection & cleaning:
    - Taiwan Toilet data: download from source, rename columns, translate into English, factcheck
    - Taipei tourist spots: list from Taipei Government and coordinates from Google Maps, rename columns, rearrange, factcheck
    - Taiwan tourist spots: download from Shaowei Wu's blog, clean, rename columns
    - Taiwan Population & Area data: all counties/cities
    - Merge toilets, population, area to a file for calculation toilets density per population/area
    - Merge toilets, tourist spots coordinates for calculating distance and mapping
2. R Packages needed:
   - For data analysis: ggplot, dplyr, tidyr, ggplot2, tidyverse
   - For calculation and mapping: leaflet, geosphere, fossil, htmlwidgets
4. Python packages needed: Pandas for data aggregation, Numpy for calculation, Folium for the map

## File Structure
[Describe the file structure of your project, including how the files are organized and what each file contains. Be sure to explain the purpose of each file and how they are related to one another.]
1. taiwan_toilet_full: All toilets data, translated and cleaned, N=44876
2. tourist_spot_full: All tourist spots, removed repetition, N=922
3. taiwan_population: Population, area, toilets by all counties, N=23 (22 counties + all taiwan)
4. taipei_population: Taipei population per district, for mapping, N=13
5. Taipei_Toilet_new: Taipei toilets coordinates, N=6994
6. tourist_with_boundaries_en: Taipei Tourists spots & coordinates, N=31
7. 2021TW_SHP.zip: Taiwan maps for plotting

## Analysis
[Describe your analysis methods and include any visualizations or graphics that you used to present your findings. Explain the insights that you gained from your analysis and how they relate to your research question or problem statement.]

### Toilets Distribution per Population & Area
We calculate the number of toilets per 100,000 population and area (km2) for 22 counties/cities in Taiwan and nationwide. This is the method used by Bliss & Park (2020) to examine toilet distribution in 12 cities in the US, Europe and Asia. From the toilet data, we use dplyr's group_by command to aggregate toilet numbers, then we merge it with population and area data to calculate. The data is presented in file []

Findings:
- Toilets per 100k population: Taitung has the highest ratio: 377.4, while Pingtung has the lowest: 125.2. Average number is 256 and median number is 216. (Notes: Results are not valid counties with population below 100k people: Lianjiang, Kinmen, Penghu)
- Toilets per area (km2): Taipei has the highest ratio: 25.7; while Hualien has the lowest: 0.16. Average number is 3.4 and median is 1.4.

We visualize the result using heatmap & charts, for Taiwan and Taipei below.

#### Taiwan: Public Toilet Distribution per 100k Population

![toilet_per_100k_tw](https://github.com/Phuc-Tuong-Chau/Taiwan-Toilet-Affairs/assets/144694440/5b4061f8-54bd-4cb8-9079-d3208cc09677)

#### Taiwan: Toilets density vs. People density

<img width="1350" alt="peope toilet density" src="https://github.com/Phuc-Tuong-Chau/Taiwan-Toilet-Affairs/assets/144694440/dd4a6050-82b3-4341-a528-304c700e3e00">

#### Taipei: Public Toilet Distribution per 100k Population

![toilet_per_100000](https://github.com/Phuc-Tuong-Chau/Taiwan-Toilet-Affairs/assets/144694440/1f226bf8-7cb9-48ef-9c84-dd64ed12deac)

#### Taipei: Toilets in Districts

![taipei_toilet](https://github.com/Phuc-Tuong-Chau/Taiwan-Toilet-Affairs/assets/144694440/e8a4c836-011e-43a5-b966-93577fd6f350)

### Tourist Toilet Index

This is an index recommended by Professor Chung-pei Pien: the average number of toilets around tourist spots in walking distance. This can be useful in urban planning with a focus on tourism. We use Haversine formula to calculate distance between toilet and attraction using their coordinates and count the number in default distance.

#### Haversine Formula

Haversine Formula is used to calculate the distance between two or several given locations, by converting the latitude and longitude of each to radians.

Haversine Formula as follow:

![a = \sin^2\left(\frac{\phi_B - \phi_A}{2}\right) + \cos(\phi_A) \cdot \cos(\phi_B) \cdot \sin^2\left(\frac{\lambda_B - \lambda_A}{2}\right)](https://latex.codecogs.com/png.latex?\color{cyan}a%20%3D%20%5Csin%5E2%5Cleft(%5Cfrac%7B%5Cphi_B%20-%20%5Cphi_A%7D%7B2%7D%5Cright)%20%2B%20%5Ccos(%5Cphi_A)%20%5Ccdot%20%5Ccos(%5Cphi_B)%20%5Ccdot%20%5Csin%5E2%5Cleft(%5Cfrac%7B%5Clambda_B%20-%20%5Clambda_A%7D%7B2%7D%5Cright))

![c = 2 \cdot \text{atan2}\left( \sqrt{a}, \sqrt{1-a} \right)](https://latex.codecogs.com/png.latex?\color{cyan}c%20%3D%202%20%5Ccdot%20%5Ctext%7Batan2%7D%5Cleft(%20%5Csqrt%7Ba%7D%2C%20%5Csqrt%7B1-a%7D%20%5Cright))

![d = R \cdot c](https://latex.codecogs.com/png.latex?\color{cyan}d%20%3D%20R%20%5Ccdot%20c)

Where:
- $R$ is the earth's radius (mean radius = 6,371 km).

In our analysis, a circle is drawn with a radius equivalent to 400 meters around tourist spots in Taiwan. The decision of the length lies upon the common standard, as 400-meter is widely accepted as a conventional walking distance (Silitonga 2020). We mark all the public toilets in the provided range of circles and calculate the average number of public toilets within the area of every tourist spots. After that, we create an interactive map html file to showcase our results with markers of tourists spots in Taipei as well as surrounding public toilets. We show the demonstration for this part in R and Python below.

In R, for calculate the distance by Haversine formula, there're at least two function: *geosphere::distHaversine* and *fossil::deg.dist*. Both works well with current data, but for bigger dataset (>1000 tourist spots and >44000 toilet across Taiwan), *deg.dist* does faster. *geosphere* calculates distance in meters, while *fossil* does in kilometers.

**Solutions in R (extraction of calculation for Taipei, maps Taipei)**

```R
library(readxl)
library(ggplot2)
library(dplyr)
library(stringr)
library(tidyr)
library(sf)
library(readr)
library(ggplot2)
library(leaflet)
library(geosphere)
library(fossil)
library(tidyverse)
library(leaflet)
library(htmlwidgets)

#DISCLAIMER: We use different sets of data for different purpose. Smaller sets for the interactive maps, while bigger sets for other calculation + heat maps

#Import smaller set: 31 tourist spots + toilets in Taipei
tourist_31 <- read.csv("tourists_with_boundaries.csv")
taipei_toilet <- read.csv("Taipei_Toilet_new.csv")

#Create a loop to calculate distace from every tourist spot to all toilet,
#count the number of toilet in 400 m, add counts to a list (every count is one tourist spot's number of walkable toilets)

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
  number[i] = length(distance[distance < 0.4]) #fossil::deg.dist returns distance in kilometers
}

#add the list into a new column of tourist data (Toilet_400m is the column created by Python)
tourist_31$number_of_toiet <- as.numeric(number)

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
# in a distance of j meters from spot i (can use for later search features on the map)

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

#test
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

```

**Solutions in Python (Taipei only)**
```python
import pandas as pd
import numpy as np
import folium

#dataset of tourist spots in Taipei
tourists = pd.read_csv("/content/tourists_with_boundaries_en.csv")

# dataset of all toilets in Taipei
Taipei_Toilet = pd.read_csv("/content/Taipei_Toilet_new.csv")

# Haversine
def haversine(lat1, lon1, lat2, lon2):
    R = 6371000  #radius of Earth in meter
    phi1 = np.radians(lat1)
    phi2 = np.radians(lat2)
    delta_phi = np.radians(lat2 - lat1)
    delta_lambda = np.radians(lon2 - lon1)
    a = np.sin(delta_phi / 2) ** 2 + np.cos(phi1) * np.cos(phi2) * np.sin(delta_lambda / 2) ** 2
    c = 2 * np.arctan2(np.sqrt(a), np.sqrt(1 - a))
    return R * c

# check if all toilets are within 400m
within_range_toilets = []
for _, toilet in Taipei_Toilet.iterrows():
    toilet_lat = toilet['latitude']
    toilet_lon = toilet['longitude']
    within_range = False
    for _, tourist in tourists.iterrows():
        tourist_lat = tourist['Latitude']
        tourist_lon = tourist['Longitude']
        distance = haversine(toilet_lat, toilet_lon, tourist_lat, tourist_lon)
        if distance <= 400:
            within_range = True
            break
    if within_range:
        within_range_toilets.append(toilet)

# toilets  within 400m
within_range_toilets_df = pd.DataFrame(within_range_toilets)

# create a map
map_center = [tourists['Latitude'].mean(), tourists['Longitude'].mean()]
mymap = folium.Map(location=map_center, zoom_start=12)

# circle
for _, row in tourists.iterrows():
    location = [row['Latitude'], row['Longitude']]
    folium.Marker(location, popup=row['Sight'], icon=folium.Icon(color='blue')).add_to(mymap)
    folium.Circle(location, radius=400, color='blue', fill=False).add_to(mymap)

# mark toilets
for _, row in within_range_toilets_df.iterrows():
    location = [row['latitude'], row['longitude']]
    folium.Marker(location, popup=row['name'], icon=folium.Icon(color='green')).add_to(mymap)

```
## Results
[Provide a summary of your findings and conclusions, including any recommendations or implications for future research. Be sure to explain how your results address your research question or problem statement.]

### Public Toilet Index

The main index regarding public toilets in the cities in Taiwan is presented below.
- Tourist Toilet Index: The average number in Taiwan is 17.6. All cities/counties in Taiwan has a positive number of toilets around. The lowest is Kinmen (1.5) and the highest is Taipei (54.6). 
- Tourist spots with zero toilet in walking distance: In 922 tourists spots we examine in Taiwan, there are 214 has no toilets in 400m radius. They exist in 21 counties except Hsinchu City (新竹市), with the highest number is in Nantou (30/58).
- All Taiwan counties pass the standard recommended by Loo of the Year Award, which is at least one toilet facility should be provided in every settlement with a population of over 5000.

| city_cn | city_en        | toilet_numbers | tourist_spots | zero_toilets | tourist_toilet_index | toilet_per_5000 | toilet_per_100k | toilet_per_km2 |
|---------|----------------|----------------|---------------|--------------|----------------------|-----------------|-----------------|----------------|
| 臺北市  | Taipei City    | 6994           | 118           | 10           | 54.63                | 13.5            | 269.6           | 25.73          |
| 新竹市  | Hsinchu City   | 808            | 10            | 24           | 34.20                | 8.1             | 161.8           | 7.76           |
| 臺中市  | Taichung City  | 5787           | 63            | 9            | 24.29                | 9.5             | 190.7           | 2.61           |
| 基隆市  | Keelung City   | 842            | 28            | 4            | 22.36                | 11.5            | 229.3           | 6.34           |
| 臺南市  | Tainan City    | 4906           | 66            | 6            | 18.89                | 13.1            | 261.6           | 2.24           |
| 高雄市  | Kaohsiung city | 4215           | 48            | 5            | 15.42                | 7.7             | 154.2           | 1.43           |
| 嘉義市  | Chiayi City    | 653            | 7             | 6            | 14.57                | 13.0            | 259.1           | 10.88          |
| 新北市  | New Taipei City| 5889           | 116           | 7            | 12.87                | 6.7             | 134.9           | 2.87           |
| 桃園市  | Taoyuan City   | 3806           | 12            | 6            | 12.83                | 7.8             | 155.9           | 3.12           |
| 宜蘭縣  | Yilan County   | 937            | 52            | 11           | 11.50                | 10.8            | 216.2           | 0.44           |
| 雲林縣  | Yunlin County  | 877            | 31            | 13           | 8.65                 | 7.4             | 148.4           | 0.68           |
| 彰化縣  | Changhua County| 1556           | 28            | 3            | 8.14                 | 6.6             | 131.1           | 1.45           |
| 澎湖縣  | Penghu County  | 369            | 47            | 11           | 6.96                 | 22.6            | 451.4           | 2.91           |
| 嘉義縣  | Chiayi County  | 1417           | 23            | 6            | 5.96                 | 15.3            | 305.3           | 0.74           |
| 新竹縣  | Hsinchu County | 883            | 31            | 7            | 5.77                 | 7.0             | 139.5           | 0.62           |
| 苗栗縣  | Miaoli County  | 1004           | 39            | 11           | 5.28                 | 9.6             | 192.4           | 0.55           |
| 南投縣  | Nantou County  | 1104           | 58            | 30           | 4.52                 | 12.8            | 256.6           | 0.27           |
| 臺東縣  | Taitung County | 715            | 42            | 22           | 4.17                 | 18.9            | 377.4           | 0.20           |
| 屏東縣  | Pingtung County| 945            | 13            | 17           | 4.00                 | 6.3             | 125.2           | 0.34           |
| 連江縣  | Lianjiang County| 92             | 2             | 1            | 4.00                 | 38.9            | 778.8           | 3.19           |
| 花蓮縣  | Hualien County | 728            | 45            | 17           | 3.69                 | 12.1            | 242.3           | 0.16           |
| 金門縣  | Kinmen County  | 349            | 2             | 1            | 1.50                 | 26.0            | 519.6           | 2.30           |
| 全台灣  | All Taiwan     | 44876          | 922           | 214          | 16.70                | 9.4             | 188.3           | 1.24           |


### Interactive maps
Toilets around tourist spots in Taipei
- [Map created by python](https://thetoiletaffairs.github.io/golive/en.html)
- [Map created by R with cluster](https://thaooi.github.io/toilet/toilet_cluster.html)

### Limitations & Notes for further researches:
- Toilets data in Taiwan is calculated by rooms inside a facilities. In some other places, toilets are counted on the unique adress. In order to compare across countries, it's necessary to make the data consistent.
- In terms of population, using moving population (people with active phone numbers) will reflect better result then census data as we use here.

## Contributors
[List the contributors to your project and describe their roles and responsibilities.]

- Nguyen, Thi Xuan Huong (Huong) 阮春香, 112ZM1043, Project Manager
- Chu, Fu-Hsiang (Gary) 朱福祥, 109ZU1027, Coder
- Bui, Phuong Thao (Thao) 裴芳草, 113ZM1011, Coder & Writer
- Karolina Kubicova (Karolina) 辜麗娜, 112ZM1044, Researcher, Designer, Writer

## Acknowledgments
[Thank any individuals or organizations who provided support or assistance during your project, including funding sources or data providers.]
- We'd like to thank Professor Chung-Pei Pien of ICI for his guidance and encouragement throughout the course Big Data and Social Analysis. His excitement for this toilet idea was key in pushing us go forward. Thanks also to the TAs, Joanna and Maobin for their help in organizing the course. And to Datacamp for being an extra teacher.
- Great thanks to the to the data collectors working with the Ministry of Environment for keeping a good record of the toilets around Taiwan. We hope you keep up the great work! Taipei's tourists spotThe coordinates of over 1000 tourists spots around Taiwan is from Shaowei Wu's blog. We also thank you for sharing that to the public domain.
- And millions thanks to the members of online coding communities. We learn so much from you.
  
## References
[List any references or resources that you used during your project, including data sources, analytical methods, and tools.]
- Data sources:
    - Archives on public toilets nationwide, Environmental Protection Administration, Ministry of Environment (Taiwan). https://data.moenv.gov.tw/en/dataset/detail/FAC_P_07
    - Shaowei Wu’s Blog (2018) Coordinate location map of Taiwan’s attractions. https://shaoweiwu088.pixnet.net/blog/post/262765884-%e5%85%a8%e5%8f%b0%e6%99%af%e9%bb%9e%e5%ba%a7%e6%a8%99%e4%bd%8d%e7%bd%ae%e5%9c%96
    - The number of tourists in the major sightseeing and recreation areas of Taipei City. Department of Budget, Accounting and Statistics, Taipei City Government. https://data.gov.tw/en/datasets/131711
    - Taiwan Counties and Cities Population and Area. Ministry of Interior, Republic of China (Taiwan); National Statistics, Republic of China (Taiwan). Access through Citypopulation.de. https://www.citypopulation.de/en/taiwan/cities/

- Researches/Projects:
    - Silitonga, S. (2020). Walkability; The Relationship of Walking Distance, Walking Time and Walking Speed. Jurnal Rekayasa Konstruksi Mekanika Sipil (JRKMS), 3(1), 19-26. DOI: 10.54367/JRKMS.V3I1.699.
    - Bliss, D. Z., & Park, Y. S. (2020). Public toilets in parklands or open spaces in international cities using geographic information systems. International urogynecology journal, 31(5), 939–945. https://doi.org/10.1007/s00192-019-04024-6
    - Simon Kettle (2017). Distance on a sphere: The Haversine formulas. https://community.esri.com/t5/coordinate-reference-systems-blog/distance-on-a-sphere-the-haversine-formula/ba-p/902128
    - Loo of the Year Award: https://www.loo.co.uk/46/Toilet-Ratios
- Python packages: Pandas for data aggregation, Numpy for calculation, Folium for the map
- R packages: For data analysis: ggplot, dplyr, tidyr, ggplot2, tidyverse; For calculation and mapping: leaflet, geosphere, fossil, htmlwidgets


