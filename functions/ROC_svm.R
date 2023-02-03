library(pROC)

svmroc <- function(modelSVM, test_data){
  predictions_prob <- predict(modelSVM, test_data, probability = TRUE)
  
  frame_SVM <- test_data
  frame_SVM$fBassa_true <- test_data$range
  frame_SVM$fBassa_true <- as.character(frame_SVM$fBassa_true)
  frame_SVM$fBassa_true[frame_SVM$fBassa_true != "Fascia Bassa"] <- 0
  frame_SVM$fBassa_true[frame_SVM$fBassa_true == "Fascia Bassa"] <- 1
  
  frame_SVM$fMedia_true <- test_data$range
  frame_SVM$fMedia_true <- as.character(frame_SVM$fMedia_true)
  frame_SVM$fMedia_true[frame_SVM$fMedia_true != "Fascia Media"] <- 0
  frame_SVM$fMedia_true[frame_SVM$fMedia_true == "Fascia Media"] <- 1
  
  frame_SVM$fAlta_true <- test_data$range
  frame_SVM$fAlta_true <- as.character(frame_SVM$fAlta_true)
  frame_SVM$fAlta_true[frame_SVM$fAlta_true != "Fascia Alta"] <- 0
  frame_SVM$fAlta_true[frame_SVM$fAlta_true == "Fascia Alta"] <- 1
  
  frame_SVM$fPremium_true <- test_data$range
  frame_SVM$fPremium_true <- as.character(frame_SVM$fPremium_true)
  frame_SVM$fPremium_true[frame_SVM$fPremium_true != "Fascia Premium"] <- 0
  frame_SVM$fPremium_true[frame_SVM$fPremium_true == "Fascia Premium"] <- 1
  frame_SVM$fBassa_true <- as.numeric(frame_SVM$fBassa_true)
  frame_SVM$fMedia_true <- as.numeric(frame_SVM$fMedia_true)
  frame_SVM$fAlta_true <- as.numeric(frame_SVM$fAlta_true)
  frame_SVM$fPremium_true <- as.numeric(frame_SVM$fPremium_true)
  
  frame_SVM <- frame_SVM[-c(1:13)]
  
  frame_SVM$fBassa_pred_SVM <- attr(predictions_prob, "probabilities")[,1]
  frame_SVM$fMedia_pred_SVM <- attr(predictions_prob, "probabilities")[,2]
  frame_SVM$fAlta_pred_SVM <- attr(predictions_prob, "probabilities")[,3]
  frame_SVM$fPremium_pred_SVM <- attr(predictions_prob, "probabilities")[,4]
  
  frameB <- frame_SVM$fBassa_true
  frameBp <- frame_SVM$fBassa_pred_SVM
  
  par(pty = "s")
  roc_curve <- roc(frameB, frameBp, 
                   legacy.axes = TRUE, 
                   xlab = "False Positive Rate", 
                   ylab = "True Positive Rate", 
                   col = "#377eb8")
  
  plot(roc_curve, main ="Fascia Bassa", legacy.axes = TRUE,xlab = "False Positive Rate", 
       ylab = "True Positive Rate", 
       col = "#377eb8")
  
  frameB <- frame_SVM$fMedia_true
  frameBp <- frame_SVM$fMedia_pred_SVM
  
  par(pty = "s")
  roc_curve <- roc(frameB, frameBp, 
                   legacy.axes = TRUE, 
                   xlab = "False Positive Rate", 
                   ylab = "True Positive Rate", 
                   col = "#377eb8")
  
  plot(roc_curve, main ="Fascia Media", legacy.axes = TRUE,xlab = "False Positive Rate", 
       ylab = "True Positive Rate", 
       col = "#377eb8")
  
  frameB <- frame_SVM$fAlta_true
  frameBp <- frame_SVM$fAlta_pred_SVM
  
  par(pty = "s")
  roc_curve <- roc(frameB, frameBp, 
                   legacy.axes = TRUE, 
                   xlab = "False Positive Rate", 
                   ylab = "True Positive Rate", 
                   col = "#377eb8")
  plot(roc_curve, main ="Fascia Alta", legacy.axes = TRUE,xlab = "False Positive Rate", 
       ylab = "True Positive Rate", 
       col = "#377eb8")
  
  
  frameB <- frame_SVM$fPremium_true
  frameBp <- frame_SVM$fPremium_pred_SVM
  
  par(pty = "s")
  roc_curve <- roc(frameB, frameBp, 
                   legacy.axes = TRUE, 
                   xlab = "False Positive Rate", 
                   ylab = "True Positive Rate", 
                   col = "#377eb8")
  plot(roc_curve, main ="Fascia Premium", legacy.axes = TRUE,xlab = "False Positive Rate", 
       ylab = "True Positive Rate", 
       col = "#377eb8")
  
}


