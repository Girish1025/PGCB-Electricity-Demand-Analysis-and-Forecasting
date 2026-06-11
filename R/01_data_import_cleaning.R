# Data import and cleaning functions

load_pgcb_data <- function(file_path) {
  df <- readxl::read_excel(file_path)
  as.data.frame(df)
}

convert_numeric_columns <- function(data) {
  numeric_cols <- c(
    "generation_mw", "demand_mw", "load_shedding",
    "gas", "liquid_fuel", "coal", "hydro", "solar", "wind",
    "india_bheramara_hvdc", "india_tripura", "india_adani", "nepal"
  )
  numeric_cols <- intersect(numeric_cols, names(data))
  data[numeric_cols] <- lapply(data[numeric_cols], function(x) {
    x <- dplyr::na_if(as.character(x), "nan")
    as.numeric(x)
  })
  data
}

clean_pgcb_data <- function(data) {
  data <- convert_numeric_columns(data)

  if ("generation_mw" %in% names(data)) {
    idx <- which(data$generation_mw > 17000)
    if (length(idx) >= 1) data$generation_mw[idx[1]] <- 6452.0
  }

  if ("liquid_fuel" %in% names(data)) {
    idx <- which(data$liquid_fuel > 50000)
    replacement_values <- c(698, 893, 2922)
    for (i in seq_along(idx)) {
      if (i <= length(replacement_values)) data$liquid_fuel[idx[i]] <- replacement_values[i]
    }
    idx <- which(data$liquid_fuel > 10000)
    data$liquid_fuel[idx] <- as.numeric(stringr::str_sub(as.character(as.integer(data$liquid_fuel[idx])), 1, -2))
  }

  if ("india_bheramara_hvdc" %in% names(data)) {
    idx <- which(data$india_bheramara_hvdc > 20000)
    if (length(idx) >= 1) data$india_bheramara_hvdc[idx[1]] <- 762
    idx <- which(data$india_bheramara_hvdc > 2000)
    data$india_bheramara_hvdc[idx] <- as.numeric(stringr::str_sub(as.character(as.integer(data$india_bheramara_hvdc[idx])), 1, -2))
  }

  for (col in c("coal", "demand_mw", "gas", "hydro", "india_adani")) {
    if (col %in% names(data)) {
      threshold <- switch(col,
                          coal = 10000,
                          demand_mw = 20000,
                          gas = 16000,
                          hydro = 1000,
                          india_adani = 2000)
      idx <- which(data[[col]] > threshold)
      data[[col]][idx] <- as.numeric(stringr::str_sub(as.character(as.integer(data[[col]][idx])), 1, -2))
    }
  }

  if ("load_shedding" %in% names(data)) {
    data$load_shedding[data$load_shedding > 10000] <- 0
    idx <- which(data$load_shedding > 4000 & data$load_shedding < 5000)
    if (length(idx) >= 4) data$load_shedding[idx[c(3, 4)]] <- 0
  }

  data <- data %>%
    dplyr::filter(
      !(.data$generation_mw < 3000),
      !(.data$demand_mw < 1000),
      !(.data$hydro > 300),
      !(.data$wind > 100),
      !(.data$india_tripura > 200),
      !(.data$coal > 5000)
    )

  data
}

save_clean_data <- function(data, output_path = "data/data_main_clean.csv") {
  write.csv(data, output_path, row.names = FALSE)
}
