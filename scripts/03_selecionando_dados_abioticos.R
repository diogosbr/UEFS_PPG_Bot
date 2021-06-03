# Carregando os pacotes ---------------------------------------------------
library(raster)
library(corrplot)
library(PerformanceAnalytics)
library(caret)

# Listando os arquivos
lista_abio <- list.files("dados/abioticos/presente/", full.names = TRUE)

# Importando as variáveis preditoras
preditoras <- stack(lista_abio)

# Plotando uma variável
plot(preditoras[[1]])

# Criando uma tabela com os valores por pixel
tabela_preditoras <- na.omit(preditoras[])

# Matriz de correlação
cor_mat <- cor(tabela_preditoras)

# Plot da matriz de correlação (exemplo1)
corrplot(cor_mat, method = "number",
         type = "upper", tl.col = "black", tl.srt = 45)

#col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
corrplot(cor_mat, method = "color",
         type = "upper", order = "hclust",
         addCoef.col = "black", # Add coefficient of correlation
         tl.col = "black", tl.srt = 45, #Text label color and rotation
         # hide correlation coefficient on the principal diagonal
         diag = FALSE)

# Plot da matriz de correlação (exemplo2)
#chart.Correlation(tabela_preditoras, histogram = TRUE, pch = 19)

# Selecionando automaticamente
variaveis_remover <- findCorrelation(x = cor_mat, cutoff = 0.7)

# Variaveis a remover
variaveis_remover

# Variaveis selecionadas
names(preditoras)[-variaveis_remover]

# Selecionando as variaveis
preditoras_selecionadas <- preditoras[[-variaveis_remover]]

# Salvando no disco
for(i in 1:nlayers(preditoras_selecionadas)){
  writeRaster(preditoras_selecionadas[[i]],
              filename = paste0("dados/abioticos/selecionados/",
                                names(preditoras_selecionadas)[i], ".tif"),
              options = "COMPRESS=DEFLATE")
}
