# Instalação e Carregamento dos Pacotes -----------

pacotes <- c("RJSONIO","plyr", "dplyr", "RODBC", "tidyverse")

if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}


#transforma o dia anterior em string
datapesquisa <- toString(Sys.Date() - 1, width = NULL)

#concatenação da API Inmet com a data
base_url <- paste("https://apitempo.inmet.gov.br/estacao/dados/",datapesquisa, sep = "")

#baixa o json para uma lista
dados <- fromJSON(base_url)

#transforma a lista em dataframe
base_inmet <- data.frame(t(sapply(dados,c)))

#remove a coluna DC_NOME do dataframe
base_inmet <- select(base_inmet, -c(DC_NOME
                                              , UF))

#orderna o dataframe pelo nome das colunas
base_inmet <- base_inmet[, sort(names(base_inmet))]

#conexão com banco
db_conn <- odbcConnect("LocalDSN", rows_at_time = 1)

if(db_conn == -1) {
  # For a Production system, I would add in some logging
  quit("no", 1)
}

#insere tabela
sqlSave(db_conn, base_inmet, rownames = F)

#fecha conexão com banco
odbcClose(db_conn)



