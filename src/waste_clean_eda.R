suppressPackageStartupMessages(library(tidyverse))

eu_waste_df <- read.csv('eu-waste.csv', stringsAsFactors = F)

eu_waste_subset <- eu_waste_df %>% 
  filter(GEO == "European Union - 28 countries" & 
           WASTE == 'Animal and mixed food waste; vegetal wastes (W091+W092)' &
           HAZARD == 'Hazardous and non-hazardous - Total') %>% 
  select(TIME, Value, UNIT) %>% 
  mutate(Value = as.numeric(gsub(",","",eu_waste_subset$Value)))

eu_waste_subset %>% 
  ggplot(aes(TIME, Value)) +
  geom_line()

write.csv(eu_waste_subset, "eu_waste_filtered.csv")

#EU Waste Data:

#https://ec.europa.eu/eurostat/data/database
#https://ec.europa.eu/eurostat/cache/metadata/en/env_wasgt_esms.htm

