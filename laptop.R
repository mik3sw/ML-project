# ==============================================================================
# PROGETTO MACHINE LEARNING FEBBRAIO 2023
# ==============================================================================
# Gruppo:
# - Michele Angelo Marcucci 851905
# - Davide Mazzitelli       851657
# ==============================================================================
# Database:
# - Fasce di prezzo dei laptop
# ==============================================================================


# Importazione librerie 
# ==============================================================================
setwd("C:\\Users\\sosjj\\OneDrive\\Desktop\\ML-project\\ML-project")
library(caret)
library(e1071)
library(class)
library(dplyr)
library(rpart)
library(base)
library(ggplot2)
library(stringr)
# ==============================================================================


# Caricamento delle funzioni
# ==============================================================================
source("functions\\pca.R")
source("functions\\models.R")
source("functions\\ROC_dt.R")
source("functions\\ROC_rf.R")
source("functions\\ROC_svm.R")
# ==============================================================================


# Carica il Dataset + Preprocessing
# ==============================================================================
data <- loadDB("dataset/laptop_price.csv", type=4)
# ==============================================================================


# Grafici opzionali per visualizzare le distribuzioni per fascia
# ==============================================================================
plot(data$range)
ggplot(data, aes(x = range)) + geom_bar(aes(fill = range)) + facet_wrap(~ RamGB)
ggplot(data, aes(x = range)) + geom_bar(aes(fill = range)) + facet_wrap(~ OpSys)
ggplot(data, aes(x = range)) + geom_bar(aes(fill = range)) + facet_wrap(~ Gpu_Vendor)
ggplot(data, aes(x = range)) + geom_bar(aes(fill = range)) + facet_wrap(~ Weight)
ggplot(data, aes(x = range)) + geom_bar(aes(fill = range)) + facet_wrap(~ Cpu_model)
ggplot(data, aes(x = range)) + geom_bar(aes(fill = range)) + facet_wrap(~ ScreenResolution)
ggplot(data, aes(x = range)) + geom_bar(aes(fill = range)) + facet_wrap(~ isTouchScreen)
ggplot(data, aes(x = range)) + geom_bar(aes(fill = range)) + facet_wrap(~ isIPS)

library(plotly)
p <- plot_ly(train_data, x = ~Cpu_model, y = ~SSD, z = ~RamGB, color = ~range) %>%
  add_markers()
p

# ==============================================================================


# Divisione in dataset di train e di test
# ==============================================================================
set.seed(123)
ind <- sample(2, nrow(data), replace=TRUE, prob=c(0.7, 0.3))
test_data <- data[ind==2, ]
train_data <- data[ind==1, ]
# ==============================================================================


# Tutti i modelli che abbiamo testato con rispettive stats
# ==============================================================================
modelSVM <- testSVM(train_data, test_data)
ggplotConfusionMatrix(confusionMatrix(predict(modelSVM, newdata = test_data, type = "class"), test_data$range))

modelTree <- testDecisionalTree(train_data, test_data)
ggplotConfusionMatrix(confusionMatrix(predict(modelTree, newdata = test_data, type = "class"), test_data$range))

modelRF <- testRandomForest(train_data, test_data)
ggplotConfusionMatrix(confusionMatrix(predict(modelRF, newdata = test_data, type = "class"), test_data$range))

# ==============================================================================


# ROC e AUC
# ==============================================================================
dtroc(modelTree, test_data)
rfroc(modelRF, test_data)
svmroc(modelSVM, test_data)

# plot multiple curve roc: plot(add = true)

# ==============================================================================
