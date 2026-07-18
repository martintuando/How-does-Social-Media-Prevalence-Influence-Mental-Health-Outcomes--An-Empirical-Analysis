
library(readr)   
library(dplyr)

path <- "C:/Users/Martin/Desktop/Github/Master_code/data"


years <- 2015:2025
for (year in years) {
  file_path <- file.path(path, paste0("analytic_data", year, ".csv"))  #
  df <- read_csv(file_path)
  assign(paste0("analytic_data", year), df)
}

#############################2017analyticdata ausnahme##############################

analytic_data2017 <- analytic_data2017[-2463, ]

start_col <- which(names(analytic_data2017) == "Release Year")


from_row <- 2463
to_row <- 2457


for (i in start_col:ncol(analytic_data2017)) {
  if (is.na(analytic_data2017[to_row, i])) {
    analytic_data2017[to_row, i] <- analytic_data2017[from_row, i]
  }
}


##################################################2017############################################################

#remove alaska and hawai
Countyhealth2017 <- analytic_data2017[-c(1, 2), ]
Countyhealth2017 <- Countyhealth2017[Countyhealth2017$`County FIPS Code` != "000", ]
Countyhealth2017 <- Countyhealth2017[!(Countyhealth2017$`State FIPS Code` %in% c("02", "15")), ]


Countyhealth2017 <-Countyhealth2017[Countyhealth2017$"5-digit FIPS Code"!= "51515", ]
sum(Countyhealth2017$"5-digit FIPS Code" == "46113")
Countyhealth2017$"5-digit FIPS Code"[Countyhealth2017$"5-digit FIPS Code" == "46113"] <- "46102"
sum(Countyhealth2017$"5-digit FIPS Code" == "46102")


Countyhealth2017$"State Abbreviation" <- NULL
Countyhealth2017$Name <- NULL
Countyhealth2017$"Release Year" <- NULL
Countyhealth2017$"County Ranked (Yes=1/No=0)" <- NULL



Countyhealth2017 <- Countyhealth2017 %>%
  select(-matches("CI low|CI high"))
Countyhealth2017 <- Countyhealth2017 %>%
  select(-matches("numerator|denominator"))


Countyhealth2017 <- Countyhealth2017 %>%
  select(-matches("AIAN|Asian/Pacific Islander|Black|Hispanic|White"))

###############################Für die restlichen Jahre###########################################


# Jahre definieren
years <- 2015:2025

for (year in years) {
  
  df <- get(paste0("analytic_data", year))
  

  df <- df[-c(1, 2), ]
  df <- df[df$`County FIPS Code` != "000", ]
  df <- df[!(df$`State FIPS Code` %in% c("02", "15")), ]
  

  df <- df[df$`5-digit FIPS Code` != "51515", ]
  df$`5-digit FIPS Code`[df$`5-digit FIPS Code` == "46113"] <- "46102"
 
  df$`State Abbreviation` <- NULL
  df$Name <- NULL
  df$`Release Year` <- NULL
  df$`County Ranked (Yes=1/No=0)` <- NULL
  
  
  df <- df %>%
    select(
      -matches("CI low|CI high"),
      -matches("numerator|denominator"),
      -matches("AIAN|Asian/Pacific Islander|Black|Hispanic|White")
    )
  
  # Spalten mit mehr als 1500 NAs entfernen
  df <- df[, colSums(is.na(df)) <= 1500]
  
  # --- Ergebnis speichern ---
  assign(paste0("Countyhealth", year), df)
}


