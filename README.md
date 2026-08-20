# Replication Package

## On-package claims are imperfect signals of overall nutritional quality

**Journal:** *Nature Food*  
**Replication package DOI:** [https://doi.org/10.5281/zenodo.21796219](https://doi.org/10.5281/zenodo.21796219)

## 1. Project overview

This replication package provides the code and synthetic data used to clean, construct, and analyze product-level nutrition and claim data from the Mintel Global New Products Database (GNPD). The study covers food and beverage products launched between 2015 and 2024 and examines the relationship between on-package claims and overall nutritional quality, measured using the UK Nutrient Profiling Model (NPM 2004–2005).

Because GNPD is a restricted-use database, the original product-level data cannot be redistributed. The included synthetic dataset preserves the structure and key statistical properties required to execute the analytical workflow without containing real product-level observations.

## 2. Data availability

The original data are from the proprietary Mintel GNPD and require a valid license. Access information is available from [Mintel](https://www.mintel.com/products/gnpd/).

The replication package includes the following synthetic dataset:

`Data/GNPD-AllFoodDrink_Claim_NPMScore_2015_2024_synthetic.xlsx`

The synthetic dataset supports code verification and reproduction of representative descriptive and nonparametric analyses. It is not intended to reproduce the exact numerical results reported in the paper.

## 3. Repository structure

```text
ReplicationPackage/
├── Code/
│   ├── DataClean/
│   │   ├── CleanClaims.do
│   │   ├── NPM_Step1_Serving_FVN_Beverages.do
│   │   ├── NPM_Step1_Serving_FVN_Food.do
│   │   ├── NPM_Step2_NutritionCleaning.do
│   │   └── NPM_Step3_ScoreCalculation.do
│   ├── DataVisualization/
│   │   ├── Main_Figure_Table.ipynb
│   │   └── Supplementary_Figures_and_Extended_Tables.ipynb
│   ├── DataClean_Mintel_Drink.do
│   ├── DataClean_Mintel_Food.do
│   └── MasterCode.do
├── Data/
│   └── GNPD-AllFoodDrink_Claim_NPMScore_2015_2024_synthetic.xlsx
├── README.md
└── ReadMe.pdf
```

## 4. Software

Data cleaning and variable construction were conducted using Stata/MP 18. Statistical analysis, figure generation, and source-data preparation were conducted using Python 3.12.7 in Jupyter Notebook.

Required Python libraries are imported at the beginning of each notebook and include:

- `pandas`
- `numpy`
- `matplotlib`
- `seaborn`
- `scipy`
- `openpyxl`
- `python-docx`

## 5. Replication instructions

### Using the included synthetic dataset

1. Download or clone the replication package.
2. In both notebooks, set `PROJECT_PATH` to the location of your `ReplicationPackage` folder, then run all cells from beginning to end.

### Using licensed GNPD data

1. Update the project-directory paths in the Stata scripts.
2. Run `Code/MasterCode.do` to execute the data-cleaning and variable-construction workflow.
3. Run the two Jupyter notebooks using the resulting cleaned analytical dataset.

## 6. Generated outputs

### Main figures and table

`Main_Figure_Table.ipynb` generates Table 1 and Figures 1–4 under:

`Result/Final_Main_Figures/`

The figure source-data workbooks are saved under `Result/Final_Main_Figures/Source_Data_Workbooks/`:

- `Figure1_SourceData.xlsx`
- `Figure2_SourceData.xlsx`
- `Figure3_SourceData.xlsx`
- `Figure4_SourceData.xlsx`

### Supplementary figures and extended data tables

`Supplementary_Figures_and_Extended_Tables.ipynb` generates Supplementary Figures S1–S3 and the extended data tables under:

`Result/Appendix/`

The supplementary figure source-data workbooks are saved under `Result/Appendix/Source_Data_Workbooks/`:

- `Figure_S1_SourceData.xlsx`
- `Figure_S2_SourceData.xlsx`
- `Figure_S3_SourceData.xlsx`

## 7. Important notes

Results generated from the synthetic dataset may differ from the published estimates, statistical significance patterns, and figures. Researchers with access to the original GNPD data can reproduce the published results by running the data-cleaning scripts followed by the visualization code.

The replication package is released under the Creative Commons Attribution 4.0 International license. Users should cite the associated paper and the archived replication package.

## 8. Citation

When using this replication package, cite the associated paper and the archived package:

> *Replication package for “On-package claims are imperfect signals of overall nutritional quality.”* Zenodo. [https://doi.org/10.5281/zenodo.21796219](https://doi.org/10.5281/zenodo.21796219).
