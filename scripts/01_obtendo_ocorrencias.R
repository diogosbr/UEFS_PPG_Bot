# Carregando os pacotes ---------------------------------------------------

library(rgbif)
library(dplyr)

# Obtendo os pontos de ocorrência -----------------------------------------

# occ_raw <- occ_search(scientificName = "Guinardia striata",
#                       limit = 1e4, country = "AU",
#                       hasCoordinate = TRUE)

occ_raw <- occ_search(scientificName = "Guinardia striata",
                      limit = 1e4, #country = "AU",
                      hasCoordinate = TRUE)

# Verificando a estrutura do dado
names(occ_raw)

# Dados baixados
names(occ_raw$data)

# Selecionado os dados de interesse
occ <- occ_raw$data %>% select(species, decimalLongitude, decimalLatitude)

# Verificando os dados selecionados
occ

# Visualizando os dados selecionados
View(occ)

# Plotando os pontos
par(mar = c(0,0,0,0))
maps::map(fill = T, col = "gray80", border = F)
maps::map.axes()
distinct(occ) %>% select(-species) %>% points(col = "darkred", pch = 16)

# Zoom nos pontos
maps::map(fill = T, col = "gray80", border = F,
          xlim = range(occ$decimalLongitude) * c(0.9,1.1),
          ylim = range(occ$decimalLatitude) * c(1.1,0.9) )
maps::map.axes()
distinct(occ) %>% select(-species) %>% points(col = "darkred", pch = 16)

# Salvando a tabela no disco rígido
write.csv(occ, "dados/ocorrencias/ocorrencias_bruta.csv", row.names = FALSE)
