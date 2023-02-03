loadDB <- function(sourcedir, type=4){
  data <- read.csv("dataset/laptop_price.csv")
  data <- data[!duplicated(data), ]
  data <- makeMemoryColumn(data)
  
  if(type==4){
    data <- makeRangeColumn(data)
  }
  if(type==3){
    data <- makeRangeColumn2(data)
  }
  else{
    data <- makeRangeColumn(data)
  }
  
  
  # Rendo weight e RAM una colonna numerica
  data$Weight <- str_replace_all(data$Weight, "kg", "")
  data$Weight <- as.numeric(data$Weight)
  data$RamGB <- as.numeric(gsub("[^[:digit:]]","",data$Ram))
  
  # Pulisco la colonna dei Prodotti dai valori non ASCII
  # perche' con alcuni valori ci dava problemi durante
  # la creazione del modello
  data$Product <- sapply(data$Product, iconv, "UTF-8", "ASCII", sub = "")
  
  data <- makeGpuColumn(data)
  data <- makeCpuColumn(data)
  data <- makeScreenColumn(data)
  data <- makeOsColumn(data)
  
  data <- factorize(data)
  
  data <- data[-c(1,3,7:9,12)]
  
  
  
}



# Memoria Interna (ROM)
# Analizzo la colonna identificando i tipi di memoria presenti
# (SSD, HDD, ecc..) e analizzandone la quantita'
# ==============================================================================
makeMemoryColumn <- function(data){
  data$Memory <- str_replace_all(data$Memory, "GB", "")
  data$Memory <- str_replace_all(data$Memory, "TB", "000")
  
  valori_divisi <- str_split(data$Memory, " \\+ ")
  data$firstHD <- unlist(lapply(valori_divisi, "[",1))
  data$secondHD <- unlist(lapply(valori_divisi, "[",2))
  
  data$HDD1 <- ifelse(grepl("HDD", data$firstHD),1,0)
  data$SSD1 <- ifelse(grepl("SSD", data$firstHD),1,0)
  data$Hybrid1 <- ifelse(grepl("Hybrid", data$firstHD),1,0)
  data$FlashStorage1 <- ifelse(grepl("Flash Storage", data$firstHD),1,0)
  
  data$secondHD[is.na(data$second)] <- 0
  
  data$HDD2 <- ifelse(grepl("HDD", data$secondHD),1,0)
  data$SSD2 <- ifelse(grepl("SSD", data$secondHD),1,0)
  data$Hybrid2 <- ifelse(grepl("Hybrid", data$secondHD),1,0)
  data$FlashStorage2 <- ifelse(grepl("Flash Storage", data$secondHD),1,0)
  
  data$firstHD <- as.numeric(gsub("[^[:digit:]]","",data$firstHD))
  data$secondHD <- as.numeric(gsub("[^[:digit:]]","",data$secondHD))
  
  
  data$HDD <- (data$firstHD * data$HDD1 + data$secondHD * data$HDD2)
  data$SSD <- (data$firstHD * data$SSD1 + data$secondHD * data$SSD2)
  data$Hybrid <- (data$firstHD * data$Hybrid1 + data$secondHD * data$Hybrid2)
  data$FlashStorage <- (data$firstHD * data$FlashStorage1 
                        + data$secondHD * data$FlashStorage2)
  
  # Rimuovo colonne inutilizzate
  data <- data[-c(9, 14:23, 26, 27)]
  return(data)
}
# ==============================================================================


# Range
# ==============================================================================
makeRangeColumn <- function(data){
  #data <- data[data$Price_euros <= 3000, ]
  data$range <- data$Price_euros
  
  data$range[data$range >= 0 & data$range < 500] <- 1
  data$range[data$range >= 500 & data$range < 1000] <- 2
  data$range[data$range >= 1000 & data$range < 2000] <- 3
  data$range[data$range >= 2000] <- 4
  
  #data$range[data$range >= 1000] <- 3
  
  data$range <- factor(data$range, levels = c(1,2,3,4), labels = c("Fascia Bassa", "Fascia Media", "Fascia Alta", "Fascia Premium"))
  #data$range <- factor(data$range, levels = c(1,2,3), labels = c("Fascia Bassa", "Fascia Media", "Fascia Alta"))
  # data$range <- as.factor(data$range)
  # plot(data$range)
  return(data)
}

makeRangeColumn2 <- function(data){
  #data <- data[data$Price_euros <= 3000, ]
  data$range <- data$Price_euros
  
  data$range[data$range >= 0 & data$range < 500] <- 1
  data$range[data$range >= 500 & data$range < 1000] <- 2
  data$range[data$range >= 1000] <- 3
  
  #data$range <- factor(data$range, levels = c(1,2,3,4), labels = c("Fascia Bassa", "Fascia Media", "Fascia Alta", "Fascia Premium"))
  data$range <- factor(data$range, levels = c(1,2,3), labels = c("Fascia Bassa", "Fascia Media", "Fascia Alta"))
  # data$range <- as.factor(data$range)
  # plot(data$range)
  return(data)
}
# ==============================================================================



# Gpu Vendor
# Tipo di GPU, in modo da scremare le gpu dal modello preciso
# mantiene informazioni importanti come produttore e serie
# es: (Nvidia GTX)
# ==============================================================================
makeGpuColumn <- function(data){
  data$Gpu <- str_replace_all(data$Gpu, "GeForce GTX", "GTX ")
  data$Gpu_Vendor <- sapply(strsplit(data$Gpu, " "), 
                            function(x) paste(x[1],x[2],sep=" "))
  return(data)
}
# ==============================================================================


