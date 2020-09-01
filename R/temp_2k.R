file_url <- 'https://www1.ncdc.noaa.gov/pub/data/paleo/pages2k/neukom2019temp/recons/Full_ensemble_median_and_95pct_range.txt'
dl <- tempfile()
download.file(file_url, dl)
temp_2k <- suppressMessages( read_table2(dl, col_names = FALSE, skip = 5,
                                    col_types = 'innnnnnnn') )

colnames(temp_2k) <- c('year', 'instrumental', 'ensemble_median', 'ensemble_2.5', 'ensemble_97.5', 'filtered_instrumental',
                       'filtered_ensemble_median', 'filtered_ensemble_2.5', 'filtered_ensemble_97.5')

dir.create(hs_path, showWarnings = FALSE, recursive = TRUE)
saveRDS(temp_2k, file.path(hs_path, 'temp_2k.rds'))




temp_2k_l <- pivot_longer(temp_2k, -year)

temp_2k_l <- temp_2k_l %>% filter(name %in% c('ensemble_median', 'filtered_ensemble_median'))


ggplot(temp_2k_l, aes(x=year, y=value, color=name)) +geom_line() +stat_smooth(color='blue', n=100, span = 0.001)
