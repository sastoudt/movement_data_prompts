#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

data(deer)
deer_coords <- do.call(rbind, st_geometry(deer)) %>%
  as_tibble() %>%
  setNames(c("lon", "lat"))

deer2 <- cbind.data.frame(
  start = gsub(" EST", "", deer$date), end = "2005-03-13 18:47:00",
  Longitude = deer_coords$lon, Latitude = deer_coords$lat, color = ifelse(deer$id == "37", "dodgerblue", "orange")
)


# Define server logic required to draw a histogram
function(input, output, session) {
  output$downloadText <- downloadHandler(
    filename = function() {
      paste("draft-deer-glance-", gsub(" ", "_", Sys.time()), ".txt", sep = "")
    },
    content = function(con) {
      writeLines(input$text, con)
    }
  )

  output$downloadText2 <- downloadHandler(
    filename = function() {
      paste("draft-deer-dive1-", gsub(" ", "_", Sys.time()), ".txt", sep = "")
    },
    content = function(con) {
      writeLines(input$text2, con)
    }
  )


  output$downloadText3 <- downloadHandler(
    filename = function() {
      paste("draft-deer-dive2-", gsub(" ", "_", Sys.time()), ".txt", sep = "")
    },
    content = function(con) {
      writeLines(input$text3, con)
    }
  )

  output$deer_home <- renderLeaflet({
    dataH <- cbind.data.frame(id = deer$id, date = deer$date, lon = deer_coords$lon, lat = deer_coords$lat)


    ch1 <- chull(subset(dataH, id == 37)[, c("lon", "lat")])
    ch2 <- chull(subset(dataH, id == 38)[, c("lon", "lat")])
    ch1 <- c(ch1, ch1[1])
    ch2 <- c(ch2, ch2[1])



    ch1p <- subset(data, id == 37)[, c("lon", "lat")][ch1, ]
    ch2p <- subset(data, id == 38)[, c("lon", "lat")][ch2, ]
    map_to_use <- ifelse(input$map_type2 == "human", providers$OpenStreetMap, providers$Esri.NatGeoWorldMap)


    leaflet(geojsonio::geojson_json(deer2)) %>%
      addProviderTiles(map_to_use) %>%
      addPolylines(data = ch1p, lng = ~lon, lat = ~lat, col = "dodgerblue") %>%
      addPolylines(data = ch2p, lng = ~lon, lat = ~lat, col = "orange") %>%
      setView(-96.39, 34.77, 14) %>%
      addTimeline(
        sliderOpts = sliderOptions(duration = 1000 * 60), ## max duration in milliseconds
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
  })


  output$deer <- renderLeaflet({
    map_to_use <- ifelse(input$map_type == "human", providers$OpenStreetMap, providers$Esri.NatGeoWorldMap)

    leaflet(geojsonio::geojson_json(deer2)) %>%
      addProviderTiles(map_to_use) %>%
      setView(-96.39, 34.77, 14) %>%
      addTimeline(
        sliderOpts = sliderOptions(duration = input$time_to_write * 1000 * 60), ## max duration in milliseconds
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
  })
}
