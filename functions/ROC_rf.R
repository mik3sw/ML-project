library(pROC)

rfroc <- function(modelRF, test_data){
  predictions_prob <- predict(modelRF, test_data, type = "prob")
  
  frame_RF <- test_data
  frame_RF$fBassa_true <- test_data$range
  frame_RF$fBassa_true <- as.character(frame_RF$fBassa_true)
  frame_RF$fBassa_true[frame_RF$fBassa_true != "Fascia Bassa"] <- 0
  frame_RF$fBassa_true[frame_RF$fBassa_true == "Fascia Bassa"] <- 1
  
  frame_RF$fMedia_true <- test_data$range
  frame_RF$fMedia_true <- as.character(frame_RF$fMedia_true)
  frame_RF$fMedia_true[frame_RF$fMedia_true != "Fascia Media"] <- 0
  frame_RF$fMedia_true[frame_RF$fMedia_true == "Fascia Media"] <- 1
  
  frame_RF$fAlta_true <- test_data$range
  frame_RF$fAlta_true <- as.character(frame_RF$fAlta_true)
  frame_RF$fAlta_true[frame_RF$fAlta_true != "Fascia Alta"] <- 0
  frame_RF$fAlta_true[frame_RF$fAlta_true == "Fascia Alta"] <- 1
  
  frame_RF$fPremium_true <- test_data$range
  frame_RF$fPremium_true <- as.character(frame_RF$fPremium_true)
  frame_RF$fPremium_true[frame_RF$fPremium_true != "Fascia Premium"] <- 0
  frame_RF$fPremium_true[frame_RF$fPremium_true == "Fascia Premium"] <- 1
  
  frame_RF <- frame_RF[-c(1:13)]
  
  frame_RF$fBassa_pred_RF <- predictions_prob[, 1]
  frame_RF$fMedia_pred_RF <- predictions_prob[, 2]
  frame_RF$fAlta_pred_RF <- predictions_prob[, 3]
  frame_RF$fPremium_pred_RF <- predictions_prob[, 4]
  
  frameB <- frame_RF$fBassa_true
  frameBp <- frame_RF$fBassa_pred_RF
  
  par(pty = "s")
  roc_curve <- roc(frameB, frameBp, 
                   legacy.axes = TRUE, 
                   xlab = "False Positive Rate", 
                   ylab = "True Positive Rate", 
                   col = "#377eb8")
  plot(roc_curve, main ="Fascia Bassa", legacy.axes = TRUE,xlab = "False Positive Rate", 
       ylab = "True Positive Rate", 
       col = "#377eb8")
  
  frameB <- frame_RF$fMedia_true
  frameBp <- frame_RF$fMedia_pred_RF
  
  par(pty = "s")
  roc_curve <- roc(frameB, frameBp, 
                   legacy.axes = TRUE, 
                   xlab = "False Positive Rate", 
                   ylab = "True Positive Rate", 
                   col = "#377eb8")
  plot(roc_curve, main ="Fascia Media", legacy.axes = TRUE,xlab = "False Positive Rate", 
       ylab = "True Positive Rate", 
       col = "#377eb8")
  
  frameB <- frame_RF$fAlta_true
  frameBp <- frame_RF$fAlta_pred_RF
  
  par(pty = "s")
  roc_curve <- roc(frameB, frameBp, 

                   legacy.axes = TRUE, 
                   xlab = "False Positive Rate", 
                   ylab = "True Positive Rate", 
                   col = "#377eb8")
  plot(roc_curve, main ="Fascia Alta", legacy.axes = TRUE,xlab = "False Positive Rate", 
       ylab = "True Positive Rate", 
       col = "#377eb8")
  
  
  frameB <- frame_RF$fPremium_true
  frameBp <- frame_RF$fPremium_pred_RF
  
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

