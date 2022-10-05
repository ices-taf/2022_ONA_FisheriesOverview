library(icesTAF)
taf.library(icesFO)

areas <- load_areas("Oceanic Northeast atlantic")

sf::st_write(areas, "areas.csv", layer_options = "GEOMETRY=AS_WKT")
