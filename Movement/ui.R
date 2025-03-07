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
library(geosphere)
library(lubridate)
library(plotly)
library(RColorBrewer)

fluidPage(
  navbarPage("Get inspired by animal data...",
    theme = bs_theme(version = 5, bootswatch = "minty"),
    tabPanel(
      "Who are we, and what is this?",
      card(
        card_header("Our Goal"),
        p("We are a small team from Bucknell University (Elinam Agbo, Shaheryar Asghar, Caitlyn Hickey, and Sara Stoudt) sponsored by the Dominguez Center for Data Science,
          who have partnered with The Dodge to combine our two passions: Data Science and Nature. We have been developing different apps, like this one, to inspire creative writing based on real-world data!"), 
        br(" Our team encourages you to explore the data yourself and try to find a story hidden between the data points. We hope to see your stories come to life.")
      ),
      card(
        card_header("Our Inspiration"),
         p( "Caitlyn: I was inspired to find data on sharks after seeing a shark-tracking bracelet my sister bought. With the purchase of a bracelet, she was given access to the location of a shark through an app. We watched the shark swim along the East Coast and contrived stories about what it was doing. In our minds, the shark was on a food tour trying to find the tastiest surfers."),
     p("Shaheryar: Coming soon..."),
     p("Sara: Coming soon...")
         )
    ),
    tabPanel(
      "Great White Sharks: At a Glance",
      card(
        card_header("What am I looking at?"),
        p("Below is an interactive map of Great White Shark Spottings. The raw data was exported from iNaturalist and contains the user data, geolocation, and time of each shark observation. Each point represents a Great White shark spotting submitted by a user. Hover over the points to find out more information about the sighting!" )
      ),
      #layout_columns(
        card( #theme = bs_theme(preset = "minty"),
          #class = "card text-white bg-primary mb-3",
          card_header("Show me the data"),
          #p("Select Decade(s)"),
          ### put interactive widget here
          selectInput("select", label = h3("Select  Decade(s)"), 
                      choices = list("2020" = 2020, "2010" = 2010, "2000" = 2000,"1990" = 1990,
                                     "1980" = 1980,"1970" = 1970, "1950" = 1950), 
                      selected = 1, multiple = TRUE), 
          plotlyOutput(outputId = "shark_distPlot"), height = 750
        ),
      card(
        card_header("What do you notice? What do you wonder?"),
        p("What if the same shark visited a location in multiple decades? What are they looking for? Is there something special about that place?"),
        br("Consider an isolated data point. Why would a shark want to travel alone in a new location? How did they get there and where are they coming from?"),
        br("Why are the majority of the spottings on the coast? Why not the middle of the ocean? Is there something the sharks are afraid of? How do they feel about the people on the beach?"
        ),
      ),
      card(
        card_header("Get writing!"),
        p(""),
        textAreaInput("text4", "", "", height = "200px", width = "800px"),
        p("When you are done, feel free to download your ideas so you have them for future reference."),
        downloadButton("downloadText4", "Download Text"),
      ),
     # ),
    
    ),
    
    
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
    tabPanel(
      "White-tailed Deer: A Deeper Dive",
      # layout_columns(
      card(
      card_header("I'm interested in learning more about the deer's day-to-day travels."),
      ),
      layout_columns(
      
        card(
          
          p(""),
          ## toggles
          radioButtons(
            "dist_type", "Travel type:",
            c(
              "Step-by-step" = "step",
              "Cumulative" = "cumul"
            )
          ),
          sliderInput(
            "timechoice", "I'm interested in these times of the day:",
            min = 0, max = 24,
            value = c(0, 24)
          )
        ),
        card(
          checkboxGroupInput(
            "dowchoice", "I'm interested in these days of the week:",
            c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"), c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
          ),
        )
      ),
      ## output
      card(
        plotOutput("distPlot"),
      ),
      card(
        card_header("Get writing!"),
        p(""),
        textAreaInput("text3", "", "", height = "200px", width = "800px"),
        p("When you are done, feel free to download your ideas so you have them for future reference."),
        downloadButton("downloadText2", "Download Text"),
      ),
      # ),
      card(
        card_header("Writing Prompts"),
        p("prompts to come")
      ),
      card(
        card_header("I'm interested in learning more about the deer's home ranges."),
        p(""),
        ## toggles
        radioButtons(
          "map_type2", "Map point of view:",
          c(
            "Human Elements" = "human",
            "Nature Elements" = "nature"
          )
        ),
        ## output
        leafletOutput("deer_home"),
      ),
      card(
        card_header("Get writing!"),
        p(""),
        textAreaInput("text2", "", "", height = "200px", width = "800px"),
        p("When you are done, feel free to download your ideas so you have them for future reference."),
        downloadButton("downloadText2", "Download Text"),
      ),
      # ),
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
