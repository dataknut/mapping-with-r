# Hex-cartograms examples ----
# https://github.com/VictimOfMaths/Maps/blob/master/WFHCartogram.R
# Using hex-map data from https://github.com/houseofcommonslibrary/uk-hex-cartograms-noncontiguous/

# required packages
library(curl)
library(sf)
library(tidyverse)

# not (yet) required
# library(readxl)
# library(extrafont)
# library(scales)
# library(gtools)

# LA example ----

# Carl Baker's (@carlbaker) Local Authority Hex Cartogram
ltla <- tempfile()
source <- ("https://github.com/houseofcommonslibrary/uk-hex-cartograms-noncontiguous/raw/main/geopackages/LocalAuthorities-lowertier.gpkg")
ltla <- curl_download(url=source, destfile=ltla, quiet=FALSE, mode="wb")

# List layers
st_layers(ltla)

Background <- st_read(ltla, layer="7 Background")

ltladata <- st_read(ltla, layer="4 LTLA-2019")

Groups <- st_read(ltla, layer="2 Groups")

Group_labels <- st_read(ltla, layer="1 Group labels") %>% 
  mutate(just=if_else(LabelPosit=="Left", 0, 1))

ggplot()+
  geom_sf(data=Background %>% filter(Name!="Ireland"), aes(geometry=geom))+
  #geom_sf(data=ltladata %>% filter(response=="Total"), 
  #        aes(geometry=geom, fill=prop), colour="Black", size=0.1)+
  geom_sf(data=Groups %>% filter(RegionNation!="Northern Ireland"), 
          aes(geometry=geom), fill=NA, colour="Black") +
  geom_sf_text(data=Group_labels, aes(geometry=geom, label=Group.labe,
                                      hjust=just), size=rel(2.4), colour="Black")+
  #scale_fill_paletteer_c("pals::ocean.haline", direction=-1,
  #                       name="Proportion ever working from home", limits=c(0,NA),
  #                       labels=label_percent(accuracy=1))+
  theme_void()+
  theme(plot.title=element_text(face="bold", size=rel(1.5)),
        legend.position="top")+
  guides(fill = guide_colorbar(title.position = 'top', title.hjust = .5,
                               barwidth = unit(20, 'lines'), barheight = unit(.5, 'lines')))+
  labs(title="Local Authorities Hex-Cartogram",
       caption="Cartogram from @carlbaker/House of Commons Library\nPlot by @VictimOfMaths")


# MSOA example ----

ltmsoa <- tempfile()
source <- ("https://github.com/houseofcommonslibrary/uk-hex-cartograms-noncontiguous/raw/main/geopackages/MSOA.gpkg")
ltmsoa <- curl_download(url=source, destfile=ltmsoa, quiet=FALSE, mode="wb")

# List layers using st_layers
st_layers(ltmsoa)

# Create data using st_read to read the layers we need ...
background_msoa <- st_read(ltmsoa, layer="5 Background")
msoa_la_outlines <- st_read(ltmsoa, layer="3 Local authority outlines (2019)")
msoa_data <- st_read(ltmsoa, layer="4 MSOA hex")

msoa_groups <- st_read(ltmsoa, layer="2 Groups")

msoa_group_labels <- st_read(ltmsoa, layer="1 Group labels") %>% 
  mutate(just=if_else(LabelPosit=="Left", 0, 1))

ggplot()+
  geom_sf(data=background_msoa %>% filter(Name!="Ireland"), aes(geometry=geom))+
  #geom_sf(data=ltladata %>% filter(response=="Total"), 
  #        aes(geometry=geom, fill=prop), colour="Black", size=0.1)+
  geom_sf(data=msoa_data %>% filter(RegionNation!="Northern Ireland"), 
          aes(geometry=geom), fill=NA, colour="Blue") +
  geom_sf(data=msoa_la_outlines %>% filter(RegionNation!="Northern Ireland"), 
          aes(geometry=geom), fill=NA, colour="Black") +
  geom_sf(data=msoa_groups %>% filter(RegionNation!="Northern Ireland"), 
          aes(geometry=geom), fill=NA, colour="Black") +
  geom_sf_text(data=msoa_group_labels, aes(geometry=geom, label=Group.labe,
                                      hjust=just), size=rel(2.4), colour="Black") +
  #scale_fill_paletteer_c("pals::ocean.haline", direction=-1,
  #                       name="Proportion ever working from home", limits=c(0,NA),
  #                       labels=label_percent(accuracy=1))+
  theme_void()+
  theme(plot.title=element_text(face="bold", size=rel(1.5)),
        legend.position="top")+
  guides(fill = guide_colorbar(title.position = 'top', title.hjust = .5,
                               barwidth = unit(20, 'lines'), barheight = unit(.5, 'lines')))+
  labs(title="Middle-layer Super Output Area (MSOA) Hex-Cartogram",
       caption="Cartogram from @carlbaker/House of Commons Library\nPlot by @tom_rushby")


# I cannot find LSOA level hex maps but here's a link with a how-to for creating hex maps
# something to try out! See ...
# https://rpubs.com/langton_/worksheet-extras-03
# https://rpubs.com/Hailstone/326118
# https://rstudio-pubs-static.s3.amazonaws.com/342278_51068843182b41ad9e00dfcc35e65247.html

# Other resources ...
# https://docs.evanodell.com/parlitools/

# ODI Leeds ...
# https://odileeds.github.io/covid-19/LocalAuthorities/hexmap.html
# https://github.com/odileeds/hexmaps


