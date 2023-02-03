library(pROC)

dtroc <- function(modelTree, test_data){
  predictions <- predict(modelTree, newdata = test_data, type = "class")
  predictions_prob <- predict(modelTree, test_data, type = "prob")
  
  frame <- test_data
  frame$fBassa_true <- test_data$range
  frame$fBassa_true <- as.character(frame$fBassa_true)
  frame$fBassa_true[frame$fBassa_true != "Fascia Bassa"] <- 0
  frame$fBassa_true[frame$fBassa_true == "Fascia Bassa"] <- 1
  
  frame$fMedia_true <- test_data$range
  frame$fMedia_true <- as.character(frame$fMedia_true)
  frame$fMedia_true[frame$fMedia_true != "Fascia Media"] <- 0
  frame$fMedia_true[frame$fMedia_true == "Fascia Media"] <- 1
  
  frame$fAlta_true <- test_data$range
  frame$fAlta_true <- as.character(frame$fAlta_true)
  frame$fAlta_true[frame$fAlta_true != "Fascia Alta"] <- 0
  frame$fAlta_true[frame$fAlta_true == "Fascia Alta"] <- 1
  
  frame$fPremium_true <- test_data$range
  frame$fPremium_true <- as.character(frame$fPremium_true)
  frame$fPremium_true[frame$fPremium_true != "Fascia Premium"] <- 0
  frame$fPremium_true[frame$fPremium_true == "Fascia Premium"] <- 1
  frame$fBassa_true <- as.numeric(frame$fBassa_true)
  frame$fMedia_true <- as.numeric(frame$fMedia_true)
  frame$fAlta_true <- as.numeric(frame$fAlta_true)
  frame$fPremium_true <- as.numeric(frame$fPremium_true)
  
  frame <- frame[-c(1:13)]
  
  frame$fBassa_pred_DT <- predictions_prob[, 1]
  frame$fMedia_pred_DT <- predictions_prob[, 2]
  frame$fAlta_pred_DT <- predictions_prob[, 3]
  frame$fPremium_pred_DT <- predictions_prob[, 4]
  
  
  frameB <- frame$fBassa_true
  frameBp <- frame$fBassa_pred_DT
  
  par(pty = "s")
  roc_curve <- roc(frameB, frameBp, 
                   legacy.axes = TRUE, 
                   xlab = "False Positive Rate", 
                   ylab = "True Positive Rate", 
                   col = "#377eb8")
  plot(roc_curve, main ="Fascia Bassa", legacy.axes = TRUE,xlab = "False Positive Rate", 
       ylab = "True Positive Rate", 
       col = "#377eb8")
  #roc_curve
  
  frameB <- frame$fMedia_true
  frameBp <- frame$fMedia_pred_DT
  
  par(pty = "s")
  roc_curve <- roc(frameB, frameBp, 
                   legacy.axes = TRUE, 
                   xlab = "False Positive Rate", 
                   ylab = "True Positive Rate", 
                   col = "#377eb8")
  plot(roc_curve, main ="Fascia Media", legacy.axes = TRUE,xlab = "False Positive Rate", 
       ylab = "True Positive Rate", 
       col = "#377eb8")
  #roc_curve
  
  frameB <- frame$fAlta_true
  frameBp <- frame$fAlta_pred_DT
  
  par(pty = "s")
  roc_curve <- roc(frameB, frameBp, 
                   legacy.axes = TRUE, 
                   xlab = "False Positive Rate", 
                   ylab = "True Positive Rate", 
                   col = "#377eb8")
  plot(roc_curve, main ="Fascia Alta", legacy.axes = TRUE,xlab = "False Positive Rate", 
       ylab = "True Positive Rate", 
       col = "#377eb8")
  #roc_curve
  
  
  frameB <- frame$fPremium_true
  frameBp <- frame$fPremium_pred_DT
  
  par(pty = "s")
  roc_curve <- roc(frameB, frameBp, 
                   legacy.axes = TRUE, 
                   xlab = "False Positive Rate", 
                   ylab = "True Positive Rate", 
                   col = "#377eb8")
  plot(roc_curve, main ="Fascia Premium", legacy.axes = TRUE,xlab = "False Positive Rate", 
       ylab = "True Positive Rate", 
       col = "#377eb8")
  #roc_curve
}


