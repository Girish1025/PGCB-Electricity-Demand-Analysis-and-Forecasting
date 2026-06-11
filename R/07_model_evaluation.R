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

plot_model_metrics <- function(comparison) {
  metrics_long <- comparison %>%
    as.data.frame() %>%
    tibble::rownames_to_column("Model") %>%
    tidyr::pivot_longer(
      cols = c("RMSE", "MAE", "MAPE"),
      names_to = "Metric",
      values_to = "Value"
    )

  ggplot(metrics_long, aes(x = Model, y = Value, fill = Model)) +
    geom_col(width = 0.7, show.legend = FALSE) +
    geom_text(aes(label = sprintf("%.2f", Value)), vjust = -0.4, size = 3.5) +
    facet_wrap(~Metric, scales = "free_y") +
    scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
    labs(
      title = "Forecast Model Performance Comparison",
      subtitle = "Lower values indicate better performance",
      x = NULL,
      y = NULL
    ) +
    theme_minimal(base_size = 12) +
    theme(
      plot.title = element_text(face = "bold"),
      axis.text.x = element_text(angle = 25, hjust = 1)
    )
}

save_model_metrics_outputs <- function(comparison, output_dir = "outputs") {
  figures_dir <- file.path(output_dir, "figures")
  tables_dir <- file.path(output_dir, "tables")
  dir.create(figures_dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(tables_dir, recursive = TRUE, showWarnings = FALSE)

  metrics_plot <- plot_model_metrics(comparison)
  ggplot2::ggsave(
    filename = file.path(figures_dir, "model_metrics_comparison.png"),
    plot = metrics_plot,
    width = 11,
    height = 5,
    dpi = 300
  )

  comparison_table <- comparison %>%
    as.data.frame() %>%
    tibble::rownames_to_column("Model")
  write.csv(
    comparison_table,
    file.path(tables_dir, "model_metrics_comparison.csv"),
    row.names = FALSE
  )

  metrics_plot
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
