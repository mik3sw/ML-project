getStats <- function(predictions, reference, modeltype){
  t <- table(predictions, reference)
  levLength <- length(levels(reference))
  sum <- t[1]
  index <- 1
  for (i in 2:levLength) {
    index <- index + levLength + 1
    sum <- sum + t[index]
    #print(index)
  }
  
  accuracy = sum/length(reference)
  
  confusion_matrix <- confusionMatrix(predictions, reference)
  precision <- confusion_matrix$byClass[,"Precision"]
  recall <- confusion_matrix$byClass[,"Recall"]
  f1_measure <- confusion_matrix$byClass[,"F1"]
  
  cat("================================\n")
  cat("|  Laptop Dataset Predictions  |\n")
  cat("================================\n")
  cat("|       Dati Semplificati      |\n")
  cat("================================\n")
  cat("MODEL: ", modeltype, "\n")
  cat("Confusion Matrix:\n")
  print(t)
  cat("\n================================\n")
  cat("Accuracy: ", round(accuracy,2), "\n")
  cat("Precision: ", round(precision,2), "\n")
  cat("Recall: ", round(recall,2), "\n")
  cat("F1 Measure: ", round(f1_measure,2), "\n")
  cat("================================\n")
}

# MODELLO SVM
testSVM <- function(train_data, test_data){
  formula <- range ~ .
  model <- svm(formula, data=train_data, kernel="linear", cost=100, probability = TRUE)
  predictions <- predict(model, test_data)
  getStats(predictions, test_data$range, "SVM")
  return(model)
}

# MODELLO NAIVE BAYES
testNaiveBayes <- function(train_data, test_data){
  model <- naiveBayes(train_data, train_data$range)
  predictions <- predict(model, test_data)
  getStats(predictions, test_data$range, "NAIVE BAYES")
  return(model)
}

# MODELLO ALBERO DECISIONALE
testDecisionalTree <- function(train_data, test_data){
  formula <- range ~ .
  model <- rpart(formula, data = train_data)
  predictions <- predict(model, newdata = test_data, type = "class")
  getStats(predictions, test_data$range, "TREE")
  #library(rpart.plot)
  #rpart.plot(model, cex=0.6)
  return(model)
}

# MODELLO RANDOM FOREST
testRandomForest <- function(train_data, test_data){
  library(randomForest)
  formula <- range ~ .
  model <- randomForest(formula, data=train_data, na.action=na.fail, ntree=1000)
  predictions <- predict(model, test_data)
  getStats(predictions, test_data$range, "RANDOM FOREST")
  return(model)
}



