How does Social Media Prevalence 
Influence Mental Health Outcomes?  
An Empirical Analysis

This directory contains the data sources and processed datasets underlying the causal analysis of the effects of social media on mental health. The analysis covers 3,108 U.S. counties.

1. Data Overview

The dataset integrates information from various sources to enable a robust identification strategy:

Social Media Data:

Twitter: Based on approximately 475 million geo-located tweets (Kinder-Kurlanda et al., 2017), prepared and mapped to U.S. counties by Fujiwara et al. (2021).

Instrumental Variable (IV): Twitter adoption during the 2007 SXSW festival (Fujiwara et al., 2021) is used as an exogenous shock for causal identification.

Facebook: SCI Data,  the intensity of social connections between two geographic areas. The core of this analysis relies on the share of a county’s Facebook friends living within 500 miles.

Instrumental Variable (IV): Facebook early rollout (Braghieri et al., 2021) is used as an exogenous shock for causal identification.

Health Data:

Primary source: County Health Rankings & Roadmaps (CHR&R), a collaboration between the Robert Wood Johnson Foundation and the University of Wisconsin Population Health Institute.

Mental health metrics: Behavioral Risk Factor Surveillance System (BRFSS).

Mortality data: CDC WONDER database.

2. Methodology & Data Processing

Handling Data Suppression

Since the CDC suppresses case counts between 1–10 (Missing Not at Random - MNAR), I implemented a robust imputation strategy. Detailed documentation and the dedicated processing pipeline for this method can be found in my specialized project repository: MICPR (Multiple Imputation with Constrained Proportional Recalibration).

3. Control Variables

The analysis includes extensive control vectors to ensure causal identification:

Health Behaviors: Adult Smoking, Physical Inactivity, Excessive Drinking, and Insufficient Sleep, primarily sourced from CHR&R/BRFSS.

Clinical Care:

Access: Uninsured Adults/Children from the U.S. Census Bureau’s SAHIE.

Availability: Primary Care & Mental Health Provider ratios from the U.S. Department of Health and Human Services (HHS) and CMS.

Quality & Cost: Preventable Hospital Stays (AHRQ) and Health Care Costs (Health Care Cost Institute).

Infrastructure & Community: Social Associations (U.S. Census Bureau Economic Census), Access to Exercise Opportunities, and the Food Environment Index (USDA Food Access Research Atlas).

Socioeconomic & Demographic Factors: Population density, age structures, ethnicity, and education levels (U.S. Census/ACS), and industry-level unemployment rates (Bureau of Labor Statistics - BLS).
data/: Processed data panels and county characteristics. For source variables, see the Data README.

