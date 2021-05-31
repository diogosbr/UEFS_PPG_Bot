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

# Criando a tabela com informação ambiental associada
tabela <- extract(preditoras, occ)

head(tabela)
dim(tabela)

# Criando as partições
# part <- kfold(tabela, k = 3)
#
# occ_p1 <- occ[part == 1,]
# occ_p2 <- occ[part == 2,]
# occ_p3 <- occ[part == 3,]

# Gerando o modelo com algoritmo bioclim
modelo_bioclim <- bioclim(preditoras, occ)

# Projetando o modelo
modelo_proj <- predict(preditoras, modelo_bioclim)

# Plotando
plot(modelo_proj)


# Avaliando o modelo ------------------------------------------------------

ausencias <- randomPoints(mask = preditoras[[1]], n = 1000, p = occ)

# Indice dos registros selecionados para treino
indices <- sample(1:nrow(occ), nrow(occ) * 0.8)

# Dividindo em treino e teste
occ_treino <- occ[indices,]
occ_teste <- occ[-indices,]
ausencias_treino <- ausencias[indices,]
ausencias_teste <- ausencias[-indices,]

# Gerando o modelo com algoritmo bioclim
modelo_bioclim <- bioclim(preditoras, occ_treino)

# Projetando o modelo
modelo_proj <- predict(preditoras, modelo_bioclim)

# Avaliando o modelo
aval <- evaluate(p = occ_teste, a = ausencias_teste,
         model = modelo_bioclim, x = preditoras)

aval@presence
aval@auc
aval@prevalence
max((aval@TPR + aval@TNR) - 1) #TSS
