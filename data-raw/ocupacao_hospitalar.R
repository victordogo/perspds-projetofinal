## code to prepare `ocupacao_hospitalar` dataset goes here

library(tidyverse)

ocupacao_hospitalar <- read_csv('https://s3.sa-east-1.amazonaws.com/ckan.saude.gov.br/LEITOS/2022-04-15/esus-vepi.LeitoOcupacao_2021.csv')

ocupacao_hospitalar <- ocupacao_hospitalar |>
  filter(municipio %in% c("São Paulo", "Rio de Janeiro", "Belo Horizonte")) |>
  mutate(data=lubridate::date(dataNotificacao)) |>
  group_by(data,municipio) |>
  distinct(data,municipio, .keep_all = TRUE) |>
  summarise(
    across(
      .cols=ocupacaoSuspeitoCli:saidaConfirmadaAltas,
      .fns=~sum(.x, na.rm=TRUE)
    )
  )

readr::write_rds(ocupacao_hospitalar, 'data/ocupacao_hospitalar.rds')

