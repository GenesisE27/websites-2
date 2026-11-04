library(tidyverse)

billboard_long <- billboard |>
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    names_prefix = "wk",
    values_to = "rank"
  ) |>
  mutate(week = as.integer(week)) |>
  drop_na(rank) |>
  mutate(song = paste(track, artist, sep = " - "))

top_songs <- billboard_long |>
  group_by(song) |>
  summarize(
    peak_rank = min(rank),
    weeks_on_chart = n(),
    .groups = "drop"
  ) |>
  slice_min(peak_rank, n = 10, with_ties = FALSE) |>
  slice_max(weeks_on_chart, n = 10, with_ties = FALSE)

write_rds(top_songs, file = "clean_data.rds")
