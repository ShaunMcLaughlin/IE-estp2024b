library(tidyverse)
library(eurostat)
library(openxlsx)

qna_sa <- openxlsx::read.xlsx(
    "/home/shaun/Rwork/estp2024b/demetra/demetra/SAProcessing-1/demetra.xlsx",
    sheet = "sa",
    startRow = 2
) %>%
    rename_with(~sub("^Sheet\\.1\\.\\*\\.", "", .x)) %>%
    rename(date = X1) %>%
    mutate(date = as.Date(date, origin =as.Date("1899-12-30")))


indirect <- qna_sa %>%
    mutate(
           date,
           b1gq,
           new_gdp = (b1g + d21x31 + p3 + p5g + b11) / 2,
           diff = round(b1gq - new_gdp, 0.0001),
           .keep = "none"
           )


ggplot(indirect, aes(x = date)) +
    geom_line(aes(y=b1gq), colour = "blue") +
    geom_line(aes(y=new_gdp), colour = "red") 
           
