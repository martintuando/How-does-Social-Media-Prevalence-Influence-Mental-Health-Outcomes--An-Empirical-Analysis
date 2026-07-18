library(dplyr)
library(tidyverse)


# Names
subset_vars <- c(
 "5-digit_FIPS_Code","share_20_24", "share_25_29", "share_30_34", "share_35_39", "share_40_44",
  "share_45_49", "share_50_over", "pop_gr","pop2016",
  "white_pop", "black_pop", "native_pop", "asian_pop", "hispanic_pop",
  "bls_unemployment_rate", "census_poverty",
  "sh_emp_information", "sh_emp_consre", "sh_emp_manufac",
  "census_o25_highschool", "census_o25_college",
  "pop_density", "lnarea"
)


Controlls_subset <- Regression2014[, subset_vars]

names(Controlls_subset)

#Data adjustments
CC_EST2020_AGESEX_ALL <- CC_EST2020_AGESEX_ALL %>%
  mutate(
    STATE = str_pad(STATE, width = 2, pad = "0", side = "left"),
    COUNTY = str_pad(COUNTY, width = 3, pad = "0", side = "left")
  )


CC_EST2020_AGESEX_ALL <- CC_EST2020_AGESEX_ALL %>%
  mutate(
    
    `5-digit_Fips_Code` = str_c(STATE, COUNTY)
  )
data_df <- CC_EST2020_AGESEX_ALL
CC_EST2020_AGESEX_ALL <- CC_EST2020_AGESEX_ALL %>%
  mutate(YEAR = as.numeric(YEAR)) %>%
  filter(YEAR >= 7 & YEAR <= 12)




data_df <- data_df %>%
  mutate(YEAR = as.numeric(YEAR)) %>%
  filter(YEAR >= 7 & YEAR <= 12)


year_mapping <- c(
  "7" = "2014",
  "8" = "2015",
  "9" = "2016",
  "10" = "2017",
  "11" = "2018",
  "12" = "2019"
)

for (year_code in as.character(7:12)) {
  temp_df <- data_df %>%
    filter(as.character(YEAR) == year_code)
  
  dataset_name <- paste0("AGESEX", year_mapping[year_code])
  
  assign(dataset_name, temp_df)
}




#  for the case AGESEX2019 
AGESEX2019 <- AGESEX2019 %>%
  mutate(
    share_15_19 = AGE1519_TOT / POPESTIMATE,
    share_15_19_MALE = AGE1519_MALE / POPESTIMATE,
    share_15_19_FEM  = AGE1519_FEM / POPESTIMATE,
    share_20_24 = AGE2024_TOT / POPESTIMATE,
    share_20_24_MALE = AGE2024_MALE / POPESTIMATE,
    share_20_24_FEM = AGE2024_FEM / POPESTIMATE,
    share_25_29 = AGE2529_TOT / POPESTIMATE,
    share_25_29_MALE = AGE2529_MALE / POPESTIMATE,
    share_25_29_FEM = AGE2529_FEM / POPESTIMATE,
    share_30_34 = AGE3034_TOT / POPESTIMATE,
    share_35_39 = AGE3539_TOT / POPESTIMATE,
    share_40_44 = AGE4044_TOT / POPESTIMATE,
    share_45_64 = AGE4564_TOT / POPESTIMATE,
    share_65PLUS = AGE65PLUS_TOT / POPESTIMATE,
    )




AGESEX2019 <- AGESEX2019 %>%
  select(
    `5-digit_Fips_Code`,
    share_15_19, share_20_24, share_25_29,
    share_30_34, share_35_39, share_40_44,
    share_15_19_MALE, share_15_19_FEM, share_20_24_MALE, share_20_24_FEM,
    share_25_29_MALE, share_25_29_FEM,
    share_45_64, share_65PLUS, POPESTIMATE
  )

###########################################################################################
###########################################################################################


CC_EST2020_ALLDATA <- CC_EST2020_ALLDATA %>%
  mutate(
    
    `5-digit_Fips_Code` = str_c(STATE, COUNTY)
  )

data_df <- CC_EST2020_ALLDATA


data_df <- data_df %>%
  mutate(YEAR = as.numeric(YEAR)) %>%
  filter(YEAR >= 7 & YEAR <= 12)

data_df <- data_df %>%
  filter(AGEGRP == 0)



year_mapping <- c(
  "7" = "2014",
  "8" = "2015",
  "9" = "2016",
  "10" = "2017",
  "11" = "2018",
  "12" = "2019"
)

