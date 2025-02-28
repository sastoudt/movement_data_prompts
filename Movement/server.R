#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

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
      paste("draft-deer-dive-", gsub(" ", "_", Sys.time()), ".txt", sep = "")
    },
    content = function(con) {
      writeLines(input$text2, con)
    }
  )


  output$deer <- renderLeaflet({
    data(deer)
    deer_coords <- do.call(rbind, st_geometry(deer)) %>%
      as_tibble() %>%
      setNames(c("lon", "lat"))

    deer2 <- cbind.data.frame(
      start = gsub(" EST", "", deer$date), end = "2005-03-13 18:47:00",
      Longitude = deer_coords$lon, Latitude = deer_coords$lat, color = ifelse(deer$id == "37", "dodgerblue", "orange")
    )

    map_to_use <- ifelse(input$map_type == "human", providers$OpenStreetMap, providers$Esri.NatGeoWorldMap)
    ## different tiles - TOGGLE
    ## slow it down
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
