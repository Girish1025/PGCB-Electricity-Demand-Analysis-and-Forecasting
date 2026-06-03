# Model evaluation functions

evaluate_forecast_model <- function(forecast_obj, ts_test) {
  forecast::accuracy(forecast_obj, ts_test)
}

compare_forecast_models <- function(ets_result, hw_result, sarima_result, ts_test) {
  acc_ets <- evaluate_forecast_model(ets_result$forecast, ts_test)
  acc_hw <- evaluate_forecast_model(hw_result$forecast, ts_test)
  acc_sarima <- evaluate_forecast_model(sarima_result$forecast, ts_test)

  comparison <- rbind(
    ETS = acc_ets[2, c("RMSE", "MAE", "MAPE")],
    HoltWinters = acc_hw[2, c("RMSE", "MAE", "MAPE")],
    SARIMA = acc_sarima[2, c("RMSE", "MAE", "MAPE")]
  )

  print(comparison)
  comparison
}

plot_sarima_residuals <- function(sarima_model) {
  res <- residuals(sarima_model)

  print(autoplot(res) +
          ggtitle("SARIMA Residuals Over Time") +
          ylab("Residuals") +
          xlab("Time") +
          theme_minimal(base_size = 16))

  df_res <- data.frame(res = res)

  print(ggplot(df_res, aes(x = res)) +
          geom_histogram(aes(y = ..density..), bins = 30, fill = "skyblue", color = "black", alpha = 0.6) +
          geom_density(color = "red", size = 1.2) +
          ggtitle("Histogram of SARIMA Residuals") +
          xlab("Residuals") +
          theme_minimal(base_size = 16))

  acf(res, main = "ACF of SARIMA Residuals")
  pacf(res, main = "PACF of SARIMA Residuals")
  qqnorm(res)
  qqline(res, col = "red", lwd = 2)
}
