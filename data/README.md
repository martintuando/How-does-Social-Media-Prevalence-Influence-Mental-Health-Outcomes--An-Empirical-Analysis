How does Social Media Prevalence 
Influence Mental Health Outcomes?  
An Empirical Analysis

This repository contains the replication package, empirical workflow, and analysis scripts for a Master's thesis examining the causal impact of social media exposure on mental health across $3,108$ U.S. counties.

To address the fundamental challenge of endogeneity in estimating the causal effect of social media on mental health, the empirical framework leverages two distinct quasi-natural experiments using a Two-Stage Least Squares (2SLS) Instrumental Variable (IV) design.

1. Project & Data Overview

The analysis links county-level social media exposure to health outcomes across 50 states. The dataset integrates multiple high-resolution data sources:

Mental Health Outcomes:

Self-reported measures of physical health, mental health, and health behaviors from the Behavioral Risk Factor Surveillance System (BRFSS).

Mortality metrics (Suicides and Mental/Behavioral disorders leading to death) from the CDC WONDER database.

Social Media Measures:

Twitter Usage: Proxy derived from an archive of 475 million geo-located tweets compiled by Kinder-Kurlanda et al. (2017) and mapped to counties by Fujiwara et al. (2021).

Facebook Social Connectedness Index (SCI): Anonymized Facebook friendship networks indicating geographic density (specifically the share of a county's Facebook friends living within 500 miles, standardized to a Z-score) published by Bailey et al. (2018).

County-Level Covariates:

Socioeconomic and demographic controls from the U.S. Census, U.S. Religious Census, American Community Survey (ACS), and Bureau of Labor Statistics (BLS).

Health-related characteristics from the Centers for Medicare & Medicaid Services (CMS), National Provider Identification (NPI), Small Area Health Insurance Estimates (SAHIE), and the CDC Diabetes Interactive Atlas.

2. Quasi-Natural Experiment 1: Twitter Rollout (SXSW 2007)

This empirical framework exploits the early adoption shock of Twitter during the 2007 South by Southwest (SXSW) festival in Austin, Texas as a source of exogenous spatial variation in long-term platform diffusion (following Fujiwara, Müller, and Schwarz, 2021).

To ensure that the instrument is not capturing general county-level interest in tech/culture festivals, the design controls for interest in Twitter prior to the festival using a "placebo" control group ($\text{SXSW}_c^{\text{Pre}}$).

Model Specifications

The first-stage regression models the relationship between the instrument and the endogenous variable (Twitter adoption intensity):

$$\ln(\text{Twitter Adoption}_c + 1) = \alpha_0 + \alpha_1 \ln(\text{SXSW}_c^{\text{March2007}} + 1) + \alpha_2 \ln(\text{SXSW}_c^{\text{Pre}} + 1) + \alpha_3 X_c + \varepsilon_c$$

The reduced-form regression directly tests the link between the exogenous shock and mental health outcomes:

$$\ln(\text{Mental Health}_c + 1) = \gamma_0 + \gamma_1 \ln(\text{SXSW}_c^{\text{March2007}} + 1) + \gamma_2 \ln(\text{SXSW}_c^{\text{Pre}} + 1) + \gamma_3 X_c + \varepsilon_c$$

The second-stage regression isolates the causal effect of predicted Twitter usage on county mental health:

$$\ln(\text{Mental Health}_c + 1) = \beta_0 + \beta_1 \widehat{\ln(\text{Twitter Adoption}}_c + 1) + \beta_2 \ln(\text{SXSW}_c^{\text{Pre}} + 1) + \beta_3 X_c + \varepsilon_c$$

Where:

$\ln(\text{Twitter Adoption}_c + 1)$ is the endogenous variable, proxied by unique county Twitter users in the aggregated 2014–2015 period.

$\ln(\text{SXSW}_c^{\text{March2007}} + 1)$ is the Instrumental Variable (unique followers who joined in March 2007).

$\ln(\text{SXSW}_c^{\text{Pre}} + 1)$ is the pre-festival control (unique followers who joined before March 2007).

$X_c$ is a vector of time-varying demographic and economic controls.

3. Quasi-Natural Experiment 2: Facebook Rollout & Social Connectivity Index (SCI)

The second quasi-natural experiment uses the same mental health outcomes and control vectors but utilizes Facebook exposure. It builds upon the college rollout framework by Braghieri, Levy, and Makarin (2021), transferring the exogeneity of the first 775 "Facebook colleges" into a county-level 2SLS spillover framework.

Model Specifications

The first-stage regression models the relationship between the binary early college rollout instrument and the Z-score standardized Facebook social connectedness variable:

$$\text{sh500m}_c = \alpha_0 + \alpha_1 \text{adopter}_c + \alpha_3 X_c + \varepsilon_c$$

The reduced-form regression directly links college rollout to mental health outcomes:

$$\ln(\text{Mental Health}_c + 1) = \gamma_0 + \gamma_1 \text{adopter}_c + \gamma_3 X_c + \varepsilon_c$$

The second-stage regression estimates the causal effect of standardized social connectivity on mental health:

$$\ln(\text{Mental Health}_c + 1) = \beta_0 + \beta_1 \widehat{\text{sh500m}}_c + \beta_3 X_c + \varepsilon_c$$

Where:

$\text{sh500m}_c$ is the endogenous variable, representing the share of a county's Facebook friends living within 500 miles (2016 snapshot), standardized to a Z-score.

$\text{adopter}_c$ is the binary instrument ($1$ if the county hosted one of the first 775 early Facebook colleges, $0$ otherwise).

$X_c$ is our robust vector of socioeconomic and demographic covariates (e.g., sector employment, unemployment, age brackets, primary care accessibility).

4. Addressing Suppressed CDC Mortality Data

Due to federal privacy protections, county-level mortality counts between $1$ and $9$ are zensored (Missing Not at Random - MNAR). Rather than using listwise deletion or biased constant substitutions, this project utilizes a novel hybrid imputation framework based on Erdman et al. (2021):

Rule-Based Temporal Substitution using longitudinal stability.

Log-MICE (Predictive Mean Matching) conditioned on population size.

Constrained Proportional Recalibration to scale imputed values strictly back into the $[1, 9]$ interval without losing relative ordinal rankings.

The dedicated code and mathematical pipeline for this imputation strategy can be accessed in my standalone repository: MICPR (Multiple Imputation with Constrained Proportional Recalibration).

5. Repository Structure

data/: Processed data panels and county characteristics. For source variables, see the Data README.

scripts/: R scripts covering database merges, CDC data imputation pipelines, and core 2SLS regressions.

results/: Output directory containing regression tables (LaTeX and HTML formats) and visualizations.
