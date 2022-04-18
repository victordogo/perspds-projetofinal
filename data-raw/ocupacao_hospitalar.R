## code to prepare `ocupacao_hospitalar` dataset goes here

library(tidyverse)

# Lendo banco de dados do datasus

ocupacao_hospitalar <- read_csv('https://s3.sa-east-1.amazonaws.com/ckan.saude.gov.br/LEITOS/2022-04-15/esus-vepi.LeitoOcupacao_2021.csv')

# Tratando banco de dados

ocupacao_hospitalar <- ocupacao_hospitalar |>
  filter(municipio %in% c("São Paulo", "Rio de Janeiro", "Belo Horizonte")) |> # selecionando sao paulo, rio de janeiro e bh
  mutate(data=lubridate::date(dataNotificacao)) |> # extraindo data
  group_by(data,municipio) |>
  distinct(data,municipio, .keep_all = TRUE) |>
  summarise(
    across(
      .cols=ocupacaoSuspeitoCli:saidaConfirmadaAltas,
      .fns=~sum(.x, na.rm=TRUE)
    )
  ) # somando ocorrencias de todos os hospitais das tres cidades

# Exportando banco de dados

readr::write_rds(ocupacao_hospitalar, 'data/ocupacao_hospitalar.rds')

# Criando banco de dados acumulados

ocupacao_hospitalar_cumsum <- ocupacao_hospitalar |>
  group_by(municipio) |>
  mutate(
    across(
      .cols=ocupacaoSuspeitoCli:saidaConfirmadaAltas,
      .fns=~cumsum(.x)
    )
  )

# Exportando banco de dados

readr::write_rds(ocupacao_hospitalar_cumsum,
                 'data/ocupacao_hospitalar_cumsum.rds')
