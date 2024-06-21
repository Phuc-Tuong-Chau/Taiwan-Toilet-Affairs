# Project Title
Taiwan Toilet Affairs

## Project Description
[Enter a brief description of your project, including the data you used and the analytical methods you applied. Be sure to provide context for your project and explain why it is important.]

<p>This project seeks to examine Taiwan through the lens of a fundamental human need: the provision of public toilets. Access to public bathrooms shapes the experience of being a human in a city and should be an essential part in urban planning. We want to know how Taiwan is doing in terms of this, and make the data useful for the public and researchers.</p>

### Goal
The goal of the project is three-fold:
- First, we want to examine the density and distribution of public toilets across Taiwan. We will calculate and visualize it through to index: toilets per population and toilets per area
- Second, we aim to create *Tourist Toilet Index* - a new variable that shows the number of public toilets around tourist spots in Taipei/Taiwan. This can serve as an index to measure the quality of urban planning across cities/countries
- And third, we want to make an interactive map that shows every public toilet in Taipei around the walking distance of popular tourist spots. This is hopefully useful for somebody in need when nature calls.

### Data & the use of data

| Data | Source | Description |
|---|---|---|
| Taiwan's nationwide toilets data | Environmental Protection Administration, Ministry of Environment | Main dataset. This contains details of 44876 public toilets across the nation, including (1) city and village level, (2) name, (3) address, (4) longitude & latitude, (5) quality (4 levels), (6) location types (26 types), (7) designated users (6 types = male, female, handicapped, gender friendly, both, family). |
| Taiwan's Tourists Spots Coordinates | Tourism Administration, Taipei City Government, Google Maps, Shaowei Wu's blog | We need coordinates of tourist spots to calculate the distance to toilets. We use data provided by Taipei City government & Google Maps. We collect manually for 32 spots in Taipei and use Shaowei Wu's dataset for 1183 spots in Taiwan |
| Taiwan's cities population and area | Ministry of Interior, Republic of China (Taiwan); National Statistics | To calculate the density of toilets per population and area at cities levels |

## Getting Started
[Provide instructions on how to get started with your project, including any necessary software or data. Include installation instructions and any prerequisites or dependencies that are required.]
1. Data collection: Download data from all the sources
    - Taiwan Toilet data: download from source
    - Taipei tourist spots: list from Taipei Government and coordinates from Google Maps
    - Taiwan tourist spots: download from Shaowei Wu's blog
    - Taiwan Population & Area data: all counties/cities
2. Data cleaning
    - Cleaning toilet dataset: rename columns, translate into English, factcheck
    - Taiwan tourists spots: rename columns, rearrange, factcheck
    - Merge toilets, population, area to a file for calculation toilets density per population/area
    - Merge toilets, tourist spots coordinates for calculating distance and mapping
3. R Packages needed:
4. Python packages needed:

## File Structure
[Describe the file structure of your project, including how the files are organized and what each file contains. Be sure to explain the purpose of each file and how they are related to one another.]
1. 

## Analysis
[Describe your analysis methods and include any visualizations or graphics that you used to present your findings. Explain the insights that you gained from your analysis and how they relate to your research question or problem statement.]

### Toilets Distribution

#### Heatmap
[Thao adds here]

### Tourist Toilet Index 
#### Haversine Formula

Haversine Formula is used to calculate the distance between two or several given locations, by converting the latitude and longitude of each to radians.

Haversine Formula as follow:

