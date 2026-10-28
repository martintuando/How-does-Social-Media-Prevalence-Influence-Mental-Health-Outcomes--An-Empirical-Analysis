# How Does Social Media Prevalence Influence Mental Health Outcomes?
### An Empirical Analysis

This project examines the causal effect of social media exposure on mental health across 3,108 U.S. counties. Developed as part of my Master's thesis, the analysis combines county-level health data with measures of Twitter adoption and Facebook social connectedness.

A central challenge is that social media exposure is not randomly distributed across counties. Differences in technology adoption, socioeconomic conditions, and local characteristics may influence both social media use and mental health. To address this issue, the project uses two instrumental variable (IV) designs and estimates the corresponding models using Two-Stage Least Squares (2SLS).

The first design exploits variation in Twitter activity associated with the South by Southwest (SXSW) festival in March 2007. The second uses Facebook's early expansion to U.S. colleges as an instrument for county-level social connectedness. Both approaches aim to identify causal effects by using historical variation in social media exposure.

## 1. Data and Variables

### Mental Health Outcomes

The analysis combines data from several sources to measure mental health at the county level.

- **County Health Rankings & Roadmaps (CHR&R):** Self-reported measures of mental health, physical health, and health-related behaviors based on data from the Behavioral Risk Factor Surveillance System (BRFSS).
- **CDC WONDER:** County-level mortality data, including deaths from suicide and mental and behavioral disorders.

These sources capture different aspects of mental health, ranging from self-reported distress to mortality outcomes.

### Social Media Exposure

**Twitter adoption**

Twitter adoption is measured using the number of unique county-level Twitter users aggregated over 2014–2015. The underlying data draw on a large archive of geolocated tweets, with the empirical design following Fujiwara, Müller, and Schwarz (2021).

The instrument is based on Twitter activity associated with the SXSW festival in March 2007. The analysis also controls for corresponding Twitter activity before March 2007 to account for pre-existing interest in the festival.

**Facebook social connectedness**

Facebook exposure is measured using the Social Connectedness Index (SCI), which captures the intensity of connections between geographic areas.

The analysis focuses on the share of a county's Facebook connections that extend to locations within 500 miles. Rather than measuring time spent on the platform, this variable captures the geographic reach of Facebook networks.

The instrument draws on Facebook's early expansion to U.S. colleges, following the research design of Braghieri, Levy, and Makarin (2022).

### County-Level Controls

The analysis combines socioeconomic, demographic, and health-related variables from several sources:

- U.S. Census Bureau and American Community Survey (ACS)
- U.S. Religious Census
- Bureau of Labor Statistics (BLS)
- Centers for Medicare & Medicaid Services (CMS)
- National Provider Identifier (NPI) data
- Small Area Health Insurance Estimates (SAHIE)
- CDC Diabetes Interactive Atlas

The control variables account for observable differences between counties, including population composition, economic conditions, healthcare access, and health-related behaviors.

## 2. Empirical Strategy I: Twitter Adoption and the SXSW Festival

The first design uses Twitter activity associated with the 2007 SXSW festival as an instrument for subsequent county-level Twitter adoption.

The instrument measures Twitter activity associated with SXSW in March 2007. To account for pre-existing interest in the festival, the specifications also include the corresponding Twitter activity before March 2007. This distinction is important because counties with greater prior interest in Twitter or SXSW may differ systematically from other counties.

The analysis estimates OLS, first-stage, reduced-form, and 2SLS regressions. The OLS estimates provide a benchmark, while the IV specifications use the variation in Twitter adoption predicted by the instrument to estimate its causal effect on mental health.

### Model Specifications

**First stage**

The first stage tests whether the instrument predicts subsequent Twitter adoption:

\[
\begin{aligned}
\ln(TwitterAdoption_c+1) ={}&
\alpha_0\\
&+\alpha_1\ln(SXSW_{c,March2007}+1)\\
&+\alpha_2\ln(SXSW_{c,Pre}+1)\\
&+\alpha_3X_c+\varepsilon_c
\end{aligned}
\]

**Reduced form**

The reduced form examines the relationship between the instrument and mental health outcomes:

\[
\begin{aligned}
\ln(MentalHealth_c+1) ={}&
\gamma_0\\
&+\gamma_1\ln(SXSW_{c,March2007}+1)\\
&+\gamma_2\ln(SXSW_{c,Pre}+1)\\
&+\gamma_3X_c+\varepsilon_c
\end{aligned}
\]

**Second stage**

The second stage uses instrument-predicted Twitter adoption to estimate its effect on mental health:

\[
\begin{aligned}
\ln(MentalHealth_c+1) ={}&
\beta_0\\
&+\beta_1\widehat{\ln(TwitterAdoption_c+1)}\\
&+\beta_2\ln(SXSW_{c,Pre}+1)\\
&+\beta_3X_c+\varepsilon_c
\end{aligned}
\]

### Variable Definitions

