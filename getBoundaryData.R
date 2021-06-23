# get some geo data and pre-save it

library(sf) # install first if needed
library(data.table)
library(here)

# Local Authority boundaries for the Solent region ----
# see https://medium.com/@traffordDataLab/pushing-the-boundaries-with-the-open-geography-portal-api-4d70637bddc3

geo_query <- "https://ons-inspire.esriuk.com/arcgis/rest/services/Administrative_Boundaries/Local_Authority_Districts_December_2018_Boundaries_UK_BGC/MapServer/0/query?where=lad18nm%20IN%20(%27Southampton%27,%27Portsmouth%27,%27Winchester%27,%27Eastleigh%27,%27Isle%20of%20Wight%27,%27Fareham%27,%27Gosport%27,%27Test%20Valley%27,%27East%20Hampshire%27,%27Havant%27,%27New%20Forest%27,%27Hart%27,%27Basingstoke%20and%20Deane%27)&outFields=lad18cd,lad18nm,long,lat&outSR=4326&f=geojson"

message("Loading LA geometry from ONS Open Geography API")
la_sf_data <- sf::st_read(geo_query)
head(la_sf_data)
outf <- path.expand(paste0(here::here("data", "boundaries", "la_solent.shp")))
sf::write_sf(la_sf_data, outf)

# MSOA boundaries for the Solent region ----
# middle-layer-super-output-areas-december-2011-boundaries-full-clipped-bfc-ew-v3

# manually downloaded for now
# load all MSOAs from file

# NB this 'all MSOAs' file has been removed from the repo due to size
# the code is included here for reference
inFile <- path.expand(paste0(here::here("data", "boundaries", "msoa_all", 
"Middle_Layer_Super_Output_Areas__December_2011__Boundaries_Full_Clipped__BFC__EW_V3.shp")))
msoa_all_sf <- sf::read_sf(inFile)

# load the look up table so we can filter
lutFile <- here::here("data", "Output_Area_to_Lower_Layer_Super_Output_Area_to_Middle_Layer_Super_Output_Area_to_Local_Authority_District_(December_2011)_Lookup_in_England_and_Wales.csv")

oa_lut <- data.table::fread(lutFile)

# las_to_load <- c("Southampton","Portsmouth","Winchester",
#                  "Eastleigh","Isle of Wight","Fareham",
#                  "Gosport","Test Valley","East Hampshire",
#                  "Havant","New Forest","Hart","Basingstoke and Deane")

# select the OAs we want via LAs
oa_solentLut <- oa_lut[LAD11NM == "Southampton" | 
                   LAD11NM == "Portsmouth" |
                   LAD11NM == "Winchester" |
                   LAD11NM == "Eastleigh" |
                   LAD11NM == "Isle of Wight" |
                   LAD11NM == "Fareham" |
                   LAD11NM == "Gosport" |
                   LAD11NM == "Test Valley" |
                   LAD11NM == "East Hampshire" |
                   LAD11NM == "Havant" |
                   LAD11NM == "New Forest" |
                   LAD11NM == "Hart" |
                 LAD11NM == "Basingstoke and Deane"]

oa_solentLut[, .(nOAs = .N), keyby = .(LAD11NM)]

# collapse the OA level file to an MSOA level file
msoa_solentLut <- oa_solentLut[, .(nOAs = .N), 
                               keyby = .(MSOA11CD, # smallest geography to collapse to, include the others for reference
                                         MSOA11NM , LAD11CD, LAD11NM )]
msoa_solentLut[, .(nOAs = .N), keyby = .(LAD11NM)] # count them

# merge the MSOA level file with the MSOA level shape file
msoa_solent <- merge(msoa_all_sf, msoa_solentLut)

# check
table(msoa_solent$LAD11NM)

# save it out for re-use
outf <- path.expand(paste0(here::here("data", "boundaries", "msoa_solent.shp")))
sf::write_sf(msoa_solent, outf)

# LSOA boundaries for the Solent region ----
# use the generalised boundaries (smaller file)

# manually downloaded for now from
# https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=name&tags=all(BDY_LSOA%2CDEC_2011)
# load all LSOAs from file

inFile <- path.expand("~//Dropbox/data/UK_census2011/Lower_Layer_Super_Output_Areas_(December_2011)_Boundaries_Generalised_Clipped_(BGC)_EW_V3-shp/Lower_Layer_Super_Output_Areas_(December_2011)_Boundaries_Generalised_Clipped_(BGC)_EW_V3.shp") # local version
lsoa_all_sf <- sf::read_sf(inFile)

# las_to_load <- c("Southampton","Portsmouth","Winchester",
#                  "Eastleigh","Isle of Wight","Fareham",
#                  "Gosport","Test Valley","East Hampshire",
#                  "Havant","New Forest","Hart","Basingstoke and Deane")

# collapse the OA level file we made esrlier to an LSOA level file
lsoa_solentLut <- oa_solentLut[, .(nLSOAs = .N), 
                               keyby = .(LSOA11CD, # smallest geography to collapse to, include the others for reference
                                         MSOA11CD, MSOA11NM , LAD11CD, LAD11NM )]
lsoa_solentLut[, .(nOAs = .N), keyby = .(LAD11NM)] # count them

# merge the MSOA level file with the MSOA level shape file
lsoa_solent <- merge(lsoa_all_sf, lsoa_solentLut)

# check
table(lsoa_solent$LAD11NM)

# save it out for re-use
outf <- paste0(here::here("data", "boundaries", "lsoa_solent.shp"))
sf::write_sf(lsoa_solent, outf)