###################################Final Data##########################
####################2014#####################
Finalcountyhealth2014 <- bind_cols(
  select(Countyhealth2017,
         "5-digit FIPS Code",  
         "Uninsured raw value",
         "Primary care physicians raw value",
         "Social associations raw value",
         "Premature age-adjusted mortality raw value",
         "Preventable hospital stays raw value" ,     
         "Uninsured adults raw value", 
         "Uninsured children raw value",
         "Health care costs raw value",
         "Food environment index raw value"
  ),
  
  select(Countyhealth2016,
         "Poor or fair health raw value",
         "Poor physical health days raw value",
         "Poor mental health days raw value",
         "Excessive drinking raw value",   
         "Frequent physical distress raw value",
         "Frequent mental distress raw value",
         "Insufficient sleep raw value",
         "Adult smoking raw value",
         "Access to exercise opportunities raw value",
  ),
  
  select(Countyhealth2015,
         "Mental health providers raw value",
         "Other primary care providers raw value"
  ),
  
  select(Countyhealth2018,
         "Adult obesity raw value",
         "Physical inactivity raw value",
         "Premature death raw value"
  ),
  select(Countyhealth2020,
         "Suicides raw value",
         "Crude suicide rate"
  )
  
)
####################2015#####################
Finalcountyhealth2015 <- bind_cols(
  select(Countyhealth2018,
         "5-digit FIPS Code",  
         "Uninsured raw value",
         "Primary care physicians raw value",
         "Social associations raw value",
         "Premature age-adjusted mortality raw value",
         "Preventable hospital stays raw value" ,     
         "Uninsured adults raw value", 
         "Uninsured children raw value",
         "Health care costs raw value",
         "Food environment index raw value"
  ),
  
  select(Countyhealth2017,
         "Poor or fair health raw value",
         "Poor physical health days raw value",
         "Poor mental health days raw value",
         "Excessive drinking raw value",   
         "Frequent physical distress raw value",
         "Frequent mental distress raw value",
         "Drug overdose deaths raw value" ,
         "Insufficient sleep raw value",
         "Adult smoking raw value",
         "Access to exercise opportunities raw value",
  ),
  
  select(Countyhealth2016,
         "Mental health providers raw value",
         "Other primary care providers raw value"
  ),
  
  select(Countyhealth2019,
         "Adult obesity raw value",
         "Physical inactivity raw value",
         "Premature death raw value"
  ),
  select(Countyhealth2021,
         "Suicides raw value",
         "Crude suicide rate"
  )
  
)
####################2016#####################
Finalcountyhealth2016 <- bind_cols(
  select(Countyhealth2019,
         "5-digit FIPS Code",  
         "Uninsured raw value",
         "Primary care physicians raw value",
         "Social associations raw value",
         "Premature age-adjusted mortality raw value",
         "Preventable hospital stays raw value" ,     
         "Uninsured adults raw value", 
         "Uninsured children raw value",
         "Food environment index raw value"
  ),
   
  select(Countyhealth2018,
         "Poor or fair health raw value",
         "Poor physical health days raw value",
         "Poor mental health days raw value",
         "Excessive drinking raw value",   
         "Frequent physical distress raw value",
         "Frequent mental distress raw value",
         "Drug overdose deaths - modeled raw value" ,
         "Insufficient sleep raw value",
         "Adult smoking raw value",
         "Access to exercise opportunities raw value",
  ),
  
  select(Countyhealth2017,
         "Mental health providers raw value",
         "Other primary care providers raw value"
  ),
  
  select(Countyhealth2020,
         "Adult obesity raw value",
         "Physical inactivity raw value",
         "Premature death raw value"
  ),
  select(Countyhealth2022,
         "Suicides raw value",
         "Crude suicide rate"
  )
  
)
####################2017#####################
Finalcountyhealth2017 <- bind_cols(
  select(Countyhealth2020,
         "5-digit FIPS Code",  
         "Uninsured raw value",
         "Primary care physicians raw value",
         "Social associations raw value",
         "Premature age-adjusted mortality raw value",
         "Preventable hospital stays raw value" ,     
         "Uninsured adults raw value", 
         "Uninsured children raw value",
         "Food environment index raw value",         
         "Poor or fair health raw value",
         "Poor physical health days raw value",
         "Poor mental health days raw value",
         "Excessive drinking raw value",   
         "Frequent physical distress raw value",
         "Frequent mental distress raw value",
         "Insufficient sleep raw value",
         "Adult smoking raw value",
  ),
  
  select(Countyhealth2019,
         
         "Access to exercise opportunities raw value",
  ),
  
  select(Countyhealth2018,
         "Mental health providers raw value",
         "Other primary care providers raw value"
  ),
  
  select(Countyhealth2021,
         "Adult obesity raw value",
         "Physical inactivity raw value"
         
  ),
  
)