- **Twitter adoption:** The number of unique county-level Twitter users aggregated over 2014–2015, transformed using the natural logarithm of the count plus one.
- **Instrument:** The number of unique Twitter followers associated with SXSW who joined in March 2007, transformed using the natural logarithm of the count plus one.
- **Pre-festival control:** The corresponding measure of Twitter activity before March 2007, included to account for pre-existing interest.
- **\(X_c\):** A vector of county-level demographic, economic, and health-related controls.
- **\(c\):** An index for counties.
- **\(\varepsilon_c\):** The regression error term.

### Identification and Robustness

The first-stage regressions assess whether the SXSW instrument explains subsequent Twitter adoption. The analysis also estimates the reduced form and compares the IV results with conventional OLS estimates.

To assess the sensitivity of the estimates to the choice of controls, the IV specifications are re-estimated using six progressively expanded control sets. The models include census-region and population-decile fixed effects, with standard errors clustered at the state level.

Additional pre-period tests examine whether the instrument is associated with Twitter adoption or mental health outcomes before the festival. These tests help assess whether the instrument captures pre-existing differences between counties that could provide alternative explanations for the estimated effects.

The causal interpretation ultimately depends on whether the instrument affects mental health through the instrumented Twitter exposure rather than through other channels. The pre-festival control, additional tests, and robustness analyses provide evidence relevant to this assumption, but cannot establish the exclusion restriction on their own.

## 3. Empirical Strategy II: Facebook Adoption and Social Connectedness

The second design examines the relationship between Facebook social connectedness and mental health. It builds on the early-college rollout studied by Braghieri, Levy, and Makarin (2022).

The instrument identifies counties that hosted one of the first 775 colleges to adopt Facebook. This historical rollout provides a source of variation used to explain differences in county-level social connectedness.

Unlike the Twitter measure, which captures the prevalence of platform adoption, the Facebook measure focuses on the geographic structure of social networks. Specifically, the analysis examines the share of Facebook connections extending to locations within 500 miles.

### Model Specifications

**First stage**

The first stage tests whether the early-college instrument predicts the standardized social connectedness measure:

\[
sh500m_c =
\alpha_0+\alpha_1adopter_c+\alpha_2X_c+\varepsilon_c
\]

**Reduced form**

The reduced form examines the relationship between early Facebook adoption and mental health outcomes:

\[
\ln(MentalHealth_c+1) =
\gamma_0+\gamma_1adopter_c+\gamma_2X_c+\varepsilon_c
\]

**Second stage**

The second stage uses instrument-predicted social connectedness to estimate its effect on mental health:

\[
\ln(MentalHealth_c+1) =
\beta_0+\beta_1\widehat{sh500m_c}+\beta_2X_c+\varepsilon_c
\]

### Variable Definitions

- **\(sh500m_c\):** The share of a county's Facebook connections associated with locations within 500 miles, measured using a 2016 snapshot and standardized as a Z-score.
- **\(adopter_c\):** An indicator equal to one for counties hosting one of the first 775 Facebook colleges and zero otherwise.
- **\(X_c\):** A vector of county-level socioeconomic, demographic, and health-related controls, including employment characteristics, unemployment, age composition, and access to primary care.
- **\(c\):** An index for counties.
- **\(\varepsilon_c\):** The regression error term.

The design aims to isolate variation in social connectedness associated with Facebook's early expansion. Its causal interpretation depends on whether the early-college instrument affects mental health through the measured social connectedness variable rather than through other channels.

## 4. Handling Suppressed CDC Mortality Data

County-level mortality data from CDC WONDER may be suppressed when the number of reported deaths is small. This creates missing observations that require special treatment because suppression is related to the underlying death counts.

The analysis uses imputed mortality data to address this limitation. The data preparation follows a dedicated multi-stage imputation pipeline documented in a separate repository.

For details on the methodology and implementation, see [A Multi-Stage Imputation Pipeline](https://github.com/martintuando/A-Multi-Stage-Imputation-Pipeline).

## 5. Results and Interpretation

The project estimates the relationship between social media exposure and mental health using two distinct sources of historical variation. The Twitter design focuses on adoption associated with the SXSW festival, while the Facebook design examines the geographic reach of social connections.

The empirical workflow includes OLS estimates, first-stage regressions, reduced-form specifications, and 2SLS estimates. The Twitter analysis additionally evaluates the sensitivity of the IV estimates to six progressively expanded control sets.

Regression tables and additional outputs are provided in the `results/` directory.


## 7. Repository Structure

- `data/`: Processed datasets, county-level panels, and control variables. Data sources and preparation details are documented separately.
- `scripts/`: R scripts for data preparation, database merges, mortality data processing, and the OLS, first-stage, reduced-form, and 2SLS regressions.
- `results/`: Regression tables in CSV, LaTeX, and HTML formats, along with figures and other analysis outputs.

## References

- Braghieri, L., Levy, R., & Makarin, A. (2022). [*Social Media and Mental Health*](https://doi.org/10.1257/aer.20211218). *American Economic Review*, 112(11), 3660–3693.
- Fujiwara, T., Müller, K., & Schwarz, C. (2021). [*The Effect of Social Media on Elections: Evidence from the United States*](https://www.nber.org/papers/w28849). NBER Working Paper No. 28849.

The imputation methodology is documented in the [separate pipeline repository](https://github.com/martintuando/A-Multi-Stage-Imputation-Pipeline).