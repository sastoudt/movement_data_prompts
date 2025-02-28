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
  navbarPage("Get inspired by animal movement...",
    theme = bs_theme(version = 5, bootswatch = "minty"),
    tabPanel(
      "White-tailed Deer: At a Glance",
      card(
        card_header("What am I looking at?"),
        p("
          This data comes from a scientific study of white-tailed deer in Oklahoma, USA who are wearing GPS collars that keep track of each deer's location over time. 
          Below, you'll see the paths of two individual deer over the course of a week in March 2005.
          "),
        HTML("<a href='https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/1365-2656.12198'>Check out the research paper here.</a>"),
       
      ),
      layout_columns(
        card(
          card_header("Show me the data!"),
          p("A week in the lives of these two deer will unfold for you on the map below.
            Before starting, tailor your point of view by choosing a backdrop for the map. Feel free to zoom in and out to explore the area, but note that the viewing window by default is centered on where the action is.
            In addition, choose the speed at which the data will unfold. A week will be compressed (or drawn out) to fill the time limit you choose for your free writing."),
          radioButtons(
            "map_type", "Map point of view:",
            c(
              "Human Elements" = "human",
              "Nature Elements" = "nature"
            )
          ),
          sliderInput("time_to_write", "I want to write for ____ minutes:",
            min = 1, max = 20, value = 5
          ),
          leafletOutput("deer"),
        ),
        card(
          card_header("Get writing! What do you notice? What do you wonder?"),
          p("As you watch the deer, free write as many noticings and wonderings as you can before the movie ends."),
          textAreaInput("text", "", "", height = "600px", width = "600px"),
          p("When you are done, feel free to download your ideas so you have them for future reference."),
          downloadButton("downloadText", "Download Text"),
        ),
      ),
      card(
        card_header("Writing Prompts"),
        p("prompts to come")
      ),
      card(
        card_header("Behind the Scenes Inspiration"),
        p("what do you notice, what do you wonder, 50 first lines, connect to dodge examples")
      )
    ),
    tabPanel("White-tailed Deer: A Deeper Dive",
             card(
               card_header(""),
               p(""),
             ),
             layout_columns(
               card(
                 card_header(""),
                 p(""),
                 ## toggles
                 ## output
               ),
               card(
                 card_header("Get writing!"),
                 p(""),
                 textAreaInput("text2", "", "", height = "600px", width = "600px"),
                 p("When you are done, feel free to download your ideas so you have them for future reference."),
                 downloadButton("downloadText2", "Download Text"),
               ),
             ),
             card(
               card_header("Writing Prompts"),
               p("prompts to come")
             ),
             card(
               card_header("Behind the Scenes Inspiration"),
               p("")
             )
             )
  )
)
