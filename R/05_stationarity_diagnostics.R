# Stationarity and diagnostic plots

run_stationarity_checks <- function(ts_daily) {
  print(tseries::adf.test(ts_daily))
  ts_daily_diff <- diff(ts_daily, differences = 1)
  print(tseries::adf.test(ts_daily_diff))
  list(original = ts_daily, differenced = ts_daily_diff)
}

plot_time_series_diagnostics <- function(ts_daily) {
  df_lag <- data.frame(
    y_t = ts_daily[-length(ts_daily)],
    y_t1 = ts_daily[-1]
  )

  p1 <- ggplot(df_lag, aes(x = y_t, y = y_t1)) +
    geom_point(color = "#2C7BB6", size = 1, alpha = 0.7) +
    labs(title = "Lag Plot - Daily Electricity Demand", x = "y(t)", y = "y(t + 1)") +
    theme_minimal(base_size = 16)

  print(p1)

  ts_daily_diff <- diff(ts_daily)
  df_diff <- data.frame(diff = ts_daily_diff)

  p2 <- ggplot(df_diff, aes(x = diff)) +
    geom_histogram(aes(y = ..count..), bins = 30, fill = "salmon", color = "black", alpha = 0.6) +
    geom_density(color = "red", size = 1, alpha = 0.8) +
    labs(title = "Distribution of Daily Demand Changes", x = "Demand Change (MW)", y = "Count") +
    theme_minimal(base_size = 16)

  print(p2)

  stl_daily <- stl(ts_daily, s.window = "periodic")
  print(autoplot(stl_daily))
}
