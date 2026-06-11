# Datetime feature creation

add_datetime_features <- function(data) {
  data %>%
    dplyr::mutate(
      datetime = lubridate::parse_date_time(
        datetime,
        orders = c("ymd HMS", "ymd HM", "ymd", "dmy HMS", "dmy HM", "dmy", "mdy HMS", "mdy HM", "mdy")
      ),
      date = as.Date(datetime),
      hour = lubridate::hour(datetime),
      weekday = lubridate::wday(datetime, label = TRUE),
      month = lubridate::month(datetime, label = TRUE),
      year = lubridate::year(datetime)
    )
}
