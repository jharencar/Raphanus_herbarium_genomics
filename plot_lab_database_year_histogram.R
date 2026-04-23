#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(ggplot2)
})

input_csv <- "Raphanus_lab_database_260409.csv"
output_png <- "lab_database_samples_by_year_qbit_filtered.png"

df <- read.csv(
  input_csv,
  check.names = FALSE,
  stringsAsFactors = FALSE,
  na.strings = c("", "NA")
)

df[["Qbit_ng/ul"]] <- suppressWarnings(as.numeric(df[["Qbit_ng/ul"]]))
df[["year"]] <- suppressWarnings(as.integer(df[["year"]]))

filtered <- subset(
  df,
  !is.na(`Qbit_ng/ul`) & `Qbit_ng/ul` >= 0.15 & !is.na(year)
)

counts <- as.data.frame(table(filtered[["year"]]), stringsAsFactors = FALSE)
colnames(counts) <- c("year", "n")
counts[["year"]] <- as.integer(counts[["year"]])

p <- ggplot(counts, aes(x = year, y = n)) +
  geom_col(width = 0.9, fill = "steelblue") +
  labs(
    title = "Samples per year (Qubit ≥ 0.15 ng/µL)",
    x = "Year",
    y = "Number of samples"
  ) +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))

# Smaller canvas than before: panel shrinks but theme base_size (text) is unchanged.
ggsave(output_png, plot = p, width = 6, height = 3.5, dpi = 300)

message(
  "Rows after filter (Qbit_ng/ul >= 0.15): ",
  nrow(filtered),
  " — saved plot to: ",
  output_png
)
