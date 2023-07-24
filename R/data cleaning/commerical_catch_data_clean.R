# ---- load packages ----
{
  library(dplyr)
  library(here)
  library(purrr)
  library(readr)
  library(tidyr)
}

# ---- bring in data ---- 

dat <- read_csv(here("data", 
                     "commercial catch lobby", 
                     "2022-lake-ontario-stats.csv")) %>% 
  janitor::clean_names()


# ---- understand data structure ---- 

str(dat)
glimpse(dat)

# before we make it long we need to move the year name up 

names(dat) <- paste(colnames(dat), unlist(dat[1,]), sep = "_")
dat <- dat[-1,]
str(dat)
glimpse(dat)

# ----- pivot long ----

dat <- dat %>% 
  pivot_longer(
    cols = -species_NA, 
    names_to = "metric",
    values_to = "amount"
  ) %>% 
  rename(
    species = species_NA
  ) %>% 
  separate(metric, into = c("name_1", "name_2", "number", "year"), sep = "_")


# ---- clean up this mess ----
dat <- dat %>% 
  mutate(
    year = case_when(
      is.na(year) ~ "2022", 
      TRUE ~ year
    ), 
    year = as.numeric(year), 
    metric = paste(name_1, name_2, sep = " ")
  ) %>% 
  dplyr::select(species, metric, year, amount)
dat
# ---- save as rds ----

write_rds(dat, here("saved data", 
               "cleaned_commercial_harvest.rds"))



