# ----------------------------------------------------
# 0. Configurar directorio de trabajo
# ----------------------------------------------------
setwd("D:/CESUR DAM/Segundo/HLC BigData/CP2")

# ----------------------------------------------------
# 1. Cargar librerías necesarias
# ----------------------------------------------------
library(dplyr)
library(ggplot2)

# ----------------------------------------------------
# 2. Cargar el dataset
# ----------------------------------------------------
data <- read.csv("features_sample.csv")

# Ver estructura básica
str(data)

# ----------------------------------------------------
# 3. Seleccionar solo variables numéricas
# ----------------------------------------------------
numeric_data <- data %>% select_if(is.numeric)

# ----------------------------------------------------
# 4. LIMPIEZA para evitar errores en clustering
# ----------------------------------------------------

# 4.1 Quitar columnas con NA, NaN o Inf
numeric_data <- numeric_data %>% 
  select_if(~ all(is.finite(.)))

# 4.2 Quitar columnas constantes (sd = 0)
sd_values <- apply(numeric_data, 2, sd)
numeric_data <- numeric_data[, sd_values != 0]

# ----------------------------------------------------
# 5. Escalar datos limpios
# ----------------------------------------------------
scaled_data <- scale(numeric_data)

# ----------------------------------------------------
# 6. Probar modelos K-means con diferentes k
# ----------------------------------------------------
set.seed(123)

k2 <- kmeans(scaled_data, centers = 2, nstart = 20)
k3 <- kmeans(scaled_data, centers = 3, nstart = 20)
k4 <- kmeans(scaled_data, centers = 4, nstart = 20)

# Comparar métricas
k2$tot.withinss
k3$tot.withinss
k4$tot.withinss

# ----------------------------------------------------
# 7. Clustering jerárquico (Ward.D2)
# ----------------------------------------------------
dist_matrix <- dist(scaled_data)
hc <- hclust(dist_matrix, method = "ward.D2")

# Dendrograma
plot(hc, main = "Dendrograma (Ward.D2)", xlab = "", sub = "")

# Cortar en 3 clústeres
clusters_hc <- cutree(hc, k = 3)

# ----------------------------------------------------
# 8. Añadir resultados al dataset original
# ----------------------------------------------------
data$cluster_k3 <- k3$cluster
data$cluster_hc <- clusters_hc

# ----------------------------------------------------
# 9. Visualización de los clústeres
# ----------------------------------------------------
ggplot(data, aes(x = zcr, y = zcr.1, color = as.factor(cluster_k3))) +
  geom_point(alpha = 0.6) +
  labs(title = "Clustering K-means (k = 3)",
       x = "ZCR",
       y = "ZCR (2)",
       color = "Cluster")



