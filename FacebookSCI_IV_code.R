library(fixest)
library(dplyr)

# 1. Pfade & Konfiguration
base_path <- "C:/Users/Martin/Desktop/Github/Master_code/FacebookSCI_IV_results/"
data_path <- "C:/Users/Martin/Desktop/Github/Master_code/Finaldataset/"
years <- 2014:2019
outcomes <- c("Frequent_mental_distress_raw_value_ln", "Poor_mental_health_days_raw_value_ln", 
              "MentalDisordersDeath_ln", "Suicide_ln")

# Ordnerstruktur automatisch anlegen (Jetzt mit "ReducedForm"!)
dirs <- c("OLS", "FirstStage", "2SLS", "Robustness", "ReducedForm")
if (!dir.exists(base_path)) { dir.create(base_path, recursive = TRUE) }
for (d in dirs) { dir.create(paste0(base_path, d), showWarnings = FALSE) }

# Kontrollsets definieren
cont1 <- c("share_15_19_MALE_f","share_15_19_FEM_f","share_20_24_f","share_25_29_f","share_30_34_f",
           "share_35_39_f","share_45_64_f","share_65_over_f", "pop_gr","pop_density_f", "lnarea_f")
cont2 <- c(cont1,"white_pop_f", "black_pop_f", "native_pop_f", "asian_pop_f", "hispanic_pop_f","bls_unemployment_rate_f",
           "census_poverty_f", "sh_emp_information_f", "sh_emp_consre_f", "sh_emp_manufac_f", "census_o25_highschool_f", "census_o25_college_f")
cont3 <- c(cont2,"Poor_physical_health_days_raw_value", "Adult_obesity_raw_value",
           "Frequent_physical_distress_raw_value", "Poor_or_fair_health_raw_value")
cont4 <- c(cont3,"Uninsured_raw_value", "Primary_care_physicians_raw_value",
           "Mental_health_providers_raw_value", "Preventable_hospital_stays_raw_value",
           "Uninsured_adults_raw_value", "Uninsured_children_raw_value", "Health_care_costs_raw_value")
cont5 <- c(cont4, "Food_environment_index_raw_value", "Social_associations_raw_value", 
           "Access_to_exercise_opportunities_raw_value", "Other_primary_care_providers_raw_value", "distance_austin")
cont6 <- c(cont5, "Adult_smoking_raw_value", "Physical_inactivity_raw_value", 
           "Excessive_drinking_raw_value", "Insufficient_sleep_raw_value")

control_sets <- list(cont1=cont1, cont2=cont2, cont3=cont3, cont4=cont4, cont5=cont5, cont6=cont6)

# 2. Schleife über Jahre
for (yr in years) {
  cat("Verarbeite Facebook-Daten für Jahr:", yr, "\n")
  data <- read.csv(paste0(data_path, "Regression", yr, "final.csv"))
  
  ols_list <- list(); fs_robust_list <- list(); iv_list <- list(); rf_list <- list()
  
  # A. First Stage (6 Spalten)
  for (c_name in names(control_sets)) {
    controls <- paste(control_sets[[c_name]], collapse = " + ")
    fs_robust_list[[c_name]] <- feols(as.formula(paste("id ~ sh500m +", controls, "| factor(census_reg) + factor(pop_deciles)")), data = data, cluster = ~state_code)
  }
  
  # B. OLS, IV & Reduced Form (Hauptmodelle mit cont6)
  controls_full <- paste(cont6, collapse = " + ")
  for (y in outcomes) {
    # OLS
    ols_list[[y]] <- feols(as.formula(paste(y, "~ sh500m +", controls_full, "| factor(census_reg) + factor(pop_deciles)")), data = data, cluster = ~state_code)
    
    # IV (2SLS)
    iv_list[[y]]  <- feols(as.formula(paste(y, "~", controls_full, "| factor(census_reg) + factor(pop_deciles) | sh500m ~ id")), data = data, cluster = ~state_code)
    
    # Reduced Form (Outcome direkt auf das Instrument 'id' regrediert)
    rf_list[[y]]  <- feols(as.formula(paste(y, "~ id +", controls_full, "| factor(census_reg) + factor(pop_deciles)")), data = data, cluster = ~state_code)
  }
  
  # C. Robustness (Alle 6 Kontrollsets für IV)
  for (y in outcomes) {
    robust_list <- list()
    for (c_name in names(control_sets)) {
      f_iv <- as.formula(paste(y, "~", paste(control_sets[[c_name]], collapse = " + "), "| factor(census_reg) + factor(pop_deciles) | sh500m ~ id"))
      robust_list[[c_name]] <- feols(f_iv, data = data, cluster = ~state_code)
    }
    etable(robust_list, file = paste0(base_path, "Robustness/Robustness_", y, "_", yr, ".csv"), replace = TRUE, fitstat = c("n", "ivf1"))
  }
  
  # D. Speichern der Tabellen
  etable(fs_robust_list, file = paste0(base_path, "FirstStage/FS_Robust_", yr, ".csv"), replace = TRUE, fitstat = c("n", "f"), keep = "sh500m")
  etable(ols_list, file = paste0(base_path, "OLS/OLS_", yr, ".csv"), replace = TRUE)
  etable(iv_list,  file = paste0(base_path, "2SLS/2SLS_", yr, ".csv"), replace = TRUE, fitstat = c("n", "ivf1"))
  etable(rf_list,  file = paste0(base_path, "ReducedForm/RF_", yr, ".csv"), replace = TRUE)
}