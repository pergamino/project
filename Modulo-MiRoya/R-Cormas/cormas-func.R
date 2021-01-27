library(httr)
library(xml2)
library(ggplot2)
library(dplyr)
library(tidyr)
#------------------------#
#-- GLOB VARIABLES ------#
#------------------------#

ADDRESS <- "localhost"

requestHead <- "<SOAP-ENV:Envelope xmlns:ns=\"urn:vwservices\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"><SOAP-ENV:Body>"

requestTail <- 	"</SOAP-ENV:Body> </SOAP-ENV:Envelope>"

#---------------------------#
#-- REQUEST FORMATING ------#
#---------------------------#

formatRequest <- function(functionName, argNames, argValues){
request <- paste0(requestHead, "<ns:",functionName,">")
args <- mapply(includeArg,argNames,argValues)
request <- paste(request, paste(c(args),collapse=" "))
request <- paste0(request, "</ns:",functionName,">",requestTail)
return(request)
}

includeArg <- function(name, value){
return <- (paste0("<ns:",name,">",value,"</ns:",name,">"))
}

askCormas <- function(functionName, argNames = c(), argValues = c()) {
request <- formatRequest(functionName, argNames, argValues)
result <- POST(paste0("http://",ADDRESS,":4920/CormasWS"), body = request)
return(list(request,result))
}

#----------------------------#
#-- VISUAL WORKS SETTING ----#
#----------------------------#

openViwualWorks <- function(GUI = T) {
  if(GUI) {
    system(paste0("$VISUALWORKS",
                  "/bin/linux86/visual ", 
                  "$VISUALWORKS",
                  "/cormas/cormasMac-com-work.im > ",
                  " $VISUALWORKS", 
                  "/cormas/r-cormas.log &"))
  }
  else {
    system(paste0("$VISUALWORKS",
                  "/bin/linux86/visual ", 
                  "$VISUALWORKS",
                  "/cormas/cormasMac-com-work.im",
                  " -headless > ",
                  " $VISUALWORKS", 
                  "/cormas/r-cormas.log &"))
  }
}

closeVisualWorks <- function(){
  askCormas("quitVisualWorks")
  #quitVisual works doit ?tre impl?ment? dans le serveur et faire: ObjectMemory quit.
}

#----------------------------#
#-- R-Cormas functions ------#
#----------------------------#

openCormas <- function(){
return(askCormas("SayHello"))
}

openModel <- function(modelName,parcelFile=paste0(modelName,".pcl")){
return(askCormas("LoadModelFromParcelName",
	argNames=c("modelName","parcelFileName"),
	argValues=c(modelName,parcelFile)))
}

setInit <- function(initMethod = "init"){
return(askCormas("SetInit",
	argNames=c("initMethod"),
	argValues=c(initMethod)))
}

setStep <- function(stepMethod = "step:"){
return(askCormas("SetStep",
	argNames=c("stepMethod"),
	argValues=c(stepMethod)))
}

runSimu <- function(duration = 100){
return(askCormas("RunSimu",
	argNames=c("duration"),
	argValues=c(duration)))
}

activateProbe <- function(probeName, className){
return(askCormas("ActivateProbeOfClass",
	argNames=c("probeName", "className"),
	argValues=c(probeName, className)))
}

getProbe <- function(probeName, className){
return(askCormas("GetProbeOfClass",
	argNames=c("probName", "className"),
	argValues=c(probeName, className)))
}

getNumericProbe <- function(probeName, className){
 answer <- getProbe(probeName, className)[[2]]
 res <- xml_double(xml_contents(xml_find_all(content(answer),
			xpath="//*/ns:result/*")))
	return(res)
}

setNumericAttributeValue <- function(attributeName, className, value){
return(askCormas("SetAttributeOfClassValue",
	argNames=c("attName", "className", "value"),
	argValues=c(attributeName, className, value)))
}

setStringAttributeValue <- function(attributeName, className, value){
return(askCormas("SetStringAttributeOfClassStringValue",
	argNames=c("attName", "className", "value"),
	argValues=c(attributeName, className, value)))
}