# Cpu model
# se "AMD A" o "AMD E" nel nome allora AMD low end CPU
# se "AMD Ryzen" nel nome allora High end
# se "Intel Celeron" o "Intel Atom" o "Intel Pentium" allora Intel low end CPU
# ==============================================================================
makeCpuColumn <- function(data){
  data$Cpu <- gsub("AMD A.*", "AMD low end", data$Cpu)
  data$Cpu <- gsub("AMD E.*", "AMD low end", data$Cpu)
  data$Cpu <- gsub("AMD Ryzen.*", "AMD high end", data$Cpu)
  data$Cpu <- gsub("AMD FX.*", "AMD mid end", data$Cpu)
  data$Cpu <- gsub("Intel Celeron.*", "Intel low end", data$Cpu)
  data$Cpu <- gsub("Intel Atom.*", "Intel low end", data$Cpu)
  data$Cpu <- gsub("Intel Pentium.*", "Intel low end", data$Cpu)
  data$Cpu <- gsub("Intel Xeon.*", "Intel high end", data$Cpu)
  
  data$Cpu_model <- sapply(strsplit(data$Cpu, " "),  
                           function(x) paste(x[1],x[2],x[3],sep=" "))
  return(data)
}
# ==============================================================================


# Risoluzione dello schermo
# Crea la colonna "isTouchScreen" di tipo binario
# e semplifica le classi presenti in ScreenResolution
# ==============================================================================
makeScreenColumn <- function(data){
  data$isTouchScreen <- data$ScreenResolution
  data$isTouchScreen <- ifelse(grepl("Touchscreen", data$isTouchScreen),"TRUE","FALSE")
  data$isIPS <- data$ScreenResolution
  data$isIPS <- ifelse(grepl("IPS", data$isIPS),"TRUE","FALSE")
  ggplot(data, aes(x = range)) + geom_bar(aes(fill = range)) + facet_wrap(~ isTouchScreen)
  
  data$ScreenResolution <- ifelse(grepl("Retina Display", data$ScreenResolution),"Retina Display",data$ScreenResolution)
  data$ScreenResolution <- ifelse(grepl("4K", data$ScreenResolution),"4K",data$ScreenResolution)
  data$ScreenResolution <- ifelse(grepl("FHD", data$ScreenResolution),"FHD",data$ScreenResolution)
  data$ScreenResolution <- ifelse(grepl("HD+", data$ScreenResolution),"QHD",data$ScreenResolution)
  
  data$ScreenResolution <- gsub(".*1366.*", "HD", data$ScreenResolution)
  data$ScreenResolution <- gsub(".*1920.*", "FHD", data$ScreenResolution)
  data$ScreenResolution <- gsub(".*1440.*", "2K", data$ScreenResolution)
  data$ScreenResolution <- gsub(".*1600.*", "2K", data$ScreenResolution)
  data$ScreenResolution <- gsub(".*3840.*", "4K", data$ScreenResolution)
  data$ScreenResolution <- gsub(".*2560.*", "2K", data$ScreenResolution)
  data$ScreenResolution <- gsub(".*3200.*", "4K", data$ScreenResolution)
  data$ScreenResolution <- gsub(".*2236.*", "2K", data$ScreenResolution)
  data$ScreenResolution <- gsub(".*2400.*", "2K", data$ScreenResolution)
  data$ScreenResolution <- gsub(".*2880.*", "2K", data$ScreenResolution)
  data$ScreenResolution <- gsub(".*2736.*", "2K", data$ScreenResolution)
  data$ScreenResolution <- gsub(".*2256.*", "2K", data$ScreenResolution)
  data$ScreenResolution <- as.factor(data$ScreenResolution)
  #levels(data$ScreenResolution)
  return(data)
}
# ==============================================================================


# OS
# Semplificazione delle classi del sistema operativo
# ==============================================================================
makeOsColumn <- function(data){
  
  data$OpSys <- str_replace_all(data$OpSys, "Windows 10", "Windows")
  data$OpSys <- str_replace_all(data$OpSys, "Windows 10 S", "Windows")
  data$OpSys <- str_replace_all(data$OpSys, "Windows S", "Windows")
  data$OpSys <- str_replace_all(data$OpSys, "Windows 7", "Windows")
  data$OpSys <- str_replace_all(data$OpSys, "Mac OS X", "Mac")
  data$OpSys <- str_replace_all(data$OpSys, "macOS", "Mac")
  data$OpSys <- str_replace_all(data$OpSys, "Linux", "Linux/Other")
  data$OpSys <- str_replace_all(data$OpSys, "Android", "Linux/Other")
  data$OpSys <- str_replace_all(data$OpSys, "No OS", "Linux/Other")
  data$OpSys <- str_replace_all(data$OpSys, "Chrome OS", "Linux/Other")
  return(data)
}
# ==============================================================================


factorize <- function(data){
  data$Company <- as.factor(data$Company)
  data$Product <- as.factor(data$Product)
  data$TypeName <- as.factor(data$TypeName)
  data$ScreenResolution <- as.factor(data$ScreenResolution)
  data$Cpu <- as.factor(data$Cpu)
  data$Ram <- as.factor(data$Ram)
  #data$Memory <- as.factor(data$Memory)
  data$Gpu <- as.factor(data$Gpu)
  data$OpSys <- as.factor(data$OpSys)
  data$Inches <- as.factor(data$Inches)
  #data$storage_type<- as.factor(data$storage_type)
  data$Gpu_Vendor<- as.factor(data$Gpu_Vendor)
  data$Cpu_model <- as.factor(data$Cpu_model)
  data$isTouchScreen <- as.factor(data$isTouchScreen)
  data$RamGB <- as.numeric(data$RamGB)
  return(data)
}
