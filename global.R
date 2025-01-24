#### Load the required packages ####
library(shiny) # shiny features
library(shinydashboard) # shinydashboard functions
library(DT)  # for DT tables
library(dplyr)  # for pipe operator & data manipulations
library(plotly) # for data visualization and plots using plotly 
library(ggplot2) # for data visualization & plots using ggplot2
library(ggtext) # beautifying text on top of ggplot
library(sf) # for spatial data manipulation
library(readxl) # for reading Excel files
library(psych) # for data summary
library(maps) # for USA states map - boundaries used by ggplot for mapping
library(ggcorrplot) # for correlation plot
library(shinycssloaders) # to add a loader while graph is populating
library(leaflet)
library(mapview)
library(webshot)

# Load Attribute Data
attribute_data <- read_excel("D:/FILE FAUZAN/STIS SEMESTER 7/SKRIPSI/1. Data/Data_Lengkap_2.xlsx")

# Load Spatial Data
spatial_data1 <- st_read("D:/FILE FAUZAN/STIS SEMESTER 7/SKRIPSI/0. Batas Wilayah/Batas Banten/RBI_50K_2023_Banten.shp")
spatial_data2 <- st_read("D:/FILE FAUZAN/STIS SEMESTER 7/SKRIPSI/0. Batas Wilayah/Batas Jakarta/RBI_50K_2023_DKI Jakarta.shp")
spatial_data3 <- st_read("D:/FILE FAUZAN/STIS SEMESTER 7/SKRIPSI/0. Batas Wilayah/Batas Jawa Barat/RBI_50K_2023_Jawa Barat.shp")
spatial_data4 <- st_read("D:/FILE FAUZAN/STIS SEMESTER 7/SKRIPSI/0. Batas Wilayah/Batas Jawa Tengah/RBI_50K_2023_Jawa Tengah.shp")
spatial_data5 <- st_read("D:/FILE FAUZAN/STIS SEMESTER 7/SKRIPSI/0. Batas Wilayah/Batas Jawa Timur/RBI_50K_2023_Jawa Timur.shp")
spatial_data6 <- st_read("D:/FILE FAUZAN/STIS SEMESTER 7/SKRIPSI/0. Batas Wilayah/Batas Jogja/RBI_50K_2023_Daerah Istimewa Yogyakarta.shp")

# Combine spatial data
spatial_data <- rbind(spatial_data1, spatial_data2, spatial_data3, spatial_data4, spatial_data5, spatial_data6)
spatial_data$geometry <- st_make_valid(spatial_data$geometry)

## Add a new column `Wilayah` into the attribute dataset
my_data <- attribute_data %>%
  mutate(Wilayah = tolower(attribute_data$Wilayah))

# Convert spatial data to a data frame
state_map_df <- spatial_data %>%
  mutate(NAMOBJ = tolower(NAMOBJ)) %>%
  as.data.frame()

# Calculate centroids for spatial data
spatial_data <- spatial_data %>%
  mutate(centroid = st_centroid(geometry))

# Extract x and y coordinates from centroids
spatial_data <- spatial_data %>%
  mutate(
    x = st_coordinates(centroid)[, 1],
    y = st_coordinates(centroid)[, 2]
  )


# Column names without state. This will be used in the selectinput for choices in the shinydashboard
c1 = my_data %>% 
  select(-"Wilayah", -"Provinsi", -"Klaster") %>% 
  names()

# Column names without state and UrbanPopulation. This will be used in the selectinput for choices in the shinydashboard
c2 = my_data %>% 
  select(-"Wilayah", -"Provinsi", -"Klaster") %>% 
  names()



