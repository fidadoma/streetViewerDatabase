# load libraries

if(!require("strviewr")) {
  if(!is.element("devtools", installed.packages()[,1])) {install.packages("devtools")} 
  devtools::install_github("jiristipl/strviewr")
}

library(tidyverse)
library(strviewr)
library(stringr)

# following two lines should be changed to individual API key
source("R/private_functions.R")
key <- get_key()

# create directories

tracks_dir <- here::here("streetview","tracks")
if(!dir.exists(tracks_dir)) {
  dir.create(tracks_dir, recursive = T)
}

test_tracks_dir <- here::here("streetview","tracks", "example")
if(!dir.exists(test_tracks_dir)) {
  dir.create(test_tracks_dir, recursive = T)
}

# just test one example

download_track(start = c(50.080266, 14.447034),  
               end = c(50.081416, 14.447790),
               track_code = 1, 
               key = key, 
               folder = test_tracks_dir)

# now download whole directory

## load coordinates

placestrack_file <- here::here("data", "placestracks_locations.xlsx")
df <- readxl::read_excel(placestrack_file, "track")


df2 <- df %>%
  rowwise() %>% 
  mutate(lat_start = link_A %>% 
           str_replace(".*!3d(.*)!.*", "\\1") %>% 
           as.numeric(),
         long_start = link_A %>% 
           str_replace(".*!4d(.*)$", "\\1") %>% 
           as.numeric(),
         lat_end = link_B %>% 
           str_replace(".*!3d(.*)!.*", "\\1") %>% 
           as.numeric(),
         long_end = link_B %>% 
           str_replace(".*!4d(.*)$", "\\1") %>% 
           as.numeric()) %>% 
  ungroup() 

for (i in 1:nrow(df2)) {
  f_pth <- file.path(tracks_dir, df2$tid[i])
  
  if(!dir.exists(f_pth)) {
    dir.create(f_pth)
  }
  
  download_track(start=c(df2$lat_start[i], df2$long_start[i]), 
                 end=c(df2$lat_end[i], df2$long_end[i]), 
                 track_code=df2$tid[i],
                 pace=20,
                 key=key,
                 folder = f_pth)
  
}
