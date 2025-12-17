# Instalar y cargar data.table
if (!require(data.table)) install.packages("data.table")
library(data.table)

# Leer el CSV grande
df <- fread("D:/CESUR DAM/Segundo/HLC BigData/fma_metadata/fma_metadata/features.csv")

# Seleccionar 1000 filas aleatorias
set.seed(123)
df_sample <- df[sample(.N, 1000)]

# Guardar el CSV pequeño
fwrite(df_sample, "D:/CESUR DAM/Segundo/HLC BigData/CP2/features_sample.csv")
