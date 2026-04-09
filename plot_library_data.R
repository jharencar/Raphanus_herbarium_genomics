#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(ggplot2)
})

input_tsv <- "test_library_data.tsv"
output_png <- "library_vs_total_dna.png"

df <- read.delim(
  input_tsv,
  check.names = FALSE,
  stringsAsFactors = FALSE
)

# Convert columns used in plotting to numeric; coercion handles entries like "too low".
df[["1x HS DNA (1ul) library"]] <- suppressWarnings(
  as.numeric(df[["1x HS DNA (1ul) library"]])
)
df[["total DNA"]] <- suppressWarnings(as.numeric(df[["total DNA"]]))
df[["# PCR cycles"]] <- as.factor(df[["# PCR cycles"]])

# Flag the "half" reactions so they can be shown with a different point shape.
df[["rxn_shape"]] <- ifelse(
  grepl("half", df[["rxn"]], ignore.case = TRUE),
  "half",
  "other"
)

p <- ggplot(
  df,
  aes(
    x = `total DNA`,
    y = `1x HS DNA (1ul) library`,
    color = `# PCR cycles`,
    shape = rxn_shape
  )
) +
  geom_point(size = 3, na.rm = TRUE) +
  scale_shape_manual(values = c("half" = 17, "other" = 16)) +
  labs(
    x = "total DNA",
    y = "1x HS DNA (1ul) library",
    color = "# PCR cycles",
    shape = "rxn"
  ) +
  theme_minimal(base_size = 12)

ggsave(output_png, plot = p, width = 8, height = 5, dpi = 300)

message("Saved plot to: ", output_png)
