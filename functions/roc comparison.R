

# creazione frame DT
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


# creazione frame RF
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


# creazione frame SVM
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


# plot delle ROC - Fascia bassa
frameB <- frame$fBassa_true
frameBp <- frame$fBassa_pred_DT

par(pty = "s")
roc_curve <- roc(frameB, frameBp, 
                 legacy.axes = TRUE, 
                 xlab = "False Positive Rate", 
                 ylab = "True Positive Rate", 
                 col = "#0595f5")
plot(roc_curve, main ="Fascia Bassa", legacy.axes = TRUE,xlab = "False Positive Rate", 
     ylab = "True Positive Rate", 
     col = "#377eb8")

frameB <- frame_RF$fBassa_true
frameBp <- frame_RF$fBassa_pred_RF

par(pty = "s")
roc_curve <- roc(frameB, frameBp, 
                 legacy.axes = TRUE, 
                 xlab = "False Positive Rate", 
                 ylab = "True Positive Rate", 
                 col = "#b83737")
plot(roc_curve, add = TRUE, col = "#f50505")

frameB <- frame_SVM$fBassa_true
frameBp <- frame_SVM$fBassa_pred_SVM

par(pty = "s")
roc_curve <- roc(frameB, frameBp, 
                 legacy.axes = TRUE, 
                 xlab = "False Positive Rate", 
                 ylab = "True Positive Rate", 
                 col = "#377eb8")

plot(roc_curve, add = TRUE, col = "#05f50d")


# plot delle ROC - Fascia media
frameB <- frame$fMedia_true
frameBp <- frame$fMedia_pred_DT

par(pty = "s")
roc_curve <- roc(frameB, frameBp, 
                 legacy.axes = TRUE, 
                 xlab = "False Positive Rate", 
                 ylab = "True Positive Rate", 
                 col = "#0595f5")
plot(roc_curve, main ="Fascia Media", legacy.axes = TRUE,xlab = "False Positive Rate", 
     ylab = "True Positive Rate", 
     col = "#377eb8")

frameB <- frame_RF$fMedia_true
frameBp <- frame_RF$fMedia_pred_RF

par(pty = "s")
roc_curve <- roc(frameB, frameBp, 
                 legacy.axes = TRUE, 
                 xlab = "False Positive Rate", 
                 ylab = "True Positive Rate", 
                 col = "#b83737")
plot(roc_curve, add = TRUE, col = "#f50505")

frameB <- frame_SVM$fBassa_true
frameBp <- frame_SVM$fBassa_pred_SVM

par(pty = "s")
roc_curve <- roc(frameB, frameBp, 
                 legacy.axes = TRUE, 
                 xlab = "False Positive Rate", 
                 ylab = "True Positive Rate", 
                 col = "#377eb8")

plot(roc_curve, add = TRUE, col = "#05f50d")


# plot delle ROC - Fascia alta
frameB <- frame$fAlta_true
frameBp <- frame$fAlta_pred_DT

par(pty = "s")
roc_curve <- roc(frameB, frameBp, 
                 legacy.axes = TRUE, 
                 xlab = "False Positive Rate", 
                 ylab = "True Positive Rate", 
                 col = "#0595f5")
plot(roc_curve, main ="Fascia Alta", legacy.axes = TRUE,xlab = "False Positive Rate", 
     ylab = "True Positive Rate", 
     col = "#377eb8")

frameB <- frame_RF$fAlta_true
frameBp <- frame_RF$fAlta_pred_RF

par(pty = "s")
roc_curve <- roc(frameB, frameBp, 
                 legacy.axes = TRUE, 
                 xlab = "False Positive Rate", 
                 ylab = "True Positive Rate", 
                 col = "#b83737")
plot(roc_curve, add = TRUE, col = "#f50505")

frameB <- frame_SVM$fAlta_true
frameBp <- frame_SVM$fAlta_pred_SVM

par(pty = "s")
roc_curve <- roc(frameB, frameBp, 
                 legacy.axes = TRUE, 
                 xlab = "False Positive Rate", 
                 ylab = "True Positive Rate", 
                 col = "#377eb8")

plot(roc_curve, add = TRUE, col = "#05f50d")


# plot delle ROC - Fascia premium
frameB <- frame$fPremium_true
frameBp <- frame$fPremium_pred_DT

par(pty = "s")
roc_curve <- roc(frameB, frameBp, 
                 legacy.axes = TRUE, 
                 xlab = "False Positive Rate", 
                 ylab = "True Positive Rate", 
                 col = "#0595f5")
plot(roc_curve, main ="Fascia Premium", legacy.axes = TRUE,xlab = "False Positive Rate", 
     ylab = "True Positive Rate", 
     col = "#377eb8")

frameB <- frame_RF$fPremium_true
frameBp <- frame_RF$fPremium_pred_RF

par(pty = "s")
roc_curve <- roc(frameB, frameBp, 
                 legacy.axes = TRUE, 
                 xlab = "False Positive Rate", 
                 ylab = "True Positive Rate", 
                 col = "#b83737")
plot(roc_curve, add = TRUE, col = "#f50505")

frameB <- frame_SVM$fPremium_true
frameBp <- frame_SVM$fPremium_pred_SVM

par(pty = "s")
roc_curve <- roc(frameB, frameBp, 
                 legacy.axes = TRUE, 
                 xlab = "False Positive Rate", 
                 ylab = "True Positive Rate", 
                 col = "#377eb8")

plot(roc_curve, add = TRUE, col = "#05f50d")

