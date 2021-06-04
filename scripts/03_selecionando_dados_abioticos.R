# Carregando os pacotes ---------------------------------------------------
library(raster)
library(corrplot)
#library(PerformanceAnalytics)
library(dplyr)
library(caret)

# Listando os arquivos
lista_abio <- list.files("dados/abioticos/presente/", full.names = TRUE)

# Importando as variáveis preditoras
preditoras <- stack(lista_abio)

# Plotando uma variável
plot(preditoras[[1]])

# Criando uma tabela com os valores por pixel
tabela_preditoras <- na.omit(preditoras[])

head(tabela_preditoras)
dim(tabela_preditoras)
View(tabela_preditoras)

# Matriz de correlação
cor_mat <- cor(tabela_preditoras)

# Plot da matriz de correlação (exemplo1)
corrplot(cor_mat, method = "number",
         type = "upper", tl.col = "black", tl.srt = 45)

#col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
corrplot(cor_mat, method = "color",
         type = "upper", order = "hclust",
         addCoef.col = "black",
         tl.col = "black", tl.srt = 45,
         diag = FALSE)

# Selecionando automaticamente
variaveis_remover <- findCorrelation(x = cor_mat, cutoff = 0.7)

# Variáveis a remover
variaveis_remover

# Variáveis selecionadas
names(preditoras)[-variaveis_remover]

# Selecionando as variáveis
preditoras_selecionadas <- preditoras[[-variaveis_remover]]

# Nova matriz de correlação
cor_mat_sel <- preditoras_selecionadas %>% values() %>% na.omit() %>% cor()

# Plotando a nova matriz de correlção
corrplot(cor_mat_sel, method = "color",
         type = "upper", order = "hclust",
         addCoef.col = "black",
         tl.col = "black", tl.srt = 45,
         diag = FALSE)

# Salvando as variáveis no disco
for(i in 1:nlayers(preditoras_selecionadas)){
  writeRaster(preditoras_selecionadas[[i]],
              filename = paste0("dados/abioticos/selecionados/",
                                names(preditoras_selecionadas)[i], ".tif"),
              options = "COMPRESS=DEFLATE",
              overwrite = TRUE)
}
