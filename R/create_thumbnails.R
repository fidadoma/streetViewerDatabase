# imagemagick is required

if(!require("magick")) {install.packages("magick")}
library(magick)
library(tidyverse)

# Places ------------------------------------------------------------------

places_dir <- here::here("streetview","places")

outdir_thumbnails_places <- here::here("streetview","thumbnails_places")
if(!dir.exists(outdir_thumbnails_places)) {
  dir.create(outdir_thumbnails_places, recursive = T)
}

num_places <- 10

dirs <- file.path(places_dir,paste0("P",str_pad(as.character(1:10),3, pad = "0")))

for(i in 1:length(dirs)){
  fs <- dir(dirs[i],full.names = T)
  for(j in 1:length(fs)) {
    magick::image_read(fs[j]) %>% 
      magick::image_scale("x80") %>% 
      image_write(file.path(outdir_thumbnails_places, basename(fs[j])))
  }
  
}

# final merging was done by command 
# montage.exe -mode concatenate -tile 10x10 place_*.jpg ../thumbnail_10places.jpg


# Tracks ------------------------------------------------------------------

tracks_dir <- here::here("streetview","tracks")


outdir_thumbnails_tracks <- here::here("streetview","thumbnails_tracks")
if(!dir.exists(outdir_thumbnails_tracks)) {
  dir.create(outdir_thumbnails_tracks, recursive = T)
}

num_tracks <- 20
num_total <- 120

tracks_processed <- 0


dirs <- file.path(tracks_dir,paste0("T",str_pad(as.character(1:num_total),3, pad = "0")))

for(i in 1:length(dirs)){
  fs <- dir(dirs[i],full.names = T)
  fs <- fs %>% str_subset("_0_")
  if(length(fs) >= 5 & tracks_processed < num_tracks) {
    for(j in 1:5) {
      image_read(fs[j]) %>% 
        image_scale("x80") %>% 
        image_write(file.path(outdir_thumbnails_tracks, basename(fs[j])))
    }
    
    tracks_processed <- tracks_processed + 1
  }
}

# final merging was done by command 
# montage.exe -mode concatenate -tile 10x10 track_*.jpg ../thumbnail_10tracks.jpg