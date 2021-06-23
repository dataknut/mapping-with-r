# get feature layer data from ONS open geography API

# Really useful example of using ONS open geography portal with R
# https://medium.com/@traffordDataLab/pushing-the-boundaries-with-the-open-geography-portal-api-4d70637bddc3

library(sf)

# Load Local Authority geography from ----
# https://geoportal.statistics.gov.uk/datasets/ons::local-authority-districts-december-2020-uk-bgc/api

# Construct query URL from elements
geo_endpoint <- "https://ons-inspire.esriuk.com/arcgis/rest/services/"
geo_boundarylayer <- "Administrative_Boundaries/Local_Authority_Districts_December_2020_UK_BGC/"
geo_server <- "FeatureServer/0/"
geo_search <- "LAD20NM IN "

# Construct a vector of local authorities to load
# the following local authorities are the 'Solent' region
las_to_load <- c("Southampton","Portsmouth","Winchester",
                 "Eastleigh","Isle of Wight","Fareham",
                 "Gosport","Test Valley","East Hampshire",
                 "Havant","New Forest","Hart","Basingstoke and Deane")

geo_where <- las_to_load # sometimes we don't want all boundaries
geo_outfields <- "*" # returns all fields
#geo_outfields <- c("LAD20CD","LAD20NM","LONG","LAT") # use in place of line above to return selected fields only
geo_outSR <- "4326"
geo_format <- "json"

# Assemble the full URL for the query from elements above
geo_query_string <- paste0(geo_endpoint,geo_boundarylayer,geo_server,
                           "query?where=",geo_search,"(",paste(paste0("'",geo_where,"'"), collapse = ","),
                           ")&outFields=",(paste(geo_outfields, collapse = ",")),"&outSR=",geo_outSR,"&f=",geo_format)


# Format the URL to remove spaces
geo_query <- URLencode(geo_query_string)
message("Loading LA geometry from ONS Open Geography API")
# API query
sf_data <- st_read(geo_query)
#plot(st_geometry(sf_data))

# Useful lookup spatial reference for CRS
# https://spatialreference.org/ref/epsg/27700/
st_coord_sys <- st_crs(sf_data) # check coord system
st_coord_sys # current coord system EPSG: 4326 (is what leaflet wants - good)

# transform the coord system if required
if(st_coord_sys$epsg != 4326){
  sf_data <- st_transform(sf_data, "+proj=longlat +datum=WGS84")
}

# Create map (using leaflet) ----

# create popup first (using htmltools)
# by adding a column to sf_data object
library(htmltools)
sf_data$popup_text <-
  paste("Locial authority area code: ","<b>", sf_data$lad20cd, "</b>",
        '<br/>', 'Local authority: ', '<b>', sf_data$lad20nm, '</b>', ' ') %>%
  lapply(htmltools::HTML)

# plot map
library(leaflet)
leaflet(sf_data) %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addPolygons(color = "blue", fillColor = "blue", fillOpacity = 0.2, weight = 1.5, popup = ~(lad20nm), # popups clicked
              label = ~(popup_text),                                            # define labels
              labelOptions = labelOptions(                                      # label options
                style = list("font-weight" = "normal", padding = "2px 2px"),
                direction = "auto"),
              highlight = highlightOptions(
                weight = 5,
                color = "#666",
                fillOpacity = 0.7,
                bringToFront = TRUE))