for (year_code in as.character(7:12)) {
  temp_df <- data_df %>%
    filter(as.character(YEAR) == year_code)
  
  dataset_name <- paste0("RACE", year_mapping[year_code])
  
  assign(dataset_name, temp_df)
}




dataset_names <- paste0("RACE", 2014:2019)


for (name in dataset_names) {
  
  df_temp <- get(name)
  
  
  df_calculated <- df_temp %>%
    mutate(
      
      share_white_pop = (`NHWA_MALE` + `NHWA_FEMALE`) / TOT_POP,
      share_black_pop = (`NHBA_MALE` + `NHBA_FEMALE`) / TOT_POP,
      share_native_pop = (`NHIA_MALE` + `NHIA_FEMALE`) / TOT_POP,
      share_asian_pop = (`NHAA_MALE` + `NHAA_FEMALE`) / TOT_POP,
      share_hispanic_pop = (`H_MALE` + `H_FEMALE`) / TOT_POP
    )
  
  
  assign(name, df_calculated, envir = .GlobalEnv)
}


# Variables
AGESEX2019 <- AGESEX2019 %>%
  select(
    `5-digit_Fips_Code`,
    share_15_19, share_20_24, share_25_29,
    share_30_34, share_35_39, share_40_44,
    share_15_19_MALE, share_15_19_FEM, share_20_24_MALE, share_20_24_FEM,
    share_25_29_MALE, share_25_29_FEM,
    share_45_64, share_65PLUS, POPESTIMATE
  )




# for every year
for (year in 2014:2019) {
  
  agesex_name <- paste0("AGESEX", year)
  race_name <- paste0("RACE", year)
  
  
  agesex_df <- get(agesex_name)
  race_df <- get(race_name)
  
  
  merged_df <- agesex_df %>%
    left_join(
      race_df %>% select(`5-digit_Fips_Code`, share_white_pop, share_black_pop, share_native_pop, share_asian_pop, share_hispanic_pop),
      by = "5-digit_Fips_Code"
    )
  
  
  assign(agesex_name, merged_df, envir = .GlobalEnv)
}

# Education (ACS S1501)

edu2014 <- ACSST5Y2014_S1501_Data %>%
  select(
    `GEO_ID`,
    `S1501_C01_001E`, #  25+
    `S1501_C01_006E`, # High School-Abschluss
    `S1501_C01_009E`, # High School or higher
    `S1501_C01_010E`  # Some College oder Associate's Degree
  ) %>%
  
  mutate(
    `5-digit_Fips_Code` = str_sub(GEO_ID, start = -5)
  )



# convert to numeric
edu2018 <- edu2018%>%
  mutate(
    `S1501_C01_001E` = as.numeric(gsub(",", "", `S1501_C01_001E`)),
    `S1501_C01_006E` = as.numeric(gsub(",", "", `S1501_C01_006E`)),
    `S1501_C01_009E` = as.numeric(gsub(",", "", `S1501_C01_009E`)),
    `S1501_C01_010E` = as.numeric(gsub(",", "", `S1501_C01_010E`))
  )

# shares
edu2018 <- edu2018 %>%
  mutate(
    share_high_school_or_higher = `S1501_C01_009E` / `S1501_C01_006E`,
    share_some_college = `S1501_C01_010E` / `S1501_C01_006E`
  )




library(tidyverse)


AGESEX2014 <- AGESEX2014 %>%
  left_join(Controlls_subset %>% select(`5-digit_Fips_Code`, pop_gr),
            by = "5-digit_Fips_Code")






write.csv(AGESEX2019, file = "C:/Users/Martin/Desktop/Github/Master_code/data/controllsfinal/AGESEX2019.csv", row.names = FALSE)
write.csv(AGESEX2018, file = "C:/Users/Martin/Desktop/Github/Master_code/data/controllsfinal/AGESEX2018.csv", row.names = FALSE)
write.csv(AGESEX2017, file = "C:/Users/Martin/Desktop/Github/Master_code/data/controllsfinal/AGESEX2017.csv", row.names = FALSE)
write.csv(AGESEX2016, file = "C:/Users/Martin/Desktop/Github/Master_code/data/controllsfinal/AGESEX2016.csv", row.names = FALSE)
write.csv(AGESEX2015, file = "C:/Users/Martin/Desktop/Github/Master_code/data/controllsfinal/AGESEX2015.csv", row.names = FALSE)
write.csv(AGESEX2014, file = "C:/Users/Martin/Desktop/Github/Master_code/data/controllsfinal/AGESEX2014.csv", row.names = FALSE)



