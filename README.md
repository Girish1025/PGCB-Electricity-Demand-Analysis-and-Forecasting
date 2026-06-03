# PGCB Electricity Demand Analysis and Forecasting

## Project Overview

This project analyzes electricity demand, generation, imports, and load-shedding patterns using PGCB power demand data. The goal is to understand demand behavior over time and build forecasting models that can support better electricity planning and grid operations.
The project includes data cleaning, exploratory analysis, time-based feature creation, demand pattern analysis, time series preparation, stationarity testing, forecasting model development, and model comparison.

## Objective

The main objective is to forecast electricity demand and identify important demand patterns across hours, days, months, years, and peak periods.

Key questions addressed in this project include:

- How does electricity demand vary by hour, weekday, month, and year?
- How do electricity demand and generation compare over time?
- How do domestic supply and electricity imports contribute to overall availability?
- What seasonal patterns exist in electricity demand?
- Which forecasting model performs best for short-term demand forecasting?

## Key Variables

| Variable | Description |
|---|---|
| datetime | Date and time of the electricity demand record |
| generation_mw | Total electricity generation in megawatts |
| demand_mw | Electricity demand in megawatts |
| load_shedding | Load shedding amount in megawatts |
| gas | Electricity generated from gas |
| liquid_fuel | Electricity generated from liquid fuel |
| coal | Electricity generated from coal |
| hydro | Electricity generated from hydro |
| solar | Electricity generated from solar |
| wind | Electricity generated from wind |
| india_bheramara_hvdc | Electricity imported through Bheramara HVDC |
| india_tripura | Electricity imported from Tripura |
| india_adani | Electricity imported from Adani |
| nepal | Electricity imported from Nepal |
| remarks | Peak period information such as day peak or evening peak |

## Project Structure

```text
PGCB-Electricity-Demand-Analysis-and-Forecasting/
├── data/
│   └── dataset
├── R/
│   ├── 00_libraries.R
│   ├── 01_data_import_cleaning.R
│   ├── 02_datetime_features.R
│   ├── 03_eda_visualizations.R
│   ├── 04_time_series_preparation.R
│   ├── 05_stationarity_diagnostics.R
│   ├── 06_forecasting_models.R
│   └── 07_model_evaluation.R
├── outputs/
│   ├── figures/
│   └── models/
├── main.R
├── requirements.txt
├── README.md
└── .gitignore
```

## Author

**Girish S Chandrappa**
