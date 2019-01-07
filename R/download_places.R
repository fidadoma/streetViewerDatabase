
if(!require("strviewr")) {
  if(!is.element("devtools", installed.packages()[,1])) {install.packages("devtools")} 
  library(devtools)
  
  install_github("jiristipl/strviewr")
}

library(tidyverse)
library(strviewr)
library(stringr)

# following two lines should be changed to individual API key
source("R/private_functions.R")
key <- get_key()

places_dir <- here::here("streetview","places")
if(!dir.exists(places_dir)) {
  dir.create(places_dir, recursive = T)
}


test_places_dir <- here::here("streetview","places", "example")
if(!dir.exists(test_places_dir)) {
  dir.create(test_places_dir, recursive = T)
}


download_place(loc=c(50.089360, 14.415233),place_code=1, step=35, key=key, folder = test_places_dir)

# now whole directory

placestrack_file <- here::here("data", "placestracks_locations.xlsx")

df <- readxl::read_excel(placestrack_file, "places")

df2 <- df %>%
  rowwise() %>% 
  mutate(lat = link %>% 
           str_replace(".*@(.*)/.*", "\\1") %>% 
           str_split(",",simplify = T) %>% 
           .[1] %>% as.numeric(),
         long = link %>% 
           str_replace(".*@(.*)/.*", "\\1") %>% 
           str_split(",",simplify = T) %>% 
           .[2] %>% as.numeric()) %>% 
  ungroup() 

tm <- FDhelpers::create.time.measure(nrow(df2))
for (i in 1:nrow(df2)) {
  f_pth <- file.path(places_dir, df2$pid[i])

  if(!dir.exists(f_pth)) {
    dir.create(f_pth)
  }
  
  download_place(loc=c(df2$lat[i], df2$long[i]), 
                 place_code=df2$pid[i],
                 step=35,
                 key=key,
                 folder = f_pth)
  tm <- FDhelpers::update.tm(tm) 
  FDhelpers::print.tm(tm)
}
