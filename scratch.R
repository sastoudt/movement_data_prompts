#devtools::install_github("jedalong/wildlifeDI")
library(wildlifeDI)
data(deer)


library(leaflet)
library(leaflet.extras2)
library(sf)
library(geojsonsf)
#install.packages("yyjsonr")
library(leaftime)
library(htmltools)

library(sf)
library(tidyverse)
deer_coords <- do.call(rbind, st_geometry(deer)) %>% 
  as_tibble() %>% setNames(c("lon","lat"))

deer2 = cbind.data.frame(start = gsub(" EST", "",deer$date), end = "2005-03-13 18:47:00",
                         Longitude = deer_coords$lon, Latitude = deer_coords$lat, color = ifelse(deer$id == "37", "dodgerblue","orange"))

## different tiles - TOGGLE
## slow it down
leaflet(geojsonio::geojson_json(deer2)) %>%
  #addTiles() %>% ## HUMAN ELEMENTS
  addProviderTiles(providers$OpenStreetMap) %>%
  #addProviderTiles(providers$Esri.NatGeoWorldMap) %>% ## NATURE ELEMENTS
  
  setView(-96.39,34.77,14) %>%
  # 14 for addTiles, stamen
  ## too zoomed out in physical
 
  addTimeline(
    sliderOpts = sliderOptions(duration = 1000*60), ## max duration in milliseconds
    timelineOpts = timelineOptions(
      styleOptions = NULL, # make sure default style does not override
      pointToLayer = htmlwidgets::JS(
        "
function(data, latlng) {
  return L.circleMarker(
    latlng,
    {
      radius: 2,
      color: data.properties.color,
      fillColor: data.properties.color,
      fillOpacity: 1
    }
  );
}
"
      )
    )
  )


