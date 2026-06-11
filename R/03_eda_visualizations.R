# Exploratory data analysis visualizations

plot_demand_distribution <- function(data) {
  ggplot(data, aes(x = demand_mw)) +
    geom_histogram(bins = 40, fill = "#0073C2FF", color = "white", alpha = 0.8) +
    labs(title = "Distribution of Electricity Demand (MW)", x = "Demand (MW)", y = "Count") +
    theme_minimal(base_size = 14)
}

plot_hourly_demand <- function(data) {
  data %>%
    group_by(hour) %>%
    summarise(avg_demand = mean(demand_mw, na.rm = TRUE), .groups = "drop") %>%
    ggplot(aes(hour, avg_demand)) +
    geom_line(color = "steelblue", linewidth = 1) +
    labs(title = "Hourly Demand Pattern", x = "Hour", y = "Average Demand") +
    theme_minimal()
}

plot_weekday_demand <- function(data) {
  data %>%
    group_by(weekday) %>%
    summarise(avg_demand = mean(demand_mw, na.rm = TRUE), .groups = "drop") %>%
    ggplot(aes(weekday, avg_demand)) +
    geom_col(fill = "steelblue") +
    labs(title = "Day of Week Demand", y = "Average Demand") +
    theme_minimal()
}

plot_monthly_demand <- function(data) {
  data %>%
    group_by(month) %>%
    summarise(avg_demand = mean(demand_mw, na.rm = TRUE), .groups = "drop") %>%
    ggplot(aes(month, avg_demand)) +
    geom_col(fill = "steelblue") +
    labs(title = "Monthly Demand Variation", y = "Average Demand") +
    theme_minimal()
}

plot_demand_generation_trend <- function(data) {
  data %>%
    mutate(YearMonth = lubridate::floor_date(datetime, unit = "month")) %>%
    group_by(YearMonth) %>%
    summarise(
      avg_demand = mean(demand_mw, na.rm = TRUE),
      avg_generation = mean(generation_mw, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    ggplot(aes(x = YearMonth)) +
    geom_line(aes(y = avg_demand, color = "Demand"), size = 1.2) +
    geom_line(aes(y = avg_generation, color = "Generation"), size = 1.2) +
    labs(title = "Month-Year Electricity Demand & Generation Trend", x = "Month", y = "Average MW", color = "Legend") +
    theme_minimal(base_size = 14)
}

plot_supply_import_trend <- function(data) {
  data %>%
    mutate(
      total_supply = gas + liquid_fuel + coal + hydro + solar + wind,
      total_imports = india_bheramara_hvdc + india_tripura + india_adani,
      YearMonth = lubridate::floor_date(datetime, unit = "month")
    ) %>%
    group_by(YearMonth) %>%
    summarise(
      avg_supply_month = mean(total_supply, na.rm = TRUE),
      avg_imports_month = mean(total_imports, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    ggplot(aes(x = YearMonth)) +
    geom_line(aes(y = avg_supply_month, color = "Supply"), size = 1.2) +
    geom_line(aes(y = avg_imports_month, color = "Imports"), size = 1.2) +
    labs(title = "Month-wise Domestic Supply vs Imports Trend", x = "Month-Year", y = "MW", color = "Legend") +
    theme_minimal(base_size = 14)
}
