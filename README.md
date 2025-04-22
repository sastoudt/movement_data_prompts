# Data-Driven Narratives: Inspiring Eco-writing with an Interactive Data Exploration Applet

Read more about the behind-the-scenes aspects of the project [here](). *blog post coming soon*

## Shark Data

*HOW I COLLECTED MY DATA* - Caitlyn

iNaturalist is a website that allows users to submit their sightings of plants and animals so we can collect data on the world around us. Users take a photo, geotag the location, and post it for others to verify. Once enough experts have checked the information, the observation is added to the data pool.

![](https://github.com/sastoudt/movement_data_prompts/blob/main/screenshots/inat-screenshot.png)

In making the map, I used verified observations on great white sharks to create my data set. If you search for great whites on iNaturalist, you would get something like the below screenshot.

However, I chose to use the iNaturalist export feature to compile all of this data into a file I could use in RStudio. This can be done [here](https://www.inaturalist.org/observations/export). (Note: You will need to make a free iNaturalist account first.) I selected Great White Sharks as my ‘Taxon’ and changed the ‘verifiable’ options from ‘any’ to ‘yes’. This eliminated any data points that did not have locational data, which would help me when processing the data. iNaturalist allows you to pick which categories of information you want to export for each observation. There are tons of choices besides the categories I used, and you can select the groups you want from these check boxes:

![](https://github.com/sastoudt/movement_data_prompts/blob/main/screenshots/inat-query.png)


For each data point, I only exported the following information:

- Uuid - a unique string to identify which user made the observation
- Observed_on_string: The string showing how the user submitted the date
- observed_on - the data of the observation recorded as “year-month-day”
- Time_observed_at: a string for the time of day record, like “11:04”
- Num_identification_agreements: the number of times other users reported the observation as a great white shark
- Num_identification_disagreements: the number of users who disagreed with the species of the observation
- Latitude: the exact latitude of the observation
- Longitude: the exact longitude of the observation
- Positional accuracy: a string identifying if the coordinates are correctly chosen

At the time, I was not sure which category would be the easiest to work with or in the scope of my project. The groups Num_identification_agreements / disagreements were selected so I could verify that the data I would be using was accurate. The majority of the data has 0 disagreements with at least 4 agreements. At the time of my export, there were around 900 usable data points exported in the CSV file.

*HOW I PROCESSED MY DATA* - Caitlyn

To make the plot, the only categories I needed were “observed_on”, “longitude”, and “latitude”. This data set included observations from the 1950s to 2025, so I needed to group the dates of the observations into categories that were easy to understand.  I was interested in where the hotspots changed over time, so sorting by year was the best option. However, the range of the data set was still too large for the years to be the best identifier.  I was able to group the years by decade and choose a unique color and point shape to represent each decade.

You can see part of the code that processes my data [here](https://github.com/sastoudt/movement_data_prompts/blob/cfab4f9358ad3e323ee799bf6da78394f33b0c8f/Movement/server.R#L266). First, the code adds a category for just the year using the “observed_on” information. It then rounds the year to the correct decade using a math function called a floor, which ensures the value is always rounded down. The next two functions are where I was able to change the color and point shape for each decade. These are the choices I found to be readable, but can be changed if desired. The last two lines verify that all the decade values are recorded as numbers and sort the data by the decade category. Sorted data is then stored under the variable “filtered_data” so we can plot with the processed data set later in the code.

## National Park Service Data

*HOW I COLLECTED MY DATA* - Shaheryar

The National Park Service publishes a [database](https://irma.nps.gov/NPSpecies/Search/Advanced) of animal and plant species identified in individual national parks. These species are verified through evidence such as observations, vouchers, or reports that document their presence within a park. All park species records are available to the public through the National Park Species portal, except in cases where sharing data about sensitive species may pose a risk. You can get a 'ready to use' version of the data [here](https://www.kaggle.com/datasets/umerhaddii/national-park-species-dataset).


*HOW I PROCESSED MY DATA* - Shaheryar

Before displaying the data, we needed to filter by species that were present in the parks (see [here](https://github.com/sastoudt/movement_data_prompts/blob/cfab4f9358ad3e323ee799bf6da78394f33b0c8f/Movement/server.R#L64)) and keep track of unique species per park (see [here](https://github.com/sastoudt/movement_data_prompts/blob/cfab4f9358ad3e323ee799bf6da78394f33b0c8f/Movement/server.R#L240)).


## Deer Data 

*HOW I COLLECTED MY DATA* - Sara

This data comes from a [scientific study](https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/1365-2656.12198) of white-tailed deer in Oklahoma, USA who are wearing GPS collars that keep track of each deer's location over time. The data is made  available within the [wildlifeDI R package](https://github.com/jedalong/wildlifeDI).
          
*HOW I PROCESSED MY DATA* - Sara

Various summaries were computed on the two deer's coordinates and time stamp data including computing distances traveled (see [here](https://github.com/sastoudt/movement_data_prompts/blob/cfab4f9358ad3e323ee799bf6da78394f33b0c8f/Movement/server.R#L99)) and computing boundaries of travel (see [here](https://github.com/sastoudt/movement_data_prompts/blob/cfab4f9358ad3e323ee799bf6da78394f33b0c8f/Movement/server.R#L134)).

## A Note About Data Sharing

Within the Movement folder we locally have a data folder with the iNaturalist (great_whites.csv) and National Park data (most_visitied_nps_species_data.csv). We have not shared that data here, but instead, have walked through how to get these files above.

## Check out the app

A draft of the app can be found [here](https://sara-stoudt.shinyapps.io/movement/). [This](https://sastoudt.shinyapps.io/movement_copy/) is the same app, but since we haven’t scaled anything up yet, if the first one has too many users at one time, it will crash, so you can look here too. 