![a = \sin^2\left(\frac{\phi_B - \phi_A}{2}\right) + \cos(\phi_A) \cdot \cos(\phi_B) \cdot \sin^2\left(\frac{\lambda_B - \lambda_A}{2}\right)](https://latex.codecogs.com/png.latex?\color{cyan}a%20%3D%20%5Csin%5E2%5Cleft(%5Cfrac%7B%5Cphi_B%20-%20%5Cphi_A%7D%7B2%7D%5Cright)%20%2B%20%5Ccos(%5Cphi_A)%20%5Ccdot%20%5Ccos(%5Cphi_B)%20%5Ccdot%20%5Csin%5E2%5Cleft(%5Cfrac%7B%5Clambda_B%20-%20%5Clambda_A%7D%7B2%7D%5Cright))

![c = 2 \cdot \text{atan2}\left( \sqrt{a}, \sqrt{1-a} \right)](https://latex.codecogs.com/png.latex?\color{cyan}c%20%3D%202%20%5Ccdot%20%5Ctext%7Batan2%7D%5Cleft(%20%5Csqrt%7Ba%7D%2C%20%5Csqrt%7B1-a%7D%20%5Cright))

![d = R \cdot c](https://latex.codecogs.com/png.latex?\color{cyan}d%20%3D%20R%20%5Ccdot%20c)

Where:
- $R$ is the earth's radius (mean radius = 6,371 km).

In our analysis, a circle is drawn with a radius equivalent to 400 meters around tourist spots in Taiwan. The decision of the length lies upon the common standard, as 400-meter is widely accepted as a conventional walking distance. We mark all the public toilets in the provided range of circles and calculate the average number of public toilets within the area of every tourist spots. After that, we create an interactive map html file to showcase our results with markers of tourists spots in Taipei as well as surrounding public toilets. We show the demonstration in R and Python below.

**Solutions in R (calculation all Taiwan, maps Taipei)**

```R
library(readxl)
library(ggplot2)
library(dplyr)
library(stringr)
library(tidyr)
library(sf)
library(readr)
library(ggmap)
library(spdep)
library(ggplot2)
library(tmap)
library(leaflet)
library(geosphere)
library(fossil)
library(tidyverse)
library(leaflet)
library(htmlwidgets)

#Import data (32 tourist spot + toilet in Taipei)
tourist_32 <- read.csv("tourists_with_boundaries.csv")
taipei_toilet <- read.csv("Taipei_Toilet_new (1).csv")

#For calculate the distance by Haversine formula, there're at least two function in R, geosphere::distHaversine and fossil::deg.dist. Both works well with current data but for bigger dataset (1000 tourist spots and 44000 toilet across Taiwan), deg.dist does faster. geosphere::distHaversine calculates distance in meters, while deg.dist in kilometers

distance = list()
number = list()

for (i in 1:nrow(tourist_32))
{
  for (n in 1:nrow(taipei_toilet))
  {
    distance[n] = deg.dist(
      tourist_32$Longitude[i], 
      tourist_32$Latitude[i], 
      taipei_toilet$longitude[n], 
      taipei_toilet$latitude[n]
    ) }
  number[i] = length(distance[distance < 0.4])
}

tourist_32$number_of_toiet <- number

#Write a function to inquiry for toilets in a distance of j meters from spot i

which_toilet_to_go <- function(i,j) 
  {
  for (n in 1:nrow(toilet)) 
    {
  a = deg.dist(
    tourist_32$Longitude[tourist_32$Sight == i], 
    tourist_32$Latitude[tourist_32$Sight == i], 
    taipei_toilet$longitude[n], 
    taipei_toilet$latitude[n]) #run a loop from that specific tourist spot to all toilet in dataset
    if (a < j/1000) #deg.dist calculates the distance in kilometer unit
    {
      print(paste(toilet$name[n], a*1000, "meters ", toilet$type[n])) }
    else
    {next}
  }
}

which_toilet_to_go("市立動物園",400)


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

### Toilet Distibution

result by counties and nationwide

### Tourist Toilet Index

Results by counties and nationwide

### Interactive maps

[Toilets around tourist spots in Taipei](https://thetoiletaffairs.github.io/golive/en.html)

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

- Researches:
    - Silitonga, S. (2020). Walkability; The Relationship of Walking Distance, Walking Time and Walking Speed. Jurnal Rekayasa Konstruksi Mekanika Sipil (JRKMS), 3(1), 19-26. DOI: 10.54367/JRKMS.V3I1.699.
    - Bliss, D. Z., & Park, Y. S. (2020). Public toilets in parklands or open spaces in international cities using geographic information systems. International urogynecology journal, 31(5), 939–945. https://doi.org/10.1007/s00192-019-04024-6
    - Simon Kettle (2017). Distance on a sphere: The Haversine formulas. https://community.esri.com/t5/coordinate-reference-systems-blog/distance-on-a-sphere-the-haversine-formula/ba-p/902128
- Python packages: Pandas for data aggregation, Numpy for calculation, Folium for the map
- R packages: Dplyr, Sf, tmap, ggplot2, leaflet


