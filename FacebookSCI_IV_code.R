library(fixest)

results_path <- "C:/Users/Martin/Desktop/Github/Master_code/FacebookSCI_IV_results/"
data_path    <- "C:/Users/Martin/Desktop/Github/Master_code/Finaldataset/"

years <- 2014:2019
outcomes <- c("Frequent_mental_distress_raw_value_ln", "Poor_mental_health_days_raw_value_ln",
              "MentalDisordersDeath_ln", "Suicide_ln")

fe <- "factor(census_reg) + factor(pop_deciles)"

# Ordner anlegen falls nicht da
if (!dir.exists(results_path)) dir.create(results_path, recursive = TRUE)
for (d in c("OLS", "FirstStage", "2SLS", "Robustness", "ReducedForm")) {
  dir.create(paste0(results_path, d), showWarnings = FALSE)
}

# Kontrollsets, jedes baut auf dem davor auf
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

control_sets <- list(cont1 = cont1, cont2 = cont2, cont3 = cont3,
                     cont4 = cont4, cont5 = cont5, cont6 = cont6)

plus <- function(x) paste(x, collapse = " + ")
reg  <- function(f, data) feols(as.formula(f), data = data, cluster = ~state_code)


for (yr in years) {
  cat("Verarbeite Facebook-Daten für Jahr:", yr, "\n")
  df <- read.csv(paste0(data_path, "Regression", yr, "final.csv"))
  
  # first stage ueber alle Kontrollsets
  fs <- list()
  for (s in names(control_sets)) {
    fs[[s]] <- reg(paste("id ~ sh500m +", plus(control_sets[[s]]), "|", fe), df)
  }
  
  ols <- list(); iv <- list(); rf <- list()
  for (y in outcomes) {
    ols[[y]] <- reg(paste(y, "~ sh500m +", plus(cont6), "|", fe), df)
    rf[[y]]  <- reg(paste(y, "~ id +", plus(cont6), "|", fe), df)
    
    # 2SLS mit allen Kontrollsets, cont6 ist das Hauptmodell
    iv_sets <- list()
    for (s in names(control_sets)) {
      iv_sets[[s]] <- reg(paste(y, "~", plus(control_sets[[s]]), "|", fe, "| sh500m ~ id"), df)
    }
    iv[[y]] <- iv_sets[["cont6"]]
    
    etable(iv_sets, file = paste0(results_path, "Robustness/Robustness_", y, "_", yr, ".csv"),
           replace = TRUE, fitstat = c("n", "ivf1"))
  }
  
  etable(fs,  file = paste0(results_path, "FirstStage/FS_Robust_", yr, ".csv"),
         replace = TRUE, fitstat = c("n", "f"), keep = "sh500m")
  etable(ols, file = paste0(results_path, "OLS/OLS_", yr, ".csv"), replace = TRUE)
  etable(iv,  file = paste0(results_path, "2SLS/2SLS_", yr, ".csv"),
         replace = TRUE, fitstat = c("n", "ivf1"))
  etable(rf,  file = paste0(results_path, "ReducedForm/RF_", yr, ".csv"), replace = TRUE)
}
