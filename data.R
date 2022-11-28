
# Initial formatting of the data

library(icesTAF)
library(icesFO)
library(dplyr)

mkdir("data")

# load species list
species_list <- read.taf("bootstrap/data/FAO_ASFIS_species/species_list.csv")
sid <- read.taf("bootstrap/data/ICES_StockInformation/sid.csv")
# effort$sub.region <- tolower(effort$sub.region)
# unique(effort$sub.region)


# 1: ICES official catch statistics

hist <- read.taf("bootstrap/data/ICES_nominal_catches/ICES_historical_catches.csv")
official <- read.taf("bootstrap/data/ICES_nominal_catches/ICES_2006_2019_catches.csv")
prelim <- read.taf("bootstrap/data/ICES_nominal_catches/ICES_preliminary_catches.csv")

catch_dat <-
  format_catches(2022, "Oceanic Northeast Atlantic",
    hist, official, NULL, species_list, sid)

write.taf(catch_dat, dir = "data", quote = TRUE)



# 2: SAG
sag_sum <- read.taf("bootstrap/data/SAG_data/SAG_summary.csv")
sag_refpts <- read.taf("bootstrap/data/SAG_data/SAG_refpts.csv")
sag_status <- read.taf("bootstrap/data/SAG_data/SAG_status.csv")


#DGS has a custom ref point for F 
sag_complete$FMSY[which(sag_complete$FishStock == "dgs.27.nea")] <- 0.0429543
sag_complete$MSYBtrigger[which(sag_complete$FishStock == "dgs.27.nea")] <- 336796
sag_complete$StockSize[which(sag_complete$FishStock == "dgs.27.nea")] <- sag_complete$TBiomass[which(sag_complete$FishStock == "dgs.27.nea")]


clean_sag <- format_sag(sag_complete, sid)
clean_status <- format_sag_status(status, 2022, "Oceanic Northeast Atlantic")


ONA_out <- c("cap.27.2a514",
             "cod.2127.1f14",
             "mur.27.67a-ce-k89a",
             "reb.27.14b",
             "reb.27.5a14",
             "reg.27.561214",
             "rjm.27.8",
             "rjn.27.678abd",
             "syc.27.67a-ce-j", 
             "gur.27.3-8",
             "her.27.6a7bc",
             "meg.27.7b-k8abd",
             "cod.2127.1f14",
             "her.27.1-24a514a",
             "rja.27.nea",
             "agn.27.nea",
             "cap.27.2a514",
             "spr.27.67a-cf-k",
             "nep.fu.16",
             "whg.27.7b-ce-k",
             "pol.27.89a",
             "pol.27.67",
             "rju.27.7bj",
             "whg.27.89a",
             "ple.27.7bc",
             "ple.27.7h-k",
             "had.27.7b-k",
             "sol.27.7bc",
             "sol.27.7h-k",
             "ple.27.89a",
             "rjh.27.4a6",
             "ghl.27.561214",
             "reb.27.5a14",
             "reg.27.561214",
             "ane.27.8",
             "lin.27.5b",
             "cod.27.7e-k",
             "raj.27.1012",
             "bli.27.5b67",
             "reb.27.14b"
)

### missing elasmo stocks raj.27.67a-ce-h, rjb.27.67a-ce-k, rjb.27.89a
# clean_status_2021 <- format_sag_status(status, 2021, "Oceanic Northeast Atlantic")
# 
# stocks <- clean_status_2021 %>% filter(StockKeyLabel %in% c("raj.27.67a-ce-h", "rjb.27.67a-ce-k", "rjb.27.89a"))#, "", ""))

#adding also ank.27.78abd"
ank <-  clean_status_2021 %>% filter(StockKeyLabel %in% c("ank.27.78abd"))
ank$StockSize <- "GREEN" ##################################################please check these two symbols with Adriana
ank$SBL <- "GREEN"

clean_status_updated <- unique(rbind(clean_status, stocks))
clean_status_updated <- unique(rbind(clean_status_updated, ank))
# clean_status_updated <- clean_status %>% bind_rows(stocks,anti_join(clean_status,stocks,by= c("StockKeyLabel","lineDescription")))
check <- clean_sag %>% filter(StockKeyLabel  %in% c("raj.27.67a-ce-h", "rjb.27.67a-ce-k", "rjb.27.89a", "ank.27.78abd"))#


# dim(clean_status)
# dim(clean_status_updated)
clean_status_updated <- clean_status_updated[order(clean_status_updated$StockKeyLabel),]
########################################################################



clean_sag <- dplyr::filter(clean_sag, !StockKeyLabel %in% ONA_out)
clean_status_updated <- dplyr::filter(clean_status_updated, !StockKeyLabel %in% ONA_out) ### using an updated version of clean_status just to produce the new annex table
# unique(clean_sag$StockKeyLabel)
# unique(clean_status_updated$StockKeyLabel)
setdiff(clean_sag$StockKeyLabel,clean_status_updated$StockKeyLabel)
#[1] "lin.27.3a4a6-91214" "ank.27.78abd"       "rjc.27.8"           "her.27.6aS7bc"
# write.csv(check, file = "ONA_Stock_list.csv")


write.taf(clean_sag, dir = "data", quote = TRUE)
write.taf(clean_status_updated, dir = "data", quote = TRUE)
