#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(bslib)
library(wildlifeDI)
library(leaflet)
library(leaflet.extras2)
library(sf)
library(geojsonsf)
# install.packages("yyjsonr")
library(leaftime)
library(htmltools)
library(tidyverse)

fluidPage(
  navbarPage("Animal Movement Prompts",
    theme = bs_theme(version = 5, bootswatch = "minty"),
    tabPanel(
      "Deer",
      card(card_header("What am I looking at?"),
           p("background")),
      
      layout_columns(
        card(
          card_header("Card 1 header"),
          p("Card 1 body"),
          radioButtons(
            "map_type", "Map point of view:",
            c(
              "Human Elements" = "human",
              "Nature Elements" = "nature"
            )
          ),
          leafletOutput("deer"),
        ),
        card(
          card_header("Card 2 header"),
          p("Card 2 body"),
          textInput("text", "Add text", ""),
        ),
      )
    ),
    tabPanel("")
  )
)
