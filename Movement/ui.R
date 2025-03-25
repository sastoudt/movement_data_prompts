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
library(leaftime)
library(htmltools)
library(tidyverse)
library(geosphere)
library(lubridate)
library(plotly)
library(RColorBrewer)

fluidPage(
  navbarPage("Facing the blank page? Get inspired by animal data...",
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
        p("Caitlyn: I was inspired to find data on sharks after seeing a shark-tracking bracelet my sister bought. With the purchase of a bracelet, she was given access to the location of a shark through an app. We watched the shark swim along the East Coast and contrived stories about what it was doing. In our minds, the shark was on a food tour trying to find the tastiest surfers."),
        p("Shaheryar: Coming soon..."),
        p("Sara: Coming soon..."),
        p("Throughout developing this app, we took inspiration from pieces published in The Dodge. Here is a list of what we read:"),
        HTML("<a href='https://www.thedodgemag.com/christopherlinforth1'>Homesick by Christopher Linforth</a>"),
        HTML("<a href='https://www.thedodgemag.com/piyalimukherjee1'>Death is a Name Spelled in Stripes by Piyali Mukherjee </a>"),
        HTML("<a href='https://www.thedodgemag.com/violetagarciamendoza1'>Deathbed Phenomena and Incomplete Abecedarian at the End of the Once World by Victoria Garcia-Mendoza </a>"),
        HTML("<a href='https://cymbals-corn-mx5t.squarespace.com/joeannhart1'>Ah! by Joeann Hart</a>"),
        HTML("<a href='https://cymbals-corn-mx5t.squarespace.com/brittneycorrigan1'>Why Did the Chicken Remix by Brittney Corrigan</a>"),
        HTML("<a href='https://cymbals-corn-mx5t.squarespace.com/rbminer1'>The Lung Capacity of Aquatic Mammals by R.B. Miner</a>"),
        HTML("<a href='https://www.thedodgemag.com/jondoughboy1'>The North American Blizzard of 1996 by Jon Doughboy</a>"),
        HTML("<a href='https://www.thedodgemag.com/elizabethlevinson1'>like rabbits by Elizabeth Joy Levinson</a>"),
        HTML("<a href='https://www.thedodgemag.com/lieselhamilton1'>On Weeds and Healing by Liesel Hamilton</a>"),
        HTML("<a href='https://www.thedodgemag.com/mollyweisgrau1'>Animal Planet by Molly Weisgrau</a>"),
        HTML("<a href='https://www.thedodgemag.com/brendangillen1'> Tree Food by Brendan Gillen</a>"),
        HTML("<a href='https://www.nytimes.com/column/whats-going-on-in-this-graph'>The 'what do you notice? what do you wonder?' framework is inspired by the New York Times' What's Going On in This Graph series.</a>"),
        HTML("<a href='https://gizmodo.com/the-weirdest-story-ideas-come-from-your-own-obsessions-5565717'>The idea to use a timer to just record as mcuh as possible from the graph to get started is inspired by the 'write 50 first sentences' prompt found here.</a>"),
      )
    ),
    tabPanel(
      "National Parks: At a Glance",
      card(
        card_header("What am I looking at?"),
        HTML("<a href='https://irma.nps.gov/NPSpecies/Search/Advanced'> The National Park Service publishes a database of animal and plant species identified in individual national parks.</a>"),
        p("These species are verified by evidence — observations, vouchers, or reports that document the presence of a species in a park. All park species records are available to the public on the National Park Species portal, with exceptions for sensitive species where data sharing might pose a risk."),
        HTML("<a href='https://www.kaggle.com/datasets/umerhaddii/national-park-species-dataset'>You can get a 'ready to use' version of the data here.</a>"),
      ),
      layout_columns(
        card(
          card_header("Show me the data!"),
          selectInput("species_category", "Choose a Species Category:", choices = c(
            "Mammal", "Bird", "Reptile", "Amphibian", "Fish",
            "Vascular Plant", "Crab/Lobster/Shrimp", "Slug/Snail", "Spider/Scorpion", "Insect",
            "Other Non-vertebrates", "Non-vascular Plant", "Fungi", "Chromista", "Protozoa",
            "Bacteria"
          )),
          plotOutput(outputId = "speciesPlot")
        ),
        card(
          card_header("What do you notice? What do you wonder?"),
          textAreaInput("text5", "", "", height = "500px", width = "100%"),
          p("When you are done, feel free to download your ideas so you have them for future reference."),
          downloadButton("downloadText5", "Download Notes")
        )
      ),
      card(
        card_header("Countdown Timer"),
        p("Need some accountability? Use this timer for brainstorming above."),
        actionButton("start", "Start"),
        actionButton("stop", "Stop"),
        actionButton("reset", "Reset"),
        numericInput("seconds", "Seconds:", value = 300, min = 0, max = 99999, step = 1),
        textOutput("timeleft")
      ),
      card(
        card_header("If you get stuck, use these questions to explore biodiversity insights:"),
        tags$ul(
          tags$li("🌿 Which parks are biodiversity hotspots? What explains the patterns?"),
          tags$li("🦉 Are certain species naturally rare or impacted by human activity?"),
          tags$li("🏕️ How do highly visited parks compare to less visited ones?"),
          tags$li("🌍 Are species distributions shifting over time?")
        )
      )
    ),
    tabPanel(
      "Great White Sharks: At a Glance",
      card(
        card_header("What am I looking at?"),
        p("Below is an interactive map of Great White Shark Spottings."),
        HTML("<a href='http://www.inaturalist.org/observations/export'>The raw data was exported from iNaturalist and contains the user data, geolocation, and time of each shark observation.</a>"),
        p(" Each point represents a Great White shark spotting submitted by a user. Hover over the points to find out more information about the sighting!"),
      ),

      card( 
        card_header("Show me the data!"),
        selectInput("select",
          label = h3("Select  Decade(s)"),
          choices = list(
            "2020" = 2020, "2010" = 2010, "2000" = 2000, "1990" = 1990,
            "1980" = 1980, "1970" = 1970, "1950" = 1950
          ),
          selected = 1, multiple = TRUE
        ),
        plotlyOutput(outputId = "shark_distPlot"),
        height = 750
      ),
      card(
        card_header("Get writing! What do you notice? What do you wonder?"),
        textAreaInput("text4", "", "", height = "200px", width = "800px"),
        p("When you are done, feel free to download your ideas so you have them for future reference."),
        downloadButton("downloadText4", "Download Notes"),
      ),
      card(
        card_header("If you get stuck, consider these prompts:"),
        p("What if the same shark visited a location in multiple decades? What are they looking for? Is there something special about that place?"),
        br("Consider an isolated data point. Why would a shark want to travel alone in a new location? How did they get there and where are they coming from?"),
        br("Why are the majority of the spottings on the coast? Why not the middle of the ocean? Is there something the sharks are afraid of? How do they feel about the people on the beach?"),
      ),
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
          downloadButton("downloadText", "Download Notes"),
        ),
      ),
      card(
        card_header("Organizing Your Thoughts"),
        p("Now that you have some ideas down, try to group them by common theme. These themes can help guide you towards a particular slice or summary of this dataset on the next page.")
      ),
    ),
    tabPanel(
      "White-tailed Deer: A Deeper Dive",
      card(
        card_header("I'm interested in learning more about the deer's day-to-day travels."),
      ),
      layout_columns(
        card(
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
      card(
        plotOutput("distPlot"),
      ),
      card(
        card_header("Get writing!"),
        p(""),
        textAreaInput("text3", "", "", height = "200px", width = "800px"),
        p("When you are done, feel free to download your ideas so you have them for future reference."),
        downloadButton("downloadText2", "Download Notes"),
      ),
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
        leafletOutput("deer_home"),
      ),
      card(
        card_header("Get writing!"),
        p(""),
        textAreaInput("text2", "", "", height = "200px", width = "800px"),
        p("When you are done, feel free to download your ideas so you have them for future reference."),
        downloadButton("downloadText2", "Download Notes"),
      ),
      card(
        card_header("Writing Prompts"),
        p("prompts to come")
      ),
      card(
        card_header("Coming soon..."),
        p("I'm interested in learning more about the interactions between the two deer."),
        p("I'm interested in learning more about the deers' environment.")
      )
    )
  )
)
