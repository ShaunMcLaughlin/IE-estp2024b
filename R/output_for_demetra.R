library(tidyverse)
library(eurostat)
library(openxlsx)

toc <- get_eurostat_toc()

required_series <- c("B1GQ", "B1G", "P3", "P5G", "B11", "D21X31")

qna <- eurostat::get_eurostat(
    "namq_10_gdp",
    filters = list(geo = "IE", unit = "CP_MEUR", s_adj = "NSA", sinceTimePeriod = 1995),
    #     type = "both"
) %>%
#     mutate(na_item = sprintf("%s [%s]", na_item, names(na_item))) %>%
#     {print(unique(.$na_item)); .} %>%
filter(na_item %in% .env$required_series) %>%
    pivot_wider(id_cols = time, names_from = na_item, values_from = values) %>%
    rename_with(tolower)

# check b1gq calculation
qna2 <- qna %>%
    mutate(
        b1gq,
        new_gdp = (b1g + d21x31 + p3 + p5g + b11) / 2,
        diff = round(b1gq - new_gdp, 0.0001),
        .keep = "none"
           )

openxlsx::write.xlsx(qna, "qna.xlsx")



