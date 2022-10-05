library(icesTAF)
library(icesFO)

ecoregion <- icesFO::load_ecoregion("Oceanic Northeast Atlantic")

sf::st_write(ecoregion, "ecoregion.csv", layer_options = "GEOMETRY=AS_WKT")
