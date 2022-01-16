# Instalação e Carregamento dos Pacotes -----------

pacotes <- c("RJSONIO","plyr", "dplyr")

if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}

data <- toString(Sys.Date() - 1, width = NULL)

base_url <- paste("https://apitempo.inmet.gov.br/estacao/dados/",data, sep = "")

dados <- fromJSON(base_url)

dadosclimaticos <- data.frame(t(sapply(dados,c)))

dadosclimaticos <- select(dadosclimaticos, -c(DC_NOME))

dadosclimaticos <- dadosclimaticos[, sort(names(dadosclimaticos))]
