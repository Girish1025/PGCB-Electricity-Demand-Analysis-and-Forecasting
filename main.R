# Main workflow for PGCB Electricity Demand Analysis and Forecasting

source("R/00_libraries.R")
source("R/01_data_import_cleaning.R")
source("R/02_datetime_features.R")
source("R/03_eda_visualizations.R")
source("R/04_time_series_preparation.R")
source("R/05_stationarity_diagnostics.R")
source("R/06_forecasting_models.R")
source("R/07_model_evaluation.R")

# Data paths
raw_data_path <- "data/PGCB_date_power_demand.xlsx"
clean_data_path <- "data/data_main_clean.csv"

# 1. Load and clean data
raw_data <- load_pgcb_data(raw_data_path)
clean_data <- clean_pgcb_data(raw_data)
save_clean_data(clean_data, clean_data_path)

# 2. Add datetime features
pgcb_data <- read.csv(clean_data_path)
pgcb_data <- add_datetime_features(pgcb_data)

# 3. Exploratory analysis
print(plot_demand_distribution(pgcb_data))
print(plot_hourly_demand(pgcb_data))
print(plot_weekday_demand(pgcb_data))
print(plot_monthly_demand(pgcb_data))
print(plot_demand_generation_trend(pgcb_data))
print(plot_supply_import_trend(pgcb_data))

# 4. Prepare daily demand time series
series_data <- prepare_daily_demand_series(pgcb_data)
ts_daily <- series_data$ts_daily

# 5. Stationarity and diagnostics
plot_time_series_diagnostics(ts_daily)
run_stationarity_checks(ts_daily)

# 6. Train/test split
split_data <- split_time_series(ts_daily, horizon = 14)
ts_train <- split_data$train
ts_test <- split_data$test
h <- split_data$horizon

# 7. Forecasting models
ets_result <- train_ets_model(ts_train, h)
hw_result <- train_holt_winters_model(ts_train, h)
sarima_result <- train_sarima_model(ts_train, h)

print(plot_forecast_vs_actual(ets_result$forecast, ts_test, "ETS Forecast vs Actual"))
print(plot_forecast_vs_actual(hw_result$forecast, ts_test, "Holt-Winters Forecast vs Actual"))
print(plot_forecast_vs_actual(sarima_result$forecast, ts_test, "SARIMA Forecast vs Actual"))

# 8. Model comparison and diagnostics
model_comparison <- compare_forecast_models(ets_result, hw_result, sarima_result, ts_test)
model_metrics_plot <- save_model_metrics_outputs(model_comparison)
print(model_metrics_plot)
plot_sarima_residuals(sarima_result$model)
