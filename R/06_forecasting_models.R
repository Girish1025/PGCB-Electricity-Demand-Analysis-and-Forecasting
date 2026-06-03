# Forecasting model functions

train_ets_model <- function(ts_train, horizon) {
  fit <- forecast::ets(ts_train)
  forecast_obj <- forecast::forecast(fit, h = horizon)
  list(model = fit, forecast = forecast_obj)
}

train_holt_winters_model <- function(ts_train, horizon) {
  fit <- HoltWinters(ts_train, seasonal = "multiplicative")
  forecast_obj <- forecast::forecast(fit, h = horizon)
  list(model = fit, forecast = forecast_obj)
}

train_sarima_model <- function(ts_train, horizon) {
  fit <- forecast::auto.arima(ts_train, seasonal = TRUE)
  forecast_obj <- forecast::forecast(fit, h = horizon)
  list(model = fit, forecast = forecast_obj)
}

plot_forecast_vs_actual <- function(forecast_obj, ts_test, title = "Forecast vs Actual") {
  autoplot(forecast_obj) +
    autolayer(ts_test, series = "Actual", color = "red") +
    ggtitle(title) +
    ylab("Demand (MW)") +
    xlab("Time") +
    theme_minimal()
}
