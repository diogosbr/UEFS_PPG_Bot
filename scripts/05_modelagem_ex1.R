# Carregando os pacotes ---------------------------------------------------
library(raster)
library(dismo)


# Carregando as variáveis abioticas
lista <- list.files("dados/abioticos/selecionados/", pattern = "tif$", full.names = TRUE)

preditoras <- stack(lista)
preditoras

# Carregando as ocorrências
occ <- read.csv("dados/ocorrencias/ocorrencias_modelagem.csv")

head(occ)
dim(occ)

# Avaliando o modelo ------------------------------------------------------

# Gerando pontos de pseudoausencia
ausencias <- randomPoints(mask = preditoras[[1]], n = 1000, p = occ)

# Número de pontos para treino
n_treino <- nrow(occ) * 0.8

# Indice dos registros selecionados para treino
indices <- sample(1:nrow(occ), n_treino)

# Dividindo em treino e teste
occ_treino <- occ[indices,]
occ_teste <- occ[-indices,]
ausencias_treino <- ausencias[indices,]
ausencias_teste <- ausencias[-indices,]

# Gerando o modelo com algoritmo bioclim
modelo_maxent <- maxent(preditoras, occ_treino)

# Projetando o modelo
modelo_proj <- predict(preditoras, modelo_maxent)

# Avaliando o modelo
aval <- evaluate(p = occ_teste, a = ausencias_teste,
                 model = modelo_maxent, x = preditoras)

aval@presence
aval@auc
aval@prevalence
max((aval@TPR + aval@TNR) - 1) #TSS

# Generate a nice color ramp and plot the map
par(mar = c(0,0,0,0))
my.colors = colorRampPalette(c("#5E85B8","#EDF0C0","#C13127"))
plot(modelo_proj, col = my.colors(1000), axes = FALSE, box = FALSE)
