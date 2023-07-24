# ---- load packages ----
{
  library(dplyr)
  library(here)
  library(ggplot2)
  library(purrr)
  library(readr)
  library(tidyr)
}

# ---- bring in data ----

dat <- read_rds(here("saved data", 
                     "cleaned_commercial_harvest.rds"))


glimpse(dat)


# ---- data long ---- 
dat_wide <- dat %>% 
  pivot_wider(id_cols = c(species, year), 
              names_from = metric, 
              values_from = "amount"
  ) %>% 
  rename(
    total_weight = `total weight`, 
    total_value = `total value`, 
    total_price = `total price`
  )
dat_wide

dat_filter <- dat %>% 
  filter(metric != "total price")

# ---- data explore -----

ggplot(data = dat_filter, aes(x = year, y = amount, colour = metric)) + 
  geom_point(size = 3) + 
  geom_line(linewidth = 1, aes(group = metric)) + 
  facet_wrap(.~ species, scales = "free_y") + 
  scale_colour_viridis_d(begin = 0.25, end = 0.75, name = "Species") + 
  theme_bw(base_size = 15) + 
  theme(
    panel.background = element_blank(),
    strip.background = element_blank()
  ) + 
  labs(
    x = "Year", 
    y = "Total Amount (g/$)"
  )

