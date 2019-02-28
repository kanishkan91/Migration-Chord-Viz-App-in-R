library(htmlwidgets)
# create widget scaffolding
scaffoldWidget("chord_expand", edit = FALSE)

# install package so we can test it
devtools::install()


library(tidyverse)
library(jsonlite)
d0 <- read_csv("E:\\ADRI\\project\\gfest4\\est\\gf_od.csv", guess_max = 1e6)
d1 <- read_csv("E:\\ADRI\\project\\gfest4\\est\\country_list.csv")
d2 <- read_csv("E:\\ADRI\\project\\gfest4\\plot-cd\\reg_meta.csv")

source("./R/tidy_mig_to_json.R")
source("./R/chord_expand.R")

j0 <- tidy_mig_to_json(
  df_flow = d0 %>%
    rename(flow = da_min_closed) %>%
    select(year0, orig, dest, flow),
  df_region = d1 %>%
    select(alpha3, name, un_region) %>%
    rename(region = un_region),
  region_names = d2$reg_name,
  region_label1 = d2$reg_name,
  region_label2 = rep(NA, 19),
  # region_label2 = d2$reg_name,
  # region_label1 = d2$reg_lab1,
  # region_label2 = d2$reg_lab2,
  region_col = d2$col2
  )

chord_expand(j0, year = 2010)
