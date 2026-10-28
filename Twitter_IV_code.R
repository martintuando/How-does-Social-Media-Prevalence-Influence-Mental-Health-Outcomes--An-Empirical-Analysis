library(fixest)

base_path    <- "C:/Users/Martin/Desktop/Github/Master_code/Finaldataset/"
results_path <- "C:/Users/Martin/Desktop/Github/Master_code/TwitterIV_results/"

years <- 2014:2019
dep_vars <- c("Poor_mental_health_days_raw_value_ln", "Frequent_mental_distress_raw_value_ln",
              "Suicide_ln", "MentalDisordersDeath_ln")

fe      <- "factor(census_reg) + factor(pop_deciles)"
cluster <- "state_code"

# Variables
endo  <- "twitter_user_unique_ln"
inst  <- "twitter_user_sxsw_fol_Mar07_ln"
pre06 <- "twitter_user_sxsw_fol_pre06_ln"

# Output
if (!dir.exists(results_path)) dir.create(results_path, recursive = TRUE)
for (d in c("OLS", "FirstStage", "2SLS", "Robustness", "ReducedForm")) {
  dir.create(paste0(results_path, d), showWarnings = FALSE)
}

# controlls
cont1 <- c("share_15_19_MALE_f", "share_15_19_FEM_f", "share_20_24_f", "share_25_29_f", "share_30_34_f", "share_35_39_f", "share_45_64_f", "share_65_over_f", "pop_gr", "pop_density_f", "lnarea_f")
cont2 <- c(cont1, "white_pop_f", "black_pop_f", "native_pop_f", "asian_pop_f", "hispanic_pop_f", "bls_unemployment_rate_f", "census_poverty_f", "sh_emp_information_f", "sh_emp_consre_f", "sh_emp_manufac_f", "census_o25_highschool_f", "census_o25_college_f")
cont3 <- c(cont2, "Poor_physical_health_days_raw_value", "Adult_obesity_raw_value", "Frequent_physical_distress_raw_value", "Poor_or_fair_health_raw_value")
cont4 <- c(cont3, "Uninsured_raw_value", "Primary_care_physicians_raw_value", "Mental_health_providers_raw_value", "Preventable_hospital_stays_raw_value", "Uninsured_adults_raw_value", "Uninsured_children_raw_value", "Health_care_costs_raw_value")
cont5 <- c(cont4, "Food_environment_index_raw_value", "Social_associations_raw_value", "Access_to_exercise_opportunities_raw_value", "Other_primary_care_providers_raw_value", "distance_austin")
cont6 <- c(cont5, "Adult_smoking_raw_value", "Physical_inactivity_raw_value", "Excessive_drinking_raw_value", "Insufficient_sleep_raw_value")

control_sets <- list(cont1 = cont1, cont2 = cont2, cont3 = cont3,
                     cont4 = cont4, cont5 = cont5, cont6 = cont6)

plus <- function(x) paste(x, collapse = " + ")
reg  <- function(f, data) feols(as.formula(f), data = data, cluster = cluster)


for (year in years) {
  file <- paste0(base_path, "Regression", year, "final.csv")
  if (!file.exists(file)) {
    cat("FEHLER: Datei nicht gefunden:", file, "\n")
    next
  }
  cat("Verarbeite Twitter-Daten für Jahr:", year, "\n")
  df <- read.csv(file, stringsAsFactors = FALSE)
  
  # first stage
  fs <- list()
  for (s in names(control_sets)) {
    fs[[s]] <- reg(paste(endo, "~", inst, "+", pre06, "+", plus(control_sets[[s]]), "|", fe), df)
  }
  
  ols <- list(); iv <- list(); rf <- list()
  for (dv in dep_vars) {
    ols[[dv]] <- reg(paste(dv, "~", endo, "+", pre06, "+", plus(cont6), "|", fe), df)
    rf[[dv]]  <- reg(paste(dv, "~", inst, "+", pre06, "+", plus(cont6), "|", fe), df)
    
    # 2SLS 
    iv_sets <- list()
    for (s in names(control_sets)) {
      iv_sets[[s]] <- reg(paste(dv, "~", pre06, "+", plus(control_sets[[s]]), "|", fe, "|", endo, "~", inst), df)
    }
    iv[[dv]] <- iv_sets[["cont6"]]
    
    etable(iv_sets, file = paste0(results_path, "Robustness/Robustness_Twitter_", dv, "_", year, ".csv"),
           replace = TRUE, fitstat = c("n", "ivf1"))
  }
  
  etable(fs,  file = paste0(results_path, "FirstStage/FS_Twitter_", year, ".csv"),
         replace = TRUE, order = c(inst), fitstat = c("n", "f"))
  etable(ols, file = paste0(results_path, "OLS/OLS_Twitter_", year, ".csv"), replace = TRUE)
  etable(iv,  file = paste0(results_path, "2SLS/2SLS_Twitter_", year, ".csv"),
         replace = TRUE, fitstat = c("n", "ivf1"))
  etable(rf,  file = paste0(results_path, "ReducedForm/RF_Twitter_", year, ".csv"), replace = TRUE)
}