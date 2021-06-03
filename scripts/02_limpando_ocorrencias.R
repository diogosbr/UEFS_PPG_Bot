# Carregando os pacotes ---------------------------------------------------
library(raster)
library(dismo)
library(dplyr)
library(CoordinateCleaner)

# Importando os pontos de ocorrência --------------------------------------
occ_raw <- read.table("dados/ocorrencias/ocorrencias_bruta.csv", header = TRUE, sep = ",")

# Verifica inicio ...
head(occ_raw)

# ... e final da tabela
tail(occ_raw)

# Número de ocorrências totais
nrow(occ_raw)

# Salvando o tabela com os registros únicos
occ_unique <- cc_dupl(occ_raw, species = "species",
                      lon = 'decimalLongitude', lat = 'decimalLatitude')

# Número de ocorrências unicas
nrow(occ_unique)

# Removendo a coluna de espécie
occ_unique <- occ_unique[,-1]

# Importando uma variavel preditora
var1 <- raster('dados/abioticos/selecionados/Phosphate.Range.tif')

# Salvando o tabela com os registros únicos
occ_modelagem <- gridSample(occ_unique, var1, n = 1)

# Removendo dados com 'NA'

# Número de ocorrências unicas por pixel
nrow(occ_modelagem)

# Salvando no disco
write.csv(occ_modelagem, "dados/ocorrencias/ocorrencias_modelagem.csv", row.names = FALSE)
