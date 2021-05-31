# Carregando os pacotes ---------------------------------------------------
library(raster)

lista_abio <- list.files("dados/abioticos/presente/raw/", full.names = TRUE)

for (i in seq_along(lista_abio)) {
  temp <- raster(lista_abio[i])
  temp <- aggregate(temp, 2)
  writeRaster(temp, filename = paste0("dados/abioticos/presente/", basename(lista_abio[i])),
              options = "COMPRESS=DEFLATE", overwrite = TRUE)
}


temp <- raster(lista_abio[1])
# Generate a nice color ramp and plot the map
my.colors = colorRampPalette(c("#5E85B8","#EDF0C0","#C13127"))
plot(temp,col=my.colors(1000),axes=FALSE, box=FALSE)
