## scratch pre-processing

library(wildlifeDI)
library(tidyverse)
library(sf)
data(deer)

deer_coords <- do.call(rbind, st_geometry(deer)) %>% 
  as_tibble() %>% setNames(c("lon","lat"))
head(deer)
data = cbind.data.frame(id = deer$id, date = deer$date, lon = deer_coords$lon, lat = deer_coords$lat)



##### I'm interested in learning more about the deer's home ranges. #####




ch1 = chull(subset(data, id == 37)[,c("lon","lat")])
ch2 = chull(subset(data, id == 38)[,c("lon","lat")])
ch1 = c(ch1, ch1[1])
ch2 =  c(ch2, ch2[1])

deer2 = cbind.data.frame(start = gsub(" EST", "",deer$date), end = "2005-03-13 18:47:00",
                         Longitude = deer_coords$lon, Latitude = deer_coords$lat, color = ifelse(deer$id == "37", "dodgerblue","orange"))


ch1p = subset(data, id == 37)[,c("lon","lat")][ch1, ] 
ch2p = subset(data, id == 38)[,c("lon","lat")][ch2, ] 


leaflet(geojsonio::geojson_json(deer2)) %>%
  #addTiles() %>% ## HUMAN ELEMENTS
  addProviderTiles(providers$OpenStreetMap) %>%
  #addProviderTiles(providers$Esri.NatGeoWorldMap) %>% ## NATURE ELEMENTS
  addPolylines(data = ch1p, lng = ~lon, lat = ~lat, col = "dodgerblue" ) %>%
  addPolylines(data = ch2p, lng = ~lon, lat = ~lat, col = "orange" ) %>%
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






##### I'm interested in learning more about the distance the deer traveled. ####

library(geosphere)


d1 = distHaversine(subset(data, id == 37)[,c("lon","lat")])
d2 = distHaversine(subset(data, id == 38)[,c("lon","lat")])
t1 = diff(subset(data, id == 37)$date) 
t2 = diff(subset(data, id == 38)$date) 

id = c(rep("Deer 1", times = length(d1)), rep("Deer 2", times = length(d2)))

toP = cbind.data.frame(distT=c(d1, d2), timeD = c(t1, t2), id=id)

ggplot(toP, aes(timeD, distT, col = id)) + geom_point() + geom_line()
## I'm interested in learning more about the interactions between the two deer.




## I'm interested in learning more about the deer's daily patterns.


## new tab: layering datasets

## I"m interested in learning more about the deer's environment. (bring in other data, weather, landscape, biodiversity in region)






## box at end
## while developing this app, I read...
## quotes from their journal about what they liked
## datasets connected