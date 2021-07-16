# Mapping with R

Simple (and not so simple) examples of mapping data with R

You might also like [https://git.soton.ac.uk/twr1m15/la_emissions_viz](https://git.soton.ac.uk/twr1m15/la_emissions_viz) which drives [https://rushby.shinyapps.io/LAemissions/](https://rushby.shinyapps.io/LAemissions/)

## data

The following example data is provided in the data folder of this repository:

* Boundary data - for Solent region (various [geographies](https://geoportal.statistics.gov.uk/): LA, LSOA, MSOA) - [Open Government Licence v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/)
* Energy - area-based statistics for domestic [electricity consumption](https://www.gov.uk/government/collections/sub-national-electricity-consumption-data) (England & Wales: LSOA, MSOA) - Open Government Licence v3.0
* [Lookup table](https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=name&tags=all(LUP_ADM)) for English geographies - Open Government Licence v3.0

You link these using the relevant area level codes such as:

 * Local Authority: `LA Code`<-> `lad18cd`
 * LSOA: `Lower Layer Super Output Area (LSOA) Code` <-> `LSOA11CD`
 * etc
 
## Examples

### rMappingExample

A [simple example of mapping using R](rMappingExample.html). Examples use Local Authority (LA) and Middle-layer Super Output Area (MSOA) geography and electricity consumption data (provided in `data` subfolder).

### ONS-open-geography

An [example and resources](ONS-open-geography.html) for using the [ONS Open Geography portal](https://geoportal.statistics.gov.uk) to download geographical data and create maps  using `Leaflet` package.

### fun with cartograms

What it says [on the tin](/cartograms/hex-cartograms.html)

## Resources

### Openstreetmap for base maps (i.e. map tiles/rasters)

 * [Edinburgh green space as an example with sf](https://ourcodingclub.github.io/tutorials/spatial-vector-sf/)
 * [Madrid supermarkets with sf](https://dominicroye.github.io/en/2018/accessing-openstreetmap-data-with-r/)
 * [Short term rentals in Halifax, Nova Scotia with sf](https://upgo.lab.mcgill.ca/2019/12/13/making-beautiful-maps/)
 
### Google maps for base maps

They want you to have an API key now. Yeah nah.

### tmap package - nice

 * check out the [bubble geom](https://cran.r-project.org/web/packages/tmap/vignettes/tmap-getstarted.html)
