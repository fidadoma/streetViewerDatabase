# imagemagick is required

if(!require("magick")) {install.packages("magick")}
library(magick)

# Places

places_dir <- here::here("streetview","places")

outdir_thumbnails <- here::here("streetview","thumbnails")
if(!dir.exists(outdir_thumbnails)) {
  dir.create(outdir_thumbnails, recursive = T)
}


num_places <- 10

dirs <- file.path(places_dir,paste0("A",str_pad(as.character(1:10),3, pad = "0")))

for(i in 1:length(dirs)){
  fs <- dir(dirs[i],full.names = T)
  for(j in 1:length(fs)) {
    magick::image_read(fs[j]) %>% 
      magick::image_scale("x80") %>% 
      image_write(file.path(outdir_thumbnails, basename(fs[j])))
  }
  
}

# final merging was done by command 
# montage.exe -mode concatenate -tile 10x10 place_*.jpg ../thumbnail_10places.jpg

# Tracks

tracks_dir <- here::here("streetview","tracks")

outdir_thumbnails <- here::here("streetview","thumbnails")
if(!dir.exists(outdir_thumbnails)) {
  dir.create(outdir_thumbnails, recursive = T)
}
