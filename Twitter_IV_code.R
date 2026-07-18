library(fixest)
library(dplyr)

# 1. Konfiguration & Pfade
base_path <- "C:/Users/Martin/Desktop/Github/Master_code/Finaldataset/"
results_path <- "C:/Users/Martin/Desktop/Github/Master_code/TwitterIV_results/"
years <- 2014:2019
dep_vars <- c("Poor_mental_health_days_raw_value_ln", "Frequent_mental_distress_raw_value_ln", 
              "Suicide_ln", "MentalDisordersDeath_ln")

fixed_effects <- "factor(census_reg) + factor(pop_deciles)"
cluster_var   <- "state_code"

# Ordnerstruktur automatisch anlegen (Jetzt mit "ReducedForm"!)
dirs <- c("OLS", "FirstStage", "2SLS", "Robustness", "ReducedForm")
if (!dir.exists(results_path)) { dir.create(results_path, recursive = TRUE) }
for (d in dirs) { dir.create(paste0(results_path, d), showWarnings = FALSE) }

# Kontrollsets
cont1 <- c("share_15_19_MALE_f", "share_15_19_FEM_f", "share_20_24_f", "share_25_29_f", "share_30_34_f", "share_35_39_f", "share_45_64_f", "share_65_over_f", "pop_gr", "pop_density_f", "lnarea_f")
cont2 <- c(cont1, "white_pop_f", "black_pop_f", "native_pop_f", "asian_pop_f", "hispanic_pop_f", "bls_unemployment_rate_f", "census_poverty_f", "sh_emp_information_f", "sh_emp_consre_f", "sh_emp_manufac_f", "census_o25_highschool_f", "census_o25_college_f")
cont3 <- c(cont2, "Poor_physical_health_days_raw_value", "Adult_obesity_raw_value", "Frequent_physical_distress_raw_value", "Poor_or_fair_health_raw_value")
cont4 <- c(cont3, "Uninsured_raw_value", "Primary_care_physicians_raw_value", "Mental_health_providers_raw_value", "Preventable_hospital_stays_raw_value", "Uninsured_adults_raw_value", "Uninsured_children_raw_value", "Health_care_costs_raw_value")
cont5 <- c(cont4, "Food_environment_index_raw_value", "Social_associations_raw_value", "Access_to_exercise_opportunities_raw_value", "Other_primary_care_providers_raw_value", "distance_austin")
cont6 <- c(cont5, "Adult_smoking_raw_value", "Physical_inactivity_raw_value", "Excessive_drinking_raw_value", "Insufficient_sleep_raw_value")

control_sets <- list(cont1=cont1, cont2=cont2, cont3=cont3, cont4=cont4, cont5=cont5, cont6=cont6)

# 2. Schleife über Jahre
for (year in years) {
  file_path <- paste0(base_path, "Regression", year, "final.csv")
  
  if(file.exists(file_path)) {
    cat("Verarbeite Twitter-Daten für Jahr:", year, "\n")
    df <- read.csv(file_path, stringsAsFactors = FALSE)
    
    iv_models <- list(); fs_models <- list(); ols_models <- list(); rf_models <- list()
    
    # A. First Stage (6 Spalten)
    for (c_name in names(control_sets)) {
      controls <- paste(control_sets[[c_name]], collapse = " + ")
      fs_formula <- as.formula(paste("twitter_user_unique_ln ~ twitter_user_sxsw_fol_Mar07_ln + twitter_user_sxsw_fol_pre06_ln +", controls, "|", fixed_effects))
      fs_models[[c_name]] <- feols(fs_formula, data = df, cluster = cluster_var)
    }
    
    # B. OLS, IV & Reduced Form (mit cont6)
    controls_full <- paste(cont6, collapse = " + ")
    for (dv in dep_vars) {
      # OLS
      f_ols <- as.formula(paste(dv, "~ twitter_user_unique_ln + twitter_user_sxsw_fol_pre06_ln +", controls_full, "|", fixed_effects))
      ols_models[[dv]] <- feols(f_ols, data = df, cluster = cluster_var)
      
      # IV (2SLS)
      f_2sls <- as.formula(paste(dv, "~ twitter_user_sxsw_fol_pre06_ln +", controls_full, "|", fixed_effects, "| twitter_user_unique_ln ~ twitter_user_sxsw_fol_Mar07_ln"))
      iv_models[[dv]] <- feols(f_2sls, data = df, cluster = cluster_var)
      
      # Reduced Form (Outcome direkt auf das Instrument regrediert)
      f_rf <- as.formula(paste(dv, "~ twitter_user_sxsw_fol_Mar07_ln + twitter_user_sxsw_fol_pre06_ln +", controls_full, "|", fixed_effects))
      rf_models[[dv]] <- feols(f_rf, data = df, cluster = cluster_var)
    }
    
    # C. Robustness (Alle 6 Kontrollsets für IV)
    for (dv in dep_vars) {
      robust_list <- list()
      for (c_name in names(control_sets)) {
        f_iv <- as.formula(paste(dv, "~ twitter_user_sxsw_fol_pre06_ln +", paste(control_sets[[c_name]], collapse = " + "), "|", fixed_effects, "| twitter_user_unique_ln ~ twitter_user_sxsw_fol_Mar07_ln"))
        robust_list[[c_name]] <- feols(f_iv, data = df, cluster = cluster_var)
      }
      etable(robust_list, file = paste0(results_path, "Robustness/Robustness_Twitter_", dv, "_", year, ".csv"), replace = TRUE, fitstat = c("n", "ivf1"))
    }
    
    # D. Export
    etable(fs_models, file = paste0(results_path, "FirstStage/FS_Twitter_", year, ".csv"), replace = TRUE, order = c("twitter_user_sxsw_fol_Mar07_ln"), fitstat = c("n", "f"))
    etable(ols_models, file = paste0(results_path, "OLS/OLS_Twitter_", year, ".csv"), replace = TRUE)
    etable(iv_models, file = paste0(results_path, "2SLS/2SLS_Twitter_", year, ".csv"), replace = TRUE, fitstat = c("n", "ivf1"))
    etable(rf_models, file = paste0(results_path, "ReducedForm/RF_Twitter_", year, ".csv"), replace = TRUE)
    
  } else {
    cat("FEHLER: Datei nicht gefunden:", file_path, "\n")
  }
}