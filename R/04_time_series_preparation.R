# Time series preparation

prepare_daily_demand_series <- function(data) {
  data <- data %>%
    mutate(datetime = as.POSIXct(datetime)) %>%
    filter(!is.na(datetime)) %>%
    distinct(datetime, .keep_all = TRUE) %>%
    arrange(datetime)

  data_daily <- data %>%
    mutate(day = lubridate::floor_date(datetime, "day")) %>%
    group_by(day) %>%
    summarise(demand = mean(demand_mw, na.rm = TRUE), .groups = "drop") %>%
    arrange(day)

  ts_daily <- ts(data_daily$demand, frequency = 7)

  list(data_daily = data_daily, ts_daily = ts_daily)
}

split_time_series <- function(ts_daily, horizon = 14) {
  n <- length(ts_daily)
  ts_train <- ts(ts_daily[1:(n - horizon)], frequency = 7, start = tsp(ts_daily)[1])
  ts_test <- ts(ts_daily[(n - horizon + 1):n], frequency = 7, start = tsp(ts_train)[2] + 1 / 7)
  list(train = ts_train, test = ts_test, horizon = horizon)
}