Finalcountyhealth2018 <- bind_cols(
  select(Countyhealth2021,
         "5-digit FIPS Code",  
         "Uninsured raw value",
         "Primary care physicians raw value",
         "Social associations raw value",
         "Premature age-adjusted mortality raw value",
         "Preventable hospital stays raw value" ,     
         "Uninsured adults raw value", 
         "Uninsured children raw value",
         "Food environment index raw value",
         "Poor or fair health raw value",
         "Poor physical health days raw value",
         "Poor mental health days raw value",
         "Excessive drinking raw value",   
         "Frequent physical distress raw value",
         "Frequent mental distress raw value",
         "Insufficient sleep raw value",
         "Adult smoking raw value",
  ),
   
  select(Countyhealth2020,
         
         "Access to exercise opportunities raw value",
  ),
  
  select(Countyhealth2019,
         "Mental health providers raw value",
         "Other primary care providers raw value"
  ),
  
  select(Countyhealth2022,
         "Adult obesity raw value",
         "Physical inactivity raw value"
         
  ),
  
)
####################2019#####################
Finalcountyhealth2019 <- bind_cols(
  select(Countyhealth2022,
         "5-digit FIPS Code",  
         "Uninsured raw value",
         "Primary care physicians raw value",
         "Social associations raw value",
         "Premature age-adjusted mortality raw value",
         "Preventable hospital stays raw value" ,     
         "Uninsured adults raw value", 
         "Uninsured children raw value",
         "Food environment index raw value",         
         "Poor or fair health raw value",
         "Poor physical health days raw value",
         "Poor mental health days raw value",
         "Excessive drinking raw value",   
         "Frequent physical distress raw value",
         "Frequent mental distress raw value",
         "Insufficient sleep raw value",
         "Adult smoking raw value",
  ),
  
  select(Countyhealth2021,
         
         "Access to exercise opportunities raw value",
  ),
  
  select(Countyhealth2020,
         "Mental health providers raw value",
         "Other primary care providers raw value"
  ),
  
  select(Countyhealth2023,
         "Adult Obesity raw value",
         "Physical Inactivity raw value" 
  ),
  
)

##########################################################################
###################Data Imputation#######################
##########################################################################

library(dplyr)
library(mice)


##########################################################################

for (year in 2014:2019) {
  df_name <- paste0("Finalcountyhealth", year)
  df <- get(df_name)
  
  column <- "Other primary care providers raw value"
  if (column %in% names(df)) {
    df[[column]][is.na(df[[column]])] <- 0
    assign(df_name, df)
  } else {
    warning(paste("Spalte fehlt in:", df_name))
  }
}
for (year in 2014:2019) {
  df_name <- paste0("Finalcountyhealth", year)
  df <- get(df_name)
  
  column <- "Access to exercise opportunities raw value"
  if (column %in% names(df)) {
    df[[column]][is.na(df[[column]])] <- 0
    assign(df_name, df)
  } else {
    warning(paste("Spalte fehlt in:", df_name))
  }
}
for (year in 2014:2019) {
  df_name <- paste0("Finalcountyhealth", year)
  df <- get(df_name)
  
  column <- "Mental health providers raw value"
  if (column %in% names(df)) {
    df[[column]][is.na(df[[column]])] <- 0
    assign(df_name, df)
  } else {
    warning(paste("Spalte fehlt in:", df_name))
  }
}
for (year in 2014:2019) {
  df_name <- paste0("Finalcountyhealth", year)
  df <- get(df_name)
  
  column <- "Primary care physicians raw value"
  if (column %in% names(df)) {
    df[[column]][is.na(df[[column]])] <- 0
    assign(df_name, df)
  } else {
    warning(paste("Spalte fehlt in:", df_name))
  }
}
###################################MICE Imputation#######################################


cat("\nStarte MICE Imputation mit Methode 'rf' und 20 Iterationen...\n")
mice_result <- mice(Finalcountyhealth2014 %>% select(-`5-digit FIPS Code`), 
                    m = 5, maxit = 20, method = 'rf', printFlag = FALSE)

cat("\nImputation abgeschlossen. Das mice_result-Objekt enthält 5 vollständige Datensätze.\n")


completed_data_1 <- complete(mice_result, action = 1)


cat("\nÜberprüfung der NA-Werte nach der Imputation:\n")
na_counts <- colSums(is.na(completed_data_6))
print(na_counts[c("Preventable hospital stays raw value", 
                  "Food environment index raw value", 
                  "Health care costs raw value")])


completed_data_6 <- completed_data_6 %>%
  mutate(`5-digit FIPS Code` = Finalcountyhealthimputed2019$`5-digit FIPS Code`) %>%
  select(`5-digit FIPS Code`, everything())

cat("\nDie ersten Zeilen des ersten imputierten Datensatzes:\n")
print(head(completed_data_6))

#########################################################################

for (year in 2014:2019) {
  df_name <- paste0("Finalcountyhealth", year)
  df <- get(df_name)
  
  filepath <- paste0("C:/Users/Martin/Desktop/Github/Master_code/data/countyhealthfinal/Finalcountyhealthimputed", year, ".csv")
  write.csv(df, file = filepath, row.names = FALSE)
}