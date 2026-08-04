# Replication Package README

## On-package claims are imperfect signals of overall nutritional quality

**Journal:** *Nature Food*

## 1. Project Overview

This replication package provides the code and synthetic data used to clean, construct, and analyze product-level nutrition and claim data from the Mintel Global New Products Database (GNPD). The analysis focuses on food and beverage products launched between 2015 and 2024 and examines the relationship between on-package claims and overall nutritional quality, measured using the UK Nutrient Profiling Model (NPM 2004–2005).

Because GNPD is a restricted-use database, the original data cannot be redistributed. This package therefore includes detailed code and instructions to enable replication for users with appropriate data access, along with a synthetic dataset that allows users to execute the analysis workflow, verify the replication code, and reproduce representative descriptive and nonparametric analyses without disclosing the underlying restricted-use data.

## 2. Data Availability and Access

The data used in this study are sourced from the Mintel Global New Products Database (GNPD), a proprietary dataset that requires a valid license. Access information is available at: https://www.mintel.com/products/gnpd/.

Due to licensing restrictions, these data are not included in this replication package. A synthetic dataset is provided to support replication; it preserves the overall structure and key statistical properties of the cleaned data needed for reproducibility while not containing real product-level observations.

## 3. Folder Structure

- `Code/`  
  Contains all scripts for data cleaning, variable construction, and analysis. The folder is organized into subfolders by function:

  - `DataClean/`  
    Stata code for data cleaning and variable construction, including claim variable construction, nutrition data processing, and NPM score calculation.

  - `DataVisualization/`  
    Jupyter notebooks (Python) used for statistical analysis and figure generation.

  - Main scripts  
    Includes `DataClean_Mintel_Food.do`, `DataClean_Mintel_Drink.do`, and `MasterCode.do`. The `MasterCode.do` script serves as the main entry point for the Stata-based data cleaning and variable construction workflow.

- `Data/`  
  Contains the synthetic dataset:

  - `GNPD-AllFoodDrink_Claim_NPMScore_2015_2024_synthetic.xlsx`

  The synthetic dataset is designed to preserve the key structural and statistical properties required for replication of the descriptive and nonparametric analyses while preventing disclosure of the underlying restricted data.

- `README.md`  
  Provides documentation and instructions for replication.

## 4. Instructions for Replication

Data cleaning and variable construction were conducted in Stata/MP 18, and statistical analysis and figure generation were performed in Python 3.12.7.

### Step 1. Data Cleaning and Variable Construction

Update the project directory paths in the Stata scripts and run `MasterCode.do` to execute the full data cleaning and variable construction workflow.

### Step 2. Figure and Table Generation

After the cleaned analysis dataset has been generated, run the Jupyter notebooks in the `DataVisualization/` folder. Required Python libraries are noted at the beginning of the Jupyter notebooks.

- `AllFoodDrink_DataVisualization.ipynb` for the main manuscript figures and tables.
- `AllFoodDrink_DataVisualization_Appendix.ipynb` for appendix figures, appendix tables, and extended data tables.

## 5. Important Notes

The synthetic dataset is provided solely for code verification and reproducibility purposes and is not intended to reproduce the exact numerical results reported in the paper. The synthetic data preserve the overall structure and analytical workflow of the study, allowing users to execute the replication code and reproduce representative descriptive and nonparametric analyses, but the resulting estimates, statistical significance patterns, and figures may differ from those reported in the paper. Researchers with access to the original GNPD data should be able to reproduce the published results by running the provided Stata data cleaning and variable construction scripts, followed by the replication code, on the restricted-use dataset as described in the replication instructions.

Use of the code for educational purposes is permitted. Researchers using the code for academic work should cite the associated paper and this replication package. For other uses, please contact the authors.
