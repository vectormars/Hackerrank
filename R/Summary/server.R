# Version 06/09/2017
# Please report any error messages to ho-pi.lin@fda.hhs.gov with the uploaded file 

list.of.packages <- c("ggplot2", "plyr", "shiny", "scales", "XLConnect", "tidyr", "cowplot",
                      "boot", "rowr", "reshape2", "RCurl", "XML", 
                      "stringr", "gdata", "formattable","alabama","httr","htmltab","qdapRegex","rmarkdown")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos='https://cran.rstudio.com')
library(alabama)
library(ggplot2)  # package for plotting
library(plyr)    # package for data frame manipulation
library(shiny)
library(cowplot) # To merge results from ggplot
library(scales)
library(XLConnect) #to work with Excel
library(tidyr)
library(boot)
library(rowr)
library(reshape2)
library(RCurl)  #web scrapping
library(XML)    #web scrapping
library(stringr)
library(gdata)
library(formattable)
#library(R2wd)
library(rmarkdown)
library(httr)       # web scrapping
library(htmltab)    # web scrapping
library(qdapRegex)  # text mining

############################################################################################################################################
#_________________________________________________________________
#To generate a centralized tool to facilatate DB review process
#
#_________________________________________________________________
#
###########################################################################################################################################

##############################
#download RMD File from SharePoint
#1. report.Rmd
##############################
url.RMD<-"http://my.fda.gov/personal/ho-pi_lin/DB_review_tool/Shared%20Documents/Jie_TEST_Code/report.Rmd"

download.file(url.RMD, destfile="report.Rmd", method="auto",quiet = FALSE)
##############################
#download zip file from drug@FDA
#2. Drug@FDA data base
#move this part to the begining of the code to save some time
##############################

url_2<- "http://www.fda.gov/downloads/Drugs/InformationOnDrugs/UCM527389.zip" #new version of drug@FDA database
#url_2<- "http://www.fda.gov/downloads/Drugs/InformationOnDrugs/UCM054599.zip"
 #old version

temp_d <- tempfile()

download.file(url_2 ,temp_d)

data_appD <- tryCatch({
  data <- read.delim(unz(temp_d, "ApplicationDocs.txt"))},
  error = function(err) {
    return(data.frame())
  })
data_appD.flag <- ifelse(nrow(data_appD)==0,0,1)


data_app <- tryCatch({
  data <- read.delim(unz(temp_d, "Applications.txt"))},
  error = function(err) {
    return(data.frame())
  })
data_app.flag <- ifelse(nrow(data_app)==0,0,1)

data_pro <- tryCatch({
  data <- read.delim(unz(temp_d, "Products.txt"))},
  error = function(err) {
    return(data.frame())
  })
data_pro.flag <- ifelse(nrow(data_pro)==0,0,1)

data_TE <- tryCatch({
  data <- read.delim(unz(temp_d, "TE.txt"))},
  error = function(err) {
    return(data.frame())
  })
data_TE.flag <- ifelse(nrow(data_TE)==0,0,1)
rm(data)

unlink(temp_d)


##############################
#download zip file from Orange book
# Orange book database
#move this part to the begining of the code to save some time
##############################

url_3<- "http://www.fda.gov/downloads/Drugs/InformationOnDrugs/UCM163762.zip" 


temp_o <- tempfile()

download.file(url_3 ,temp_o)

data_exclus <- read.table(unz(temp_o, "exclusivity.txt"), sep = "~", header = T)

data_patent <- read.table(unz(temp_o, "patent.txt"), sep = "~", header = T)

data_pro_ora <- read.table(unz(temp_o, "products.txt"), sep = "~", header = T, fill = T, quote = "", comment.char = "")
#data_pro_ora <- read.table(unz(temp_o, "products.txt"), sep = "~", header = T)

unlink(temp_o)

#________________________________________________________________________________________________________________


shinyServer(function(input, output, session) { 
  if(data_appD.flag+data_app.flag+data_pro.flag+data_TE.flag!=4){
    output$FDA_Error_Message<-renderText({"There is an error in accessing drug@FDA database. Please report this error to the developers."})
  }
  ##############################################################################################################################
  ##START: Data collection for DB
  ##Take user input of DRUG NAME and return relevant public available info to help with DB review
  ###############################################################################################################################
  
  
  ##############################
  #Download
  #1. USP dissolution data base
  ##############################
  
  #url <- "http://www.usp.org//usp-nf//overview//compendial-tools//usp-dissolution-methods-database"
  url <- "http://www.usp.org/sites/default/files/usp_pdf/EN/USPNF/compendialTools/dissolution_methods_database.xlsx"
 #    url<-"http://www.usp.org/sites/default/files/usp_pdf/EN/USPNF/compendialTools/dissolution-methods-database.xls"
#  links <- getHTMLLinks(url)  #Get all the links from webpage above
 # link1<-links[str_detect(links, ".xls")]
  #link2<-link1[str_detect(link1, "compendialTools")]  #Further filtering, so only the link to dissolution database is retained
 # filenames_list<- unlist(strsplit(link2,"/"))
  filenames_list<- unlist(strsplit(url,"/"))
  filename1<- filenames_list[length(filenames_list)] #obtained the name of downloaded excel file for USP database
  f = CFILE(filename1, mode="wb")   #from RCurl package, use C-level file handles
  curlPerform(url = url, writedata = f@ref, ssl.verifypeer = FALSE)
  close(f)
  
  # USP_d <- readWorksheetFromFile(file = filename1, sheet = "Sheet1", header = TRUE   
  #                                , startRow = 8) ##convert USP dissolution excel file to R object
  USP_d<-tryCatch({
    USP_d_Read<-readWorksheetFromFile(file = filename1, sheet = "Sheet1", header = TRUE   
                          , startRow = 8)
  }, error = function(err){
    output$USP_Error_Message<-renderText({"There is an error in connecting USP database. Please report this error to the developers."})
  })
  
  # Jie Xue add for change excel file name 01/26/2017
  file.copy("dissolution_methods_database.xlsx","Do-NOT-OPEN-dissolution-methods-database.xlsx")
  file.remove("dissolution_methods_database.xlsx")
    

  
### Jie add code, directly read FDA dissolution data base from web url, 01/18/2017
#######********#######********#######********#######********#######********#######********####### 
  # Define function to check if url exists
  urlExists <- function(address){
    tryCatch({
      con <- url(address)  
      a  <- capture.output(suppressWarnings(readLines(con)))  
      close(con)  
      return(TRUE)
      
    },  error = function(err) {
      
      # error handler picks up where error was generated
      occur <- grep("cannot open the connection", capture.output(err)); 
      print("Cannot open the connection")
      close(con)
      if(length(occur) > 0) return(FALSE)  
    }) 
  }
  
  # Read FDA Dissolution web site
 # url_FDA<-"http://www.accessdata.fda.gov/scripts/cder/dissolution/dsp_download.cfm" #2_23_2017_Hopi delete due to warning message
  url_FDA <- "http://www.accessdata.fda.gov/scripts/cder/dissolution/dsp_getallData.cfm" #2_23_2017_Hopi
  # Wrong web link for test
  # url_FDA<-"http://www123.accessdata.fda.gov/scripts/cder/dissolution/dsp_download.cfm"
  

  # Warning message for web not available
  # Current web page "http://www.accessdata.fda.gov/scripts/cder/dissolution/dsp_getallData.cfm"
  # output$warnmsg.FDA_web <- renderPrint({
  #   if (!url_FDA.flag){
  #     cat("Warning message: Can not access FDA Dissolution Method webpage.\n")
  #     cat("Please check http://www.accessdata.fda.gov/scripts/cder/dissolution/dsp_getallData.cfm for details")
  #   } else {
  #     cat("No error")
  #   }
  # })
  # output$warnstat_FDA_web <- renderText({ifelse(!url_FDA.flag,"Error","No error") })
  # outputOptions(output, "warnstat_FDA_web", suspendWhenHidden=FALSE)
  
  # Flag for web exists, true for exists
  FDA_Diss <- tryCatch({
    srts<-getURL("https://www.accessdata.fda.gov/scripts/cder/dissolution/dsp_getallData.cfm")
    srts.table<- readHTMLTable(srts,stringsAsFactors = FALSE)
    FDA_diss<-data.frame(srts.table)
    
    # Clean Table Name from HTML TABLE
    FDA_diss.name<-names(FDA_diss)
    
    ## Replace ".." with "."
    FDA_diss.name<-gsub("\\.\\.","\\.",FDA_diss.name)
    ## Remove "." at the end of the string
    FDA_diss.name<-gsub("\\.(?=\\.*$)", "", FDA_diss.name, perl=TRUE)
    ### \.   # Match a dot
    ### (?=  # only if followed by
    ### \.*  # zero or more dots
    ### $    # until the end of the string
    ### )    # End of lookahead assertion
    ## Remove "NULL."
    FDA_diss.name<-gsub("NULL.","",FDA_diss.name)
    ## Replace "." with "_"
    FDA_diss.name<-gsub("\\.","_",FDA_diss.name)
    ## Replace "example_" with ""                      #2_23_2017_Hopi delete due to warning message
    FDA_diss.name<-gsub("example_","",FDA_diss.name)  #2_23_2017_Hopi delete due to warning message
    names(FDA_diss)<-FDA_diss.name
    
    rm(srts,srts.table,FDA_diss.name)
    date<-FDA_diss
  },
  error = function(err) {
    output$FDA_diss_Error_Message<-renderText({"There is an error in connecting FDA Dissolution database. Please report this error to the developers."})
    return(data.frame())
  })
  
  # Waning message for web page content change by check column names
  # Current column names from web page "Drug_Name","Dosage_Form","USP_Apparatus","Speed_RPMs","Medium","Volume_mL","Recommended_Sampling_Times_minutes","Date_Updated"
  # Wrong name for test  
  # err.FDA_diss <-ifelse (names(FDA_diss)==c("Drug_Name123","Dosage_Form","USP_Apparatus","Speed_RPMs","Medium","Volume_mL","Recommended_Sampling_Times_minutes","Date_Updated"),T,F)
  # err.FDA_diss <-ifelse (names(FDA_diss)==c("Drug_Name","Dosage_Form","USP_Apparatus","Speed_RPMs","Medium","Volume_mL","Recommended_Sampling_Times_minutes","Date_Updated"),T,F)
  # output$warnmsg.FDA_diss <- renderPrint({
  #   if (sum(err.FDA_diss)!=length(names(FDA_diss))){
  #     cat("Warning message: Content changed on FDA Dissolution Method webpage.\n")
  #     cat("Please check http://www.accessdata.fda.gov/scripts/cder/dissolution/dsp_getallData.cfm for details")
  #   } else {
  #     print("No error")
  #   }
  # })
  # output$warnstat_FDA_diss <- renderText({ifelse(sum(err.FDA_diss)!=length(names(FDA_diss)),"Error","No error") })
  # outputOptions(output, "warnstat_FDA_diss", suspendWhenHidden=FALSE)

  #######********#######********#######********#######********#######********#######********#######  
  
  df_USPd <- reactive({
    if (input$var_lab != "") {
      if (!is.na(USP_d[grep(toupper(input$var_lab), toupper(USP_d$MONOGRAPH)) , ][1,1])) {
        ff2<- USP_d[grep(toupper(input$var_lab), toupper(USP_d$MONOGRAPH)) , ]
        ff2[,grep("Date.Updated",names(ff2),ignore.case=TRUE)]<- as.character(ff2[,grep("Date.Updated",names(ff2),ignore.case=TRUE)])
        colnames(ff2)<- c("Drug Name", "Test", "Medium", "Surfactant", "pH", "Volume (ml)", "Deaeration", "USP Apparatus", 
                          "RPMs", "Total Test Time","Quantitative Procedure", "Exceptions", "Date Updated")
        ff2<- ff2[, c(1:5, 7,6, 8:10,13, 11:12 )]
        ff3<-formattable(ff2, list(
          Name=formatter(
            "span",
            style = x ~ ifelse(x == "Technology", 
                               style(font.weight = "bold"), NA)),
          Value = color_tile("white", "orange"),
          Change = formatter(
            "span"
          ))
        )
        return(ff3)
      }
      
      #4_14_2017_Hopi add else{}, when there is no match, use first word to match
      else {
        if (!is.na(USP_d[grep(toupper(str_split(input$var_lab, " ")[[1]][1]), toupper(USP_d$MONOGRAPH)), ][1,1])) {
          ff2<- USP_d[grep(toupper(str_split(input$var_lab, " ")[[1]][1]), toupper(USP_d$MONOGRAPH)), ]
          ff2[,grep("Date.Updated",names(ff2),ignore.case=TRUE)]<- as.character(ff2[,grep("Date.Updated",names(ff2),ignore.case=TRUE)])
          colnames(ff2)<- c("Drug Name", "Test", "Medium", "Surfactant", "pH", "Volume (ml)", "Deaeration", "USP Apparatus", 
                            "RPMs", "Total Test Time","Quantitative Procedure", "Exceptions", "Date Updated")
          ff2<- ff2[, c(1:5, 7,6, 8:10,13, 11:12 )]
          ff3<-formattable(ff2, list(
            Name=formatter(
              "span",
              style = x ~ ifelse(x == "Technology", 
                                 style(font.weight = "bold"), NA)),
            Value = color_tile("white", "orange"),
            Change = formatter(
              "span"
            ))
          )
          return(ff3)
        }
      }
      #4_14_2017_Hopi add else{}, when there is no match, use first word to match
    }
  })
  
  
  
  ##############################
  #Load
  # FDA dissolution data base
  ##############################
  df_FDAd <- reactive({
    if (input$var_lab != "") {
      if (!is.na(FDA_Diss[grep(toupper(input$var_lab), toupper(FDA_Diss$Drug_Name)) , ][1,1])) {
        ff1<- FDA_Diss[grep(toupper(input$var_lab), toupper(FDA_Diss$Drug_Name)) , ]
        ff1$Date_Updated<- as.character(ff1$Date_Updated)
        ff1<- ff1[, c(1:2, 5:6, 3:4, 7, 8)]
        colnames(ff1)<- gsub("_", " ",  colnames(ff1) )
        colnames(ff1)[4]<- "Volume (ml)"
        ff3<-formattable(ff1, list(
          Name=formatter(
            "span",
            style = x ~ ifelse(x == "Technology", 
                               style(font.weight = "bold"), NA)),
          Value = color_tile("white", "orange"),
          Change = formatter(
            "span"
          ))
        )
        return(ff3)
      }
      
      #4_14_2017_Hopi add else{}, when there is no match, use first word to match
      else {
        if (!is.na(FDA_Diss[grep(toupper(str_split(input$var_lab, " ")[[1]][1]), toupper(FDA_Diss$Drug_Name)) , ][1,1])) {
          
          ff1<- FDA_Diss[grep(toupper(str_split(input$var_lab, " ")[[1]][1]), toupper(FDA_Diss$Drug_Name)) , ]
          ff1$Date_Updated<- as.character(ff1$Date_Updated)
          ff1<- ff1[, c(1:2, 5:6, 3:4, 7, 8)]
          colnames(ff1)<- gsub("_", " ",  colnames(ff1) )
          colnames(ff1)[4]<- "Volume (ml)"
          ff3<-formattable(ff1, list(
            Name=formatter(
              "span",
              style = x ~ ifelse(x == "Technology", 
                                 style(font.weight = "bold"), NA)),
            Value = color_tile("white", "orange"),
            Change = formatter(
              "span"
            ))
          )
          return(ff3)
        }
      }
      #4_14_2017_Hopi add, when there is no match, use first word to match
    } 
  })
  
  
  
  ##############################
  #Below will create interface to interact with
  #2. Drug@FDA database
  ##############################
  
  t2_lab <- reactive({
    t2_lab<- input$var_lab }) 
  
  matched_D<- reactive({
    if (input$var_lab != "") {
      if (!is.na(data_pro[grep(toupper(input$var_lab), data_pro$ActiveIngredient) , ][1,1])) {    
        data_pro$ActiveIngredient<-as.character(data_pro$ActiveIngredient)
        nda_pre2<- data_pro[grep(toupper(input$var_lab), data_pro$ActiveIngredient) , ]
        #nda_pre<-nda_pre2[nda_pre2$ReferenceDrug=="1",]     #Identify RLD associated with user input, based on active ingredient in the database "drug_App"
        #2_23_2017_Hopi delete above code
        #Include Reference standard from Orang book
        org     <- data_pro_ora[data_pro_ora$Ingredient == toupper(input$var_lab) & 
                                  data_pro_ora$RS == "Yes", ]$Appl_No    #2_23_2017_Hopi add
        drug_fda <- nda_pre2[nda_pre2$ReferenceDrug=="1",]$ApplNo     #2_23_2017_Hopi add
        
        nda_pre<- subset(nda_pre2, ApplNo %in% unique(union(org, drug_fda)))  #2_23_2017_Hopi add, combine (RLD in drug@FDA and RS in Orange book)
        nda_pre$DFDA<- paste(nda_pre$ApplNo, nda_pre$ActiveIngredient,nda_pre$DrugName, nda_pre$Form, sep="; ") #2_23_2017_Hopi, delete strength to reduce complexity (adjust based on recent change on the database)
        return(nda_pre)     
      }
    }
  })
  
  
  
  #create interactive/dynamic user interface
  output$ui_FDA1 <- renderUI({
    if (!is.null(matched_D())) {
      selectInput(inputId = "RLD", label = "Select RLD :", choices = matched_D()$DFDA)
    }
  })
  
  mached_info <- reactive ({
    if(!is.null(input$RLD)) {    
      dat <- subset(matched_D(), DFDA==input$RLD)[1,] #2_23_2017_Hopi, add [1,]
      # dat$Label <-  ifelse(
      #   !is.na(data_appD[data_appD$ApplicationDocsTypeID == 2 & data_appD$ApplNo == dat$ApplNo[1] , ][1,1]),
      #   as.character(data_appD[data_appD$ApplicationDocsTypeID ==2 & data_appD$ApplNo == dat$ApplNo[1] , ]$ApplicationDocsURL
      #                [length(data_appD[data_appD$ApplicationDocsTypeID ==2 & data_appD$ApplNo == dat$ApplNo[1] , ]$ApplicationDocsURL)]),
      #   ""      
      # )   
      dat$Label <-  ifelse(
        !is.na(data_appD[data_appD$ApplicationDocsTypeID == 2 & data_appD$ApplNo == as.numeric(as.character(dat$ApplNo[1])) , ][1,1]),
     #   as.character(data_appD[data_appD$ApplicationDocsTypeID ==2 & data_appD$ApplNo == as.numeric(as.character(dat$ApplNo[1])) &  , ]$ApplicationDocsURL #2_23_2017_Hopi delete
                     as.character(subset(data_appD[data_appD$ApplicationDocsTypeID ==2 & data_appD$ApplNo ==                           #2_23_2017_Hopi modify codes to have the latest version of the document
              as.numeric(as.character(dat$ApplNo[1]))  , ], SubmissionNo == max(SubmissionNo))$ApplicationDocsURL),                    #2_23_2017_Hopi add
                   #  [length(data_appD[data_appD$ApplicationDocsTypeID ==2 & data_appD$ApplNo == as.numeric(as.character(dat$ApplNo[1])) , ]$ApplicationDocsURL)]), #2_23_2017_Hopi delete
        ""      
      ) 
      
      # dat$Review <-  ifelse(
      #   !is.na(data_appD[data_appD$ApplicationDocsTypeID ==3 & data_appD$ApplNo == dat$ApplNo[1] , ][1,1]),
      #   as.character(data_appD[data_appD$ApplicationDocsTypeID ==3 & data_appD$ApplNo == dat$ApplNo[1] , ]$ApplicationDocsURL
      #                [length(data_appD[data_appD$ApplicationDocsTypeID ==3 & data_appD$ApplNo == dat$ApplNo[1] , ]$ApplicationDocsURL)]),
      #   ""      
      # )
      
      dat$Review <-  ifelse(
        !is.na(data_appD[data_appD$ApplicationDocsTypeID ==3 & data_appD$ApplNo == as.numeric(as.character(dat$ApplNo[1])) , ][1,1]),
#         as.character(data_appD[data_appD$ApplicationDocsTypeID ==3 & data_appD$ApplNo == as.numeric(as.character(dat$ApplNo[1])) , ]$ApplicationDocsURL               #2_23_2017_Hopi delete 
#                      [length(data_appD[data_appD$ApplicationDocsTypeID ==3 & data_appD$ApplNo == as.numeric(as.character(dat$ApplNo[1])) , ]$ApplicationDocsURL)]), #2_23_2017_Hopi delete
as.character(subset(data_appD[data_appD$ApplicationDocsTypeID ==3 & data_appD$ApplNo ==                           #2_23_2017_Hopi modify codes to have the latest version of the document
                                as.numeric(as.character(dat$ApplNo[1]))  , ], SubmissionNo == max(SubmissionNo))$ApplicationDocsURL),                    #2_23_2017_Hopi add
        ""      
      )
      # dat$`Summary Review` <-  ifelse(
      #   !is.na(data_appD[data_appD$ApplicationDocsTypeID ==21 & data_appD$ApplNo == dat$ApplNo[1] , ][1,1]),
      #   as.character(data_appD[data_appD$ApplicationDocsTypeID ==21 & data_appD$ApplNo == dat$ApplNo[1] , ]$ApplicationDocsURL
      #                [length(data_appD[data_appD$ApplicationDocsTypeID ==21 & data_appD$ApplNo == dat$ApplNo[1] , ]$ApplicationDocsURL)]),
      #   ""      
      # )
      
      dat$`Summary Review` <-  ifelse(
        !is.na(data_appD[data_appD$ApplicationDocsTypeID ==21 & data_appD$ApplNo == as.numeric(as.character(dat$ApplNo[1])) , ][1,1]),
#         as.character(data_appD[data_appD$ApplicationDocsTypeID ==21 & data_appD$ApplNo == as.numeric(as.character(dat$ApplNo[1])) , ]$ApplicationDocsURL
#                      [length(data_appD[data_appD$ApplicationDocsTypeID ==21 & data_appD$ApplNo == as.numeric(as.character(dat$ApplNo[1])) , ]$ApplicationDocsURL)]),
as.character(subset(data_appD[data_appD$ApplicationDocsTypeID ==21 & data_appD$ApplNo ==                           #2_23_2017_Hopi modify codes to have the latest version of the document
                                as.numeric(as.character(dat$ApplNo[1]))  , ], SubmissionNo == max(SubmissionNo))$ApplicationDocsURL),                    #2_23_2017_Hopi add
        ""      
      )
      
      dat$`Exclusivity Date` <-  ifelse(
        length(subset(data_exclus, Appl_No == dat$ApplNo &
                        Product_No == dat$ProductNo)$Exclusivity_Date) == 0,
        paste(unlist(subset(data_exclus, Appl_No == dat$ApplNo &
                              Product_No == dat$ProductNo)$Exclusivity_Date),collapse="; "),
        ""      
      )
      #dat$`Market status`[i]<- data_TE[data_TE$ApplNo == dat$ApplNo[1],]$MarketingStatusID[1]
      #dat$`Market status`<- as.character(data_pro_ora[data_pro_ora$Appl_No == dat$ApplNo &
       #                                         data_pro_ora$Product_No == dat_1$ProductNo]    ,]$Type[1]) # 1-18-2017 use TE from Orange book instead, there is inconsistency in TE codes and market status between database from Orange book and drug@FDA
      dat<- dat[, c(8, 12, 9:11)]
      colnames(dat)[1]<- "RLD"
      colnames(dat)[4]<- "Review"
      colnames(dat)[5]<- "Summary Review"
      dat <- dat[,-2]
      return(dat)
    }
  })
  
  
  # On 1-18-2017 additional filters (using data from orange book) are added per Mei's inputs
  mached_ANDA <- reactive ({
    if(!is.null(mached_info())) {    
      #dat <- subset(matched_D(), DFDA==input$RLD)[1,] #2_23_2017_Hopi, add [1,] #4_14_2017_Hopi delete [1,] (wrong assumption) e.g. A21178 GLYBURIDE
      dat <- subset(matched_D(), DFDA==input$RLD) #4_14_2017_Hopi add
      
      if(!is.na(data_pro[data_pro$ActiveIngredient == dat$ActiveIngredient[1] & data_pro$Strength == dat$Strength[1] &
                         data_pro$Form == dat$Form[1],][1,1])) {
        
        for (j in 1:length(dat$ApplNo)) {
          t <- data_pro[data_pro$ActiveIngredient == dat$ActiveIngredient[j] & data_pro$Strength == dat$Strength[j] &
                          data_pro$Form == dat$Form[j],]
          ifelse (j == 1, dat_1<- t, dat_1<- rbind.fill(dat_1,t))
        }
        # dat_1 <- data_pro[data_pro$ActiveIngredient == dat$ActiveIngredient  &
        #                     data_pro$Form == dat$Form,]   #4_14_2017_Hopi delete 
        dat_1$ApplNo<-as.numeric(as.character(dat_1$ApplNo))
        
        for (i in 1:length(dat_1$ApplNo)) {
          dat_1$`Market status`[i]<- data_TE[data_TE$ApplNo == dat_1$ApplNo[i],]$MarketingStatusID[1]
          dat_1$TE[i]<- as.character(data_pro_ora[data_pro_ora$Appl_No == dat_1$ApplNo[i] &
                                                    data_pro_ora$Product_No == dat_1$ProductNo[i]    ,]$TE_Code[1]) # 1-18-2017 use TE from Orange book instead, there is inconsistency in TE codes and market status between database from Orange book and drug@FDA
          dat_1$Doses[i] <- paste(unlist(subset(data_pro, ApplNo == dat_1$ApplNo[i])$Strength),collapse="; ")
          dat_1$Sponsor[i] <- as.character(data_app[data_app$ApplNo == dat_1$ApplNo[i],]$SponsorName[1])
          dat_1$ApplType[i] <- as.character(data_app[data_app$ApplNo == dat_1$ApplNo[i],]$ApplType[1])
          dat_1$Mk[i]<- as.character(data_pro_ora[data_pro_ora$Appl_No == dat_1$ApplNo[i] &
                                                    data_pro_ora$Product_No == dat_1$ProductNo[i]    ,]$Type[1]) # 1-18-2017 use TE from Orange book instead, there is inconsistency in TE codes and market status between database from Orange book and drug@FDA
        }
        
        
        # TE_for_RLD<- dat_1[dat_1$ApplNo == dat$ApplNo,]$TE
        #  dat_1$ApplNo<- as.character(dat_1$ApplNo) #2_23_2017_Hopi #4_14_2017_Hopi delete
        TE_for_RLD<- dat_1[dat_1$ApplNo == dat$ApplNo[1],]$TE #4_14_2017_Hopi modified 
        dat_1$ApplNo<- as.character(dat_1$ApplNo) #2_23_2017_Hopi #4_14_2017_Hopi move down 1 line
        #dat_2 <- subset(dat_1, TE == TE_for_RLD[1] & Mk != "DISCN" & grepl("^A", TE))  #2_23_2017_Hopi, add & grepl("^B", TE) #4_14_2017_Hopi removed
        
        #4_14_2017_Hopi add if clauses below for situations where length(TE_for_RLD). mutiple strengths with different TE codes
        if(length(TE_for_RLD) == 1) {
          dat_2 <- subset(dat_1, TE == TE_for_RLD[1] & Mk != "DISCN" & grepl("^A", TE)) 
        }
        
        if(length(TE_for_RLD) > 1) {
          for (k in 1:length(TE_for_RLD)) {
            t1 <- subset(dat_1, TE == TE_for_RLD[k] & Mk != "DISCN" & grepl("^A", TE)) 
            ifelse (k == 1, dat_2<- t1, dat_2<- rbind.fill(dat_2,t1))
            
          }
          dat_2 <- dat_2[,c(-2,-4)]
          dat_2 <- unique(dat_2)
        }
        #4_14_2017_Hopi add if clauses above for situations where length(TE_for_RLD). mutiple strengths with different TE codes
        
        #dat_2 <- dat_2[,c(12, 1:3, 7:11, 5 )]   #4_14_2017_Hopi delete
        dat_2 <- dat_2[,c(10, 1:2, 5:9, 3 )]   #4_14_2017_Hopi add
        dat_2$`Market status` <-  factor(dat_2$`Market status`, levels = c(1, 2, 3, 4), labels = c("Prescription", "Over-the-counter", "Discontinued", "Tentative Approval") )
        dat_2$ReferenceDrug <-  factor(dat_2$ReferenceDrug, levels = c(0, 1, 2), labels = c("no", "yes", "TBD") )
        return(dat_2)
      }
    }
  })
  
  
  ##############################
  #Interact with
  # Orange book database to include approval date, exclusivity expiration date etc
  ##############################
  mached_ANDA_or <- reactive ({
    if(!is.null(mached_info())) {    
      dat <- subset(matched_D(), DFDA==input$RLD)[1,] #2_23_2017_Hopi, add [1,]
      if(!is.na(data_pro[data_pro$ActiveIngredient == dat$ActiveIngredient & data_pro$Strength == dat$Strength &
                         data_pro$Form == dat$Form,][1,1])) {
        dat_1 <- data_pro[data_pro$ActiveIngredient == dat$ActiveIngredient & data_pro$Strength == dat$Strength &
                            data_pro$Form == dat$Form, ]
        dat_1$ApplNo<-as.numeric(as.character(dat_1$ApplNo))
        ma <- mached_ANDA()
        #input$RLD
        Aprd <- data.frame()
        if (length(ma$ApplNo)>0) {
          for (i in 1:length(ma$ApplNo)) {
            t1 <- data_pro_ora[data_pro_ora$Appl_No == as.numeric(as.character(ma$ApplNo[i])),] #2_23_2017_Hopi delete "&"
                               #  data_pro_ora$TE_Code ==    ma[ma$ReferenceDrug == "yes",]$TE[1]    ,] #2_23_2017_Hopi delete; example ANDA75753 is not RLD, but is RS
            ifelse (length(Aprd) == 0, Aprd<- t1, Aprd<- rbind.fill(Aprd,t1))
          }
          for (j in 1:length(Aprd$Appl_No)) {
            Aprd$Exclusivity_Date[j] <- paste(unlist(subset(data_exclus, Appl_No == Aprd$Appl_No[j] &
                                                              Product_No == Aprd$Product_No[j])$Exclusivity_Date),collapse="; ")
          }
          Aprd$AppN <- paste(Aprd$Appl_Type, Aprd$Appl_No, sep = "") 
          Aprd$Approval_Date_1 <- as.Date(Aprd$Approval_Date, format="%B %d, %Y")
          Aprd <- Aprd[order(Aprd$Approval_Date_1),]
          return(Aprd)
        }
        if (length(ma$ApplNo) == 0) {
          Aprd <- data_pro_ora[data_pro_ora$Appl_No == as.numeric(as.character(dat$ApplNo[1])),]
          for (j in 1:length(Aprd$Appl_No)) {
            Aprd$Exclusivity_Date[j] <- paste(unlist(subset(data_exclus, Appl_No == Aprd$Appl_No[j] &
                                                              Product_No == Aprd$Product_No[j])$Exclusivity_Date),collapse="; ")
          }
          Aprd$AppN <- paste(Aprd$Appl_Type, Aprd$Appl_No, sep = "") 
          Aprd$Approval_Date_1 <- as.Date(Aprd$Approval_Date, format="%B %d, %Y")
          Aprd <- Aprd[order(Aprd$Approval_Date_1),]
          return(Aprd)
        }
      }
    }
  })
  
  mached_ANDA_o <- reactive ({
    if(!is.null(mached_ANDA_or())) {     
      Aprd <- mached_ANDA_or()
      Aprd$RS <-  factor(Aprd$RS, levels = c("Yes", "No"), labels = c("Reference Standard", "") )
      
      Aprd$Approval_Date <- paste( Aprd$RS, Aprd$Approval_Date, Aprd$TE_Code, sep="    /     ")
      #Aprd$Approval_Date <- paste( Aprd$RS, "\n", Aprd$Approval_Date, "\n", Aprd$TE_Code, sep= "")
      
      #Aprd <- Aprd[, c(16,5, 9:12, 14,16)]
      Aprd <- Aprd[, c("AppN", "Strength", "Approval_Date")]
      
      Aprd <- reshape(Aprd, idvar = "AppN", timevar = "Strength" , direction = "wide")
      colnames(Aprd) <-  gsub("Approval_Date.", "", names(Aprd) )  
      #Aprd.names<-names(Aprd)
      #for(i in 1:length(Aprd.names)){
      #  Aprd.names[i]<-strsplit(Aprd.names[i],".",fixed = TRUE)[[1]][1]
      #}
      #names(Aprd)<-Aprd.names
      #Aprd<-Aprd[,-2]
      return(Aprd)
    }
  })
  
  mached_ANDA_e <- reactive ({
    if(!is.null(mached_ANDA_or())) {     
      Aprd <- mached_ANDA_or()
      Aprd <- Aprd[, c("AppN", "Strength", "Exclusivity_Date")]
#       Aprd <- Aprd[, c(15,5, 9:12, 14,16)]
       Aprd <- reshape(Aprd, idvar = "AppN", timevar = "Strength" , direction = "wide")
       colnames(Aprd) <-  gsub("Exclusivity_Date.", "", names(Aprd) )  
#       Aprd.names<-names(Aprd)
#       for(i in 1:length(Aprd.names)){
#         Aprd.names[i]<-strsplit(Aprd.names[i],".",fixed = TRUE)[[1]][1]
#       }
#       names(Aprd)<-Aprd.names
#       Aprd<-Aprd[,-4]
      return(Aprd)
    }
  })  
  
  
  
  #  # 
  #____Make table download to excel file as separate spread sheet
  #  #
  
  ### Replace NA with Blank in Table

  # ReplaceNA<-function(x){
  #   nrow <- dim(x)[1]
  #   ncol <- dim(x)[2]
  #   for(i in 1:nrow){
  #     for(j in 1:ncol){
  #       if(is.na(x[i,j])){
  #         x[i,j]<-" "
  #       }
  #     }
  #   }
  #   return(df)
  # }
  
  ## Orange Book 1
  mached_ANDA_o_BLANK<-reactive({
    if(!is.null(input$RLD)) { 
      df<-mached_ANDA_o()
      nrow <- dim(df)[1]
      ncol <- dim(df)[2]
      for(i in 1:nrow){
        for(j in 1:ncol){
          if(is.na(df[i,j])){
            df[i,j]<-" "
          }
        }
      }
      return(df)
    }
  })
  
  ## Orange Book 2
  mached_ANDA_e_BLANK<-reactive({
    if(!is.null(input$RLD)) { 
      df<-mached_ANDA_e()
      nrow <- dim(df)[1]
      ncol <- dim(df)[2]
      for(i in 1:nrow){
        for(j in 1:ncol){
          if(is.na(df[i,j])){
            df[i,j]<-" "
          }
        }
      }
      return(df)
    }
  })
  
  ## USP Database
  df_USPd_BLANK<-reactive({
    if(!is.null(input$RLD)) { 
      df<-df_USPd()
      nrow <- dim(df)[1]
      ncol <- dim(df)[2]
      for(i in 1:nrow){
        for(j in 1:ncol){
          if(is.na(df[i,j])){
            df[i,j]<-" "
          }
        }
      }
      return(df)
    }
  })
  
  #---------------------------------------------
  
  output$table_FDAm <- renderTable({mached_info()}, include.rownames=FALSE)
  output$table_FDAg <- renderTable({mached_ANDA()[,-3]}, include.rownames=FALSE)
  output$table_FDAgo <- renderTable({mached_ANDA_o_BLANK()}, include.rownames=FALSE)
  output$table_FDAge <- renderTable({mached_ANDA_e_BLANK()}, include.rownames=FALSE)
  output$table_FDAd <- renderTable({df_FDAd()}, include.rownames=FALSE)
  output$table_USPd <- renderTable({df_USPd_BLANK()}, include.rownames=FALSE)
  
  #--------------------------------------------------------------
  #download file
  #-------------------------------------------------------------------------------------------------------------------------------
  
  #Create Excel file
  output$download_dataL<- downloadHandler(
    
    filename = function() {paste(paste(t2_lab(), "RLD", matched_D()$ApplNo, "Review relevant info",sep=" "),"xlsx", sep = ".")},
    
    content = function(file){
      fname <- paste(file,"xlsx",sep=".")
      wb <- loadWorkbook(fname, create = TRUE)
      createSheet(wb, name = c("RLD", "Approved ANDA", "Approval Date", "Exclusivity Date", "FDA Dissolution", "USP dissolution"))
      writeWorksheet(wb, data= list(mached_info(), mached_ANDA(), mached_ANDA_o(), mached_ANDA_e(), df_FDAd(), df_USPd()),
                     sheet = c("RLD", "Approved ANDA", "Approval Date", "Exclusivity Date", "FDA Dissolution", "USP dissolution")) 
      saveWorkbook(wb)
      file.rename(fname,file)
    }
  )
  
  
  #####################################
  # Drug Bank 03282017 Jie Xue
  #####################################
  observe({
    # We'll use the input$controller variable multiple times, so save it as x
    # for convenience.
    x <- input$var_lab
    
    # This will change the value of input$inText, based on x
    updateTextInput(session, "var_lab_DB", value = x)
  })
  
  tmp <- tempfile() 
  GET("https://www.drugbank.ca/releases/5-0-5/downloads/all-drugbank-vocabulary", 
      write_disk(tmp) )
  df <- read.csv(unz(tmp, "drugbank vocabulary.csv"), header = T)
  rm(tmp)
  DrugTable<-df[,c(1,3)]
  rm(df)
  
  DrugTable.result <- reactive({
    if (input$var_lab_DB != "") {
      DrugTable<-DrugTable[grep(input$var_lab_DB,DrugTable$Common.name,ignore.case=TRUE),]
      return(DrugTable)
    }
  })
  
  
  output$ui_DrugBankSelect <- renderUI({
    if (!is.null(DrugTable.result())) {
      selectInput(inputId = "DrugBank", label = "Select Drug Name :", choices = DrugTable.result()$Common.name)
    }
  }) 
  
  DrugBank.URL<-reactive({
    if ((input$DrugBank != "")&(input$var_lab_DB != "")) {
      DrugID <- subset(DrugTable.result(), Common.name==input$DrugBank)
      DrugID<-as.character(DrugID[1,1])
      url<-paste0("https://www.drugbank.ca/drugs/",DrugID,sep = "")
      return(url)
    }
  })
  
  
  # p(a("Installation Maunal", href = "http://my.fda.gov/personal/ho-pi_lin/DB_review_tool/Shared%20Documents/Manual/Brief%20Manual.pdf", target = "_blank"))
  
  DrugBank.Info.1<-reactive({
    xp <- "//th[text() = 'Identification']/ancestor::table"
    Data <- htmltab(doc = DrugBank.URL() , which = 1, encoding = "UTF-8")
    names(Data)<-c("V1","V2")
    
    # ID Tab
    ID.Name<-data.frame(V1="<strong>Name</strong>",V2=NA)
    if(is.element("Name",Data$V1)){
      ID.Name[1,2]<-Data[grep("Name",Data$V1),2][1]
    }
    ID.URL<-data.frame(V1="<strong>URL</strong>",V2=paste0("<a href=",DrugBank.URL(),">",DrugBank.URL(),"</a>",sep = ""))
    ID<-data.frame(ID.Name,ID.URL)
    
    Pharmacology.Indication<-data.frame(V1="<strong>Indication</strong>",V2=NA)
    if(is.element("Indication",Data$V1)){
      Pharmacology.Indication[1,2]<-Data[grep("\\bIndication\\b",Data$V1),2]
    }
    
    Pharmacology.Pharmacodynamics<-data.frame(V1="<strong>Pharmacodynamics</strong>",V2=NA)
    if(is.element("Pharmacodynamics",Data$V1)){
      Pharmacology.Pharmacodynamics[1,2]<-Data[grep("Pharmacodynamics",Data$V1),2]
    }
    
    D<-rbind(ID.Name,Pharmacology.Indication,Pharmacology.Pharmacodynamics,ID.URL)
    names(D)<-c("Property","Detail Description")
    return(D)
  })
  
  DrugBank.Info.2<-reactive({
    xp <- "//th[text() = 'Identification']/ancestor::table"
    Data <- htmltab(doc = DrugBank.URL() , which = 1, encoding = "UTF-8")
    names(Data)<-c("V1","V2")
    
    # ID Tab
    ID.Name<-data.frame(V1="<strong>Name</strong>",V2=NA)
    if(is.element("Name",Data$V1)){
      ID.Name[1,2]<-Data[grep("Name",Data$V1),2][1]
    }
    ID.URL<-data.frame(V1="<strong>URL</strong>",V2=paste0("<a href=",DrugBank.URL(),">",DrugBank.URL(),"</a>",sep = ""))
    
    Pharmacology.Absorption<-data.frame(V1="<strong>Absorption</strong>",V2=NA)
    if(is.element("Absorption",Data$V1)){
      Pharmacology.Absorption[1,2]<-Data[grep("Absorption",Data$V1),2]
    }
    
    Pharmacology.Volume<-data.frame(V1="<strong>Volume of distribution</strong>",V2=NA)
    if(is.element("Volume of distribution",Data$V1)){
      Pharmacology.Volume[1,2]<-Data[grep("Volume of distribution",Data$V1),2]
    }
    
    Pharmacology.Protein<-data.frame(V1="<strong>Protein binding</strong>",V2=NA)
    if(is.element("Protein binding",Data$V1)){
      Pharmacology.Protein[1,2]<-Data[grep("Protein binding",Data$V1),2]
    } 
    
    Pharmacology.Metabolism<-data.frame(V1="<strong>Metabolism</strong>",V2=NA)
    if(is.element("Metabolism",Data$V1)){
      url.Metabolism<-DrugBank.URL()
      
      Page = readLines(url.Metabolism)
      Line<-grep("Metabolism",Page)
      Line.First<-Page[Line]
      
      Line.server.pos<-regexpr('Metabolism',Line.First)
      tmp<-Line.server.pos[[1]]
      tmp.string<-substring(Line.First,tmp,tmp+10000)
      
      
      Pharmacology.Metabolism.text<-rm_between(tmp.string, 'Metabolism</th><td class=\"table-container\"><p>', '</p>', extract=TRUE)[[1]]
      
      Pharmacology.Metabolism[1,2]<-Pharmacology.Metabolism.text
    }
    
    Pharmacology.Route<-data.frame(V1="<strong>Route of elimination</strong>",V2=NA)
    if(is.element("Route of elimination",Data$V1)){
      Pharmacology.Route[1,2]<-Data[grep("Route of elimination",Data$V1),2]
    } 
    
    Food.interactions<-data.frame(V1="<strong>Food Interactions</strong>",V2=NA)
    if(is.element("Food Interactions",Data$V1)){
      Food.interactions[1,2]<-Data[grep("Food Interactions",Data$V1),2]
    } 
    
    D<-rbind(ID.Name,Pharmacology.Absorption,Pharmacology.Volume,Pharmacology.Protein,Pharmacology.Metabolism,Pharmacology.Route,Food.interactions,ID.URL)
    names(D)<-c("Property","Detail Description")
    return(D)
  })
  
  output$DrugBank_Link <- renderUI({
    tryCatch({
      a("DrugBank Link", href=DrugBank.URL(), target="_blank")
    },error = function(err){
      print(paste("Please input a drug name"))
    })
    
  })
  
  
  output$DrugBankTable_1<-shiny::renderDataTable({
    tryCatch({
      output$DrugBank_Error_Message_1<-renderText({paste0("Pharmacological properties from drug bank for ",input$DrugBank,"")})
      DrugBank.Info.1()
    },error = function(err){
      output$DrugBank_Error_Message_1<-renderText({"Please input a drug name"})
    })
  }, escape = FALSE,options = list(paging = FALSE,searching = FALSE,dom='t',ordering=F))
  
  output$DrugBankTable_2<-shiny::renderDataTable({
    tryCatch({
      output$DrugBank_Error_Message_2<-renderText({paste0("PK properties from drug bank for ",input$DrugBank,"")})
      DrugBank.Info.2()
    },error = function(err){
      output$DrugBank_Error_Message_2<-renderText({"Please input a drug name"})
    })
  }, escape = FALSE,options = list(paging = FALSE,searching = FALSE,dom='t',ordering=F))
  
  
  
  ##############################################################################################################################
  ##SATRT
  ##To draw dissolution plots and perform bootstrapping for two dissolution profiles
  ###############################################################################################################################
  data_a1<- reactive({
    if (!is.null(input$iFile)) {
      inFile <- input$iFile   
      wb <- loadWorkbook(inFile$datapath)
      return(inFile)
    }
  })
  
  ########################################################################################
  # Radio Buttons to select time unit (Jie Xue Revised 01/24/2017)
  output$ui_a1_a <- renderUI({
    if (!is.null(data_a1())) {
      radioButtons(inputId="Time_unit", label="Choose time unit for the dissolution data",
                   choices  = c("min", "hr"),
                   selected = NULL, inline = T
      )
    }
  })
  ########################################################################################
  
  # To set reference line for Q
  output$ui_a1_b <- renderUI({                  
    if (!is.null(data_a1())) {
      textInput("varQ", value = 80,
                label = "specification of dissolution: Q (%)")
    }
  })
  
  # Dat <- reactiveValues()
  # observe({
  #   if (!is.null(input$iFile)) {
  #     inFile <- input$iFile
  #     wb <- loadWorkbook(inFile$datapath)
  #     sheets <- getSheets(wb)
  #     Dat$wb <- wb
  #     Dat$sheets <- sheets
  #   }
  # })
  
  #Below codes 
  #wb contain info for each worksheet, could access them by wb[1], wb[2] etc.
  data_a1<- reactive({
    if (is.null(input$iFile)) { return()}
    
    if (!is.null(input$iFile)) {
      inFile <- input$iFile   
      wb <- loadWorkbook(inFile$datapath)  
      wd  <- wb # path_()
      df<-data.frame()
      # read in each worksheet in one excel file
      lst = readWorksheet(wb, sheet = getSheets(wb), startRow = 2) 
      
      # read in each worksheet in one excel file, but preserve the first line for later info extraction
      lst2 = readWorksheet(wb, sheet = getSheets(wb))   
      df1 <- data.frame()
      t1 <- data.frame()
      
      if (is.list(lst) & is.data.frame(lst)) {
        
        #only take data from 6, 12 or 24 units
        if (length(lst[,1])%%6==0) {   
          t1<- lst
          
          #remove colums with all "NA" in their records
          t1<- t1[,colSums(is.na(t1))==0]  
          t1$Condition <- names(lst2[1])
        }
        ifelse (length(df1)==0 & length(t1) > 0 , df1<- t1, df1<- rbind.fill(df1,t1))    
      }
      
      else {
        for (j in 1:length(lst)) {
          
          if (length(lst[[j]]) > 0) {
            
            #only take data from 6, 12, or 24 units
            if (length(lst[[j]][,1])==24 | length(lst[[j]][,1])==12 | length(lst[[j]][,1])==6) {               
              t1<- lst[[j]]
              
              #remove colums with all "NA" in their records
              t1<- t1[,colSums(is.na(t1))==0]  
              t1$Condition <- names(lst2[[j]][1])
            }
          }
          ifelse (length(df1)==0 & length(t1) > 0 , df1<- t1, df1<- rbind.fill(df1,t1))    
        }
        
      }
      colnames(df1)[1]<- ""
      #colnames(df1) <- c("unit",sort(unique(na.omit(as.numeric(unlist(strsplit(names(df1), 
       #                                                                       "[^0-9]+")))))), "Condition")
      colnames(df1) <- c("unit",sort(unique(na.omit(as.numeric(unlist(str_extract(names(df1), "\\d+\\.*\\d*")))))), "Condition")
      #colnames(df1) <- c("unit", names(df1), "Condition")
      ifelse (length(df)==0 & length(df1) > 0 , df<- df1, df<- rbind.fill(df,df1)) 
    }
    
    #Below and next lines are to make sure that dissolution data are numbers rather than characters or levels 
    df[,c(3:length(df[1,])-1)]<- sapply(df[,c(3:length(df[1,])-1)], as.character)
    df[,c(3:length(df[1,])-1)]<- sapply(df[,c(3:length(df[1,])-1)], as.numeric)
    return(df)
  })
  
  ########################
  ####Generate plots that John uses for determining Specs
  
  temp1<- reactive({
    if (!is.null(data_a1())) { 
      df<- data_a1()
     # temp1<-as.character(sort(unique(na.omit(as.numeric(unlist(strsplit(names(df), "[^0-9]+")))))))
      temp1<-as.character(sort(unique(na.omit(as.numeric(unlist(str_extract(names(df), "\\d+\\.*\\d*")))))))
      #temp1<- names(df)
      
      return(temp1)
    }
  })
  
  
  data_a2<- reactive({
    if (!is.null(data_a1())) {
      
      df<- data_a1()
      temp1<- temp1()
      
      #Below line has been modified to be more general (avoiding the problem would encounter in previous commented line)
      dfL <- gather(df,Time, percent_release,  which(names(df) %in% temp1))   
      dfL$Time <- as.numeric(as.character(dfL$Time))
      dfL$A_Condition <- paste(dfL$Application, dfL$Condition, sep=" ")
      dfL$percent_release<- as.numeric(dfL$percent_release)
      return(dfL)
    }
  })
  
  data_a3_mean<- reactive({
    if (!is.null(data_a2())) {
      dfL<- data_a2()
      
      tmp1 <- aggregate(percent_release ~ Condition + Time, mean, data=dfL, na.rm=T)
      names(tmp1)[3] <- "Mean"      
      tmp2 <- aggregate(percent_release ~ Condition + Time, sd, data=dfL, na.rm=T)
      names(tmp2)[3] <- "SD"
      tmp <- cbind(tmp1,tmp2$SD)
      names(tmp)[4] <- "SD"
      tmp$CV<- 100*(tmp$SD/tmp$Mean)
      tmp<- tmp[order(tmp$Condition, tmp$Time),]
      tmp<- tmp[,-4]
      tmp_1<- dcast(tmp, Condition~ Time, value.var= "Mean" )
      names(tmp_1)[1]<- "MEAN"
      return(tmp_1)
    }
  })
  
  data_a3_CV<- reactive({
    if (!is.null(data_a2())) {
      dfL<- data_a2()
      tmp1 <- aggregate(percent_release ~ Condition + Time, mean, data=dfL, na.rm=T)
      names(tmp1)[3] <- "Mean"      
      tmp2 <- aggregate(percent_release ~ Condition + Time, sd, data=dfL, na.rm=T)
      names(tmp2)[3] <- "SD"
      tmp <- cbind(tmp1,tmp2$SD)
      names(tmp)[4] <- "SD"
      tmp$CV<- 100*(tmp$SD/tmp$Mean)
      tmp<- tmp[order(tmp$Condition, tmp$Time),]
      tmp<- tmp[,-4]
      tmp_1<- dcast(tmp, Condition~ Time, value.var= "CV" )
      names(tmp_1)[1]<- "CV(%)"
      return(tmp_1)
    }
  })
  
  
  #____________________________________________________
  #create interactive/dynamic user interface
  output$ui_1 <- renderUI({
    if (!is.null(data_a1())) {
      selectInput(inputId = "sheet", label = "Select 1st dissolution profile:", choices = unique(data_a1()$Condition))
    }
  })
  
  output$ui_2 <- renderUI({
    if (!is.null(data_a1()) & length(unique((data_a2()$Condition)))>1) {
      selectInput(inputId = "sheet2", label = "Select 2nd dissolution profile:", choices = unique(data_a1()$Condition), selected= unique(data_a1()$Condition)[2])
    }
  })


  
  
  data_a1_a <- reactive ({
    if(!is.null(input$sheet)) {
      
      dat <- subset(data_a1(), Condition==input$sheet) 
      dat$Compare<- "Reference"
      return(dat)
    }
  })
  
  data_a1_b <- reactive ({
    if(!is.null(input$sheet2)) {
      dat <- subset(data_a1(), Condition==input$sheet2) 
      dat$Compare<- "Test"
      return(dat)
    }
  })
  
  
  output$ui_F2_Time <- renderUI({
    if(!is.null(df.mean.rowSelection())) {
      dat<- df.mean.rowSelection()
      
      checkboxGroupInput("Times_F2", "Choose time points for pairwise F2 calculations", 
                         choices  = setdiff(names(dat), "Condition"),
                         selected = setdiff(names(dat), "Condition"),
                         inline = TRUE
      )
    }
  })
  
  
  
  output$ui_4 <- renderUI({
    if(!is.null(data_a1_a()) & !is.null(data_a1_b())) {
      dat<- rbind.fill(data_a1_a(), data_a1_b())
      
      #Line Below only retains time points with no NA, meaning time points with data only from Reference or Test 
      #will be eliminated 
      dat<- dat[,colSums(is.na(dat))==0]    
      checkboxGroupInput("Times_included_in_analysis", "Choose time points for MAV and bootstrapping", 
                         choices  = setdiff(names(dat), c("unit","Condition","Compare")),
                         selected = setdiff(names(dat), c("unit","Condition","Compare")),inline = TRUE
      )
    }
  })
  
  
  #__________________________________________
  #Plot mean dissolution data 
  
  output$ui_3 <- renderUI({
    if (!is.null(input$sheet2)) {
      checkboxGroupInput("Data_included_in_analysis", "Select dissolution data sets for pairwise F2 calculations", 
                         choices  = unique(data_a1()$Condition),
                         selected = unique(data_a1()$Condition)
      )
    }
  })
  
  
  plotm<- reactive({ 
    if (!is.null(data_a2())) {
      Time_unit<- input$Time_unit
      temp1<- temp1()
      # Set Q value
      t3_ <- as.numeric(input$varQ) 
      
      
      dfL <- data_a2()
      tmp2 <- ddply(dfL, .(Condition, Time), summarize, percent_release = mean(percent_release) )   
      tmp2 <- tmp2[tmp2$Condition %in% input$Data_included_in_analysis, ]
      
      
      g1 <- ggplot(tmp2)+
        #geom_jitter(aes(y=percent_release,x=Time),size=1, position = position_jitter(height = 0))+
        geom_point(aes(y=percent_release, x=Time, colour= `Condition`), size=3, alpha = 0.75) +
        geom_line(aes(y=percent_release, x=Time, colour= `Condition`), size=1, alpha = 0.75) +
        scale_colour_discrete(name = "") +
        #  guides(fill = guide_legend(title="")) +
        geom_hline(yintercept=t3_, colour="red")  +
        geom_hline(yintercept=t3_-15, colour="blue") + scale_x_continuous(breaks = as.numeric(temp1)) +
        theme(axis.text.x = element_text(angle=0,family = "sans", colour="black"),
              axis.text.y = element_text(family = "sans",colour="black") ,
              panel.grid.minor = element_line(colour = "black", linetype = "dotted")) + 
        labs(title="") +
        ylab("% release")+ xlab(ifelse(is.null(Time_unit), "Time", paste('Time', " (", Time_unit,")", sep=""))) +
        scale_y_continuous(limits = c(ifelse(min(dfL$percent_release, na.rm=T)< t3_-35,
                                             min(dfL$percent_release, na.rm=T)-10, t3_-35),                                        
                                      max(dfL$percent_release, na.rm=T)+10))
      
      g1
      
    }
  })
  
  
  
  #__________________________________________
  #Plot selected data
  
  plots<- reactive({ 
    if (!is.null(input$sheet)) {
      Time_unit<- input$Time_unit
      # Set Q value
      t3_ <- as.numeric(input$varQ) 
      dfL<-data_a2()
      temp1<- temp1()
      if (is.null(input$sheet2)) {
        tmp1 <- subset(dfL, Condition==input$sheet)
      }
      else {
        tmp1 <- subset(dfL, Condition==input$sheet | Condition==input$sheet2)
      }
      
      
      tmp2 <- ddply(tmp1, .(Condition, Time), summarize, percent_release = mean(percent_release) )   
      
      g1 <- ggplot(tmp1)+
        geom_jitter(aes(y=percent_release,x=Time),size=1, position = position_jitter(height = 0))+
        geom_point(data = tmp2, aes(y=percent_release, x=Time), size=3, colour="red", alpha = 0.75) +
        geom_hline(yintercept=t3_, colour="red")  +
        geom_hline(yintercept=t3_-15, colour="blue") + scale_x_continuous(breaks = as.numeric(temp1)) +
        theme(axis.text.x = element_text(angle=0,family = "sans", colour="black"),
              axis.text.y = element_text(family = "sans",colour="black") ,
              legend.position = "none", panel.grid.minor = element_line(colour = "black", linetype = "dotted")) + 
        labs(title="") +
        ylab("% release")+ xlab(ifelse(is.null(Time_unit), "Time", paste('Time', " (", Time_unit,")", sep=""))) +
        scale_y_continuous(limits = c(ifelse(min(dfL$percent_release, na.rm=T)< t3_-35,
                                             min(dfL$percent_release, na.rm=T)-10, t3_-35),                                        
                                      max(dfL$percent_release, na.rm=T)+10))
      
      if (!is.null(data_a1_b())) { 
        g1<- g1 + facet_wrap(~ Condition, ncol=2)
      }
      g1
      
    }
  })
  

  
  
  
  
  #___________________________________________________________________________________________________________________
  #Bootstrapping
  # The majority of bootstraping codes are from branch 3 (not sure who is the author )
  #Create data frame combining data_a1_a and data_a1_b for bootstrapping or MVA
  
  bootS <- reactive({ 
    input$action_2 
    if (input$action_2 == 0) {
      return() }
    else {
      withProgress(message = 'Data Processing',    #use "withProgress", so the end user could see the progress and has the estimation on overall process time
                   detail = 'This may take about 20 seconds', value = 0, {
                     isolate ({
                       if (is.null(input$iFile) | is.null(input$sheet)) { return()}
                       if (!is.null(input$Times_included_in_analysis)) {
                         dat<- rbind.fill(data_a1_a(), data_a1_b())
                         dat<- dat[,colSums(is.na(dat))==0]
                         time<- input$Times_included_in_analysis
                         dat<- dat[,c("unit", unique(time), "Compare")]
                         
                         dfL <- gather(dat,Time, percent_release,  which(names(dat) %in% unique(time)))   
                         dfL$Time <- as.numeric(as.character(dfL$Time))
                         dfL_1<- spread(dfL, Compare, percent_release)
                         
                         #source of the boostraping code (Fowarded by Hansong )
                         #release= na.omit(dfL_1)  #remove na from data
                         release= dfL_1 #This is more error prone than previous line, but maybe necessary to avoid getting wrong results because of incorect data set
                         
                         #revised f2 function
                         #when give a x, it will results in a boot.f2r
                         boot.f2r=function(x) {   
                           #calculate avg release for each unit
                           
                           #divide Time data into x
                           release.Time=split(x,x$Time)           
                           
                           #define df, mean of Ref, mean of Test
                           
                           #returns a list of the same length as x,each element of which is the result of applying FUn 
                           #to the corresponding element of X
                           res <- lapply(release.Time, function(df){ 
                             
                             #df$mRef is the mean of df$Reference
                             df$mRef <- mean(df$Reference)   
                             
                             #df$mTest is the mean of df$Test
                             df$mTest= mean(df$Test)                        
                             return(df)                              
                           }
                           )
                           
                           #combine together
                           mdata=do.call("rbind", res)
                           mvalue=data.frame(Time=unique(mdata$Time),avgRef=mdata$mRef,avgTest=mdata$mTest )
                           c<-NULL
                           #calculate f2 with equation
                           for(i in 1:length(mvalue$Time)){
                             a=mvalue[i,3]
                             b=mvalue[i,2]
                             
                             #if (a<85 || b<85){     #remove by Hopi 8/11/2016
                             c[i]=(a-b)^2
                             #}    #remove by Hopi 8/11/2016
                             
                             #else  {                       #remove by Hopi 8/11/2016
                             # i=length(mvalue$Time)  #remove by Hopi 8/11/2016
                             #}  #remove by Hopi 8/11/2016                             
                           }
                           y=sum(c)
                           z=1+(1/length(mvalue$Time))*y
                           a=z^(-0.5)
                           f2=50*log10(100*a)        
                           f2 
                         }
                         
                         #split data based on unit                         
                         release.ID=split(release,release$unit)
                         
                         #bootstrap
                         f<- function(data,index) {
                           release.IDnew=data[index]
                           newrelease=do.call("rbind",release.IDnew)
                           a=boot.f2r(newrelease)
                           return(a)
                         }
                         
                         results=boot(data=release.ID, statistic=f, R=as.numeric(input$var001))                                             
                         boot.ci(results,conf=0.90,type="bca")      
                         Compare<- paste(data_a1_a()$Condition[1], "vs", data_a1_b()$Condition[1], sep=" ")
                         time_point<- length(unique(time))
                         Dosage_unit<- length(unique(dat$unit))
                         lower90<- boot.ci(results,conf=0.90,type="bca")[[4]][[4]]
                         upper90<- boot.ci(results,conf=0.90,type="bca")[[4]][[5]]
                         M<- mean(results$t) # mean of the bootstaping results, need double check
                         f2<- results$t0 #need double check
                         odf<- data.frame(cbind(Compare, time_point, Dosage_unit, lower90, upper90, M, f2))
                         names(odf)<- c("Compare", "Time points", "Dosage unit", "Lower 90% CI (BCA)", 
                                        "Upper 90% CI (BCA)", "Mean from bootstrapping", "Original f2")
                         return(odf)
                         
                       }
                     })
                   })
    }
  })
  output$ui_5 <-  renderTable(
    
{bootS()}, caption=paste("Boostrapping result"),
caption.placement = getOption("xtable.caption.placement", "top"),
caption.width = getOption("xtable.caption.width", NULL))

#__________________________________________________________________________________________________________________________

#___________________________________________________________________________________________________________________
#MVA
#  The majority of MVA codes are from branch 3 (Fang and Meng may have contributed to the original codes )
# 
MVA <- reactive({ 
  
  if(!is.null(data_a1_a()) & !is.null(data_a1_b())) {
    dat<- rbind.fill(data_a1_a(), data_a1_b())
    dat<- dat[,colSums(is.na(dat))==0]
    time<- input$Times_included_in_analysis
    dat<- dat[,c("unit", unique(time), "Compare")]    
    dfL <- gather(dat,Time, percent_release,  which(names(dat) %in% unique(time)))   
    dfL$Time <- as.numeric(as.character(dfL$Time))
    dfL_1<- spread(dfL, Compare, percent_release)    
    Dis<- dfL_1
    Dis$Test<- as.numeric(Dis$Test)
    Dis$Reference<- as.numeric(Dis$Reference)    
    
    #dissolution similarity calculation suing Mahalanobis distance method 
    #when %CV > 20% (<= 15 mins) or/and %CV > 10% (> 15mins)
    #MVA coded by Fang Wu, 3/5/2015, if you have any question, please ask Fang (Email: Fang.Wu@fda.hhs.gov)    
    #revised by Meng Wang,12/01/2015
    
    for (i in unique(Dis$Time)) {
      Dis$mean.Reference[Dis$Time==i]<-mean(Dis$Reference[Dis$Time==i])}
    Dis.mean.Ref<-unique(Dis[,c('Time','mean.Reference')])
    
    for (i in unique(Dis$Time)) {
      Dis$mean.Test[Dis$Time==i]<-mean(Dis$Test[Dis$Time==i])}
    Dis.mean.Test<-unique(Dis[,c('Time','mean.Test')])
    
    # mean dissolution profile and difference    
    tbar <- Dis.mean.Test$mean.Test    
    rbar <- Dis.mean.Ref$mean.Ref    
    mdiff <- tbar-rbar    
    
    # same as above, firsly define those number together so it's easy to change
    #nt <- 12  
    #nr <- 12
    #p <- 5       
    dg <- 10     
    #Hopi changes above to the following
    nt <- length(dat[dat$Compare == "Test",])  
    nr <- length(dat[dat$Compare == "Reference",])
    p <- length(time)       
    
    #covariance of T & R and pooled covariance matrix and it's inverse    
    Ref<-Dis[,c("unit", "Reference")]    
    mr<-data.frame()
    for (i in unique(Ref$unit)) {
      s <- Ref[Ref$unit==i,]
      st <- as.data.frame(t(s[,2]))
      mr<-rbind(mr,st)
    } 
    
    Tes<-Dis[,c("unit", "Test")]
    
    mt<-data.frame()
    for (i in unique(Tes$unit)) {
      s <- Tes[Tes$unit==i,]
      st <- as.data.frame(t(s[,2]))
      mt<-rbind(mt,st)
    }    
    
    nr<-nrow(mr)
    nt<-nrow(mt)                    
    
    st <- cov(mt)    
    sr <- cov(mr)    
    sp <- (st*(nt-1)+sr*(nr-1))/(nt+nr-2) 
    if (det(sp) < 1e-5){sp=sp+diag(1e-5,length(mdiff))}
    spinv <- solve(sp)   
    
    # Mahalanobis distance
    dm <- sqrt(t(mdiff) %*% spinv %*% mdiff)      
    
    #degree of freedom
    df <- nt + nr -p -1
    
    # calculate k and fcrit
    k <- nr*nr/(nt+nr)*(nt+nr-p-1)/((nt+nr-2)*p) #calculate k
    fcrit <- qf(0.9,p,df)  
    
    # create column vector with each element equal to predefined limit dg
    mdg <- c(rep(dg, p))  # tolerance difference between the test batch and reference batch over all time points dg=10%
    # criteria
    # relative deviation
    dm_max <- sqrt(t(mdg) %*% spinv %*% mdg)      
    
    #vector on the boundary of confidence region
    bound1 <- mdiff*(1+sqrt(fcrit/(k*t(mdiff) %*% spinv %*% mdiff)))
    bound2 <- mdiff*(1-sqrt(fcrit/(k*t(mdiff) %*% spinv %*% mdiff)))
    
    # 90% CI of Mahalanobis distance
    ci1 <- sqrt(t(bound1) %*% spinv %*% bound1)   # M-distance equation, but import bound1 and bound 2
    ci2 <- sqrt(t(bound2) %*% spinv %*% bound2)
    #dm_lower <- min(ci1, ci2)
    #dm_lower <- max(0,dm-sqrt(fcrit/k))
    
    #choose the biggest value
    #dm_upper <- max(ci1, ci2)
    #dm_upper <-dm+sqrt(fcrit/k)
    
    ## ----------------------------------------------------------------------
    ##The Lagrange Multiplier Method for the 90% CI, using package "alabama"
    ## ----------------------------------------------------------------------
    fn.upper <- function(x){-sqrt(t(x) %*% spinv %*% x)}
    fn.lower <- function(x){sqrt(t(x) %*% spinv %*% x)}
    hin<-function(x){fcrit-k*t(x-mdiff) %*% spinv %*% (x-mdiff)}
    dm_lower<-max(0,auglag(par=mdiff, fn=fn.lower,hin=hin)$value)
    if (dm_lower<10e-5){ dm_lower=0}
    dm_upper<--auglag(par=mdiff, fn=fn.upper, hin=hin)$value
    ## ----------------------------------------------------------------------
    ##End Lagrange Multiplier Method
    ## ----------------------------------------------------------------------           
    
    if (dm_upper < dm_max) conclusion <- "Similar" else conclusion <- "Not similar"
    conclusion
    
    Compare<- paste(data_a1_a()$Condition[1], "vs", data_a1_b()$Condition[1], sep=" ")
    time_point<- length(unique(time))
    Dosage_unit<- length(unique(dat$unit))
    MSD<- dm[1,1]
    lower90<- dm_lower
    upper90<- dm_upper
    max_1 <- dm_max
    SL<- "10"
    odf<- data.frame(cbind(Compare, time_point, Dosage_unit, MSD, upper90, max_1, SL))
    names(odf)<- c("Compare", "Time points", "Dosage unit", "Mahalanobis Distance (MSD)", 
                    "Upper 90% CI (MSD)", "MAX MSD", "Similarity limit")
    return(odf)
  }
})

output$ui_6 <-  renderTable({MVA()}, caption=paste("MVA"),
                            caption.placement = getOption("xtable.caption.placement", "top"),
                            caption.width = getOption("xtable.caption.width", NULL))

# Define to.upper function
to.upper<-function(X) t(X)[lower.tri(X,diag=TRUE)]

# Define F2 function
f2<-function(Rt,Tt){
  y<-50*log10((1+sum((Rt-Tt)^2)/length(Tt))^(-0.5)*100)
  return(y)
}

data_mean<-reactive({
  inFile <- input$iFile
  if (is.null(inFile))
    return(NULL)
  
  wb <- loadWorkbook(inFile$datapath)
  lst1 = readWorksheet(wb, sheet = getSheets(wb), startRow = 1) 
  lst2 = readWorksheet(wb, sheet = getSheets(wb), startRow = 2, startCol = 1) 
  sheet = getSheets(wb)
  
  df <- data.frame()
  Time<-data.frame()
  i<-1
  while(i<=length(sheet)){
    Temp<-lst2[[i]]
    Temp.names<-names(Temp)
    Temp<-data.frame(Temp)
    names(Temp)<-Temp.names
    Temp$Condition<-names(lst1[[i]])[1]
    Temp.Time<-unname(lst1[[i]][1,2:dim(lst1[[i]])[2]])
    if(length(Temp.Time)>length(Time)){
      Time<-Temp.Time
    }
    
    df<-rbind.fill(df,Temp)
    i<-i+1
  }
  Time<-as.numeric(Time)
  names(df)[1]<-"Index"
  names(df)[2:(dim(df)[2]-1)]<-Time
  
  rm(Temp,Temp.Time,Temp.names)
  rm(lst1,lst2)
  rm(i,Time,wb,sheet)
  
  df.mean<-as.data.frame(aggregate(df[, 2:(dim(df)[2]-1)], list(df$Condition), mean, na.rm=TRUE))
  df.mean.name<-df.mean$Group.1
  df.mean<-df.mean[,-1]
  df.mean<-cbind("Condition"=df.mean.name,df.mean)
  df.mean$Condition
  return(df.mean)
})

df.mean.subset<-reactive({
  if (is.null(data_mean()))
    return(NULL)
  tmp<-data_mean()
  validate(
    need(input$Times_included_in_analysis != "", "Please at least select one time point"),
    need(length(input$Data_included_in_analysis) >=2, "Please at least select two data set")
  )
  tmp <- tmp[tmp$Condition %in% input$Data_included_in_analysis, ]
  temp.name<- input$Times_included_in_analysis
  temp.name<-c("Condition",temp.name)
  tmp <- tmp[,names(tmp) %in% temp.name]
  return(tmp)
})

# First row selection, then column selection
# Step 1: Row Selection
df.mean.rowSelection<-reactive({
  if (is.null(data_mean()))
    return(NULL)
  tmp<-data_mean()
  validate(
    # need(input$Times_F2 != "", "Please at least select one time point"),
    need(length(input$Data_included_in_analysis) >=2, "Please at least select two data set")
  )
  tmp <- tmp[tmp$Condition %in% input$Data_included_in_analysis, ]
  tmp <-tmp[, !apply(is.na(tmp), 2, all)]  # Remove columns from dataframe where ALL values are NA
  # temp.name<- input$Times_F2
  # temp.name<-c("Condition",temp.name)
  # tmp <- tmp[,names(tmp) %in% temp.name]
  return(tmp)
})

# Step 2: Column Selection
df.mean.columnSelection<-reactive({
  if (is.null(df.mean.rowSelection()))
    return(NULL)
  tmp<-df.mean.rowSelection()
  validate(
    need(input$Times_F2 != "", "Please at least select one time point")
  )
  temp.name<- input$Times_F2
  temp.name<-c("Condition",temp.name)
  tmp <- tmp[,names(tmp) %in% temp.name]
})


F2_stat_subset<-reactive({
  if (is.null(df.mean.columnSelection()))
    return(NULL)
  
  df.mean<-df.mean.columnSelection()
  df.mean<-as.data.frame(df.mean)
  
  L<-dim(df.mean)[1]
  P<-dim(df.mean)[2]-1
  Cand<-seq(L)
  df.mean.name<-df.mean$Condition
  
  f2.matrix.value<-matrix(rep(0, L*L), nrow = L, ncol = L)
  f2.matrix.name<-matrix(rep(0, L*L), nrow = L, ncol = L)
  f2.data<-df.mean[,-1]
  
  if(P<2){
    for (i in 1:L) {
      if((i+1)<=L){
        for (j in (i+1):L) {
          d12<-f2.data
          f2.matrix.value[i,j]=f2(d12[i],d12[j])
          f2.matrix.name[i,j]<-paste(df.mean.name[i],df.mean.name[j],sep = " Vs ")
        }
      }else{
        break
      }
    }
  }else{
    for (i in 1:L) {
      if((i+1)<=L){
        for (j in (i+1):L) {
          d12<-f2.data[c(i,j),]
          d12<-d12[ , apply(d12, 2, function(x) !any(is.na(x)))]
          d12<-as.matrix(d12)
          f2.matrix.value[i,j]=f2(d12[1,],d12[2,])
          f2.matrix.name[i,j]<-paste(df.mean.name[i],df.mean.name[j],sep = " Vs ")
        }
      }else{
        break
      }
    }
  }
  
  
  f2.matrix.value<-to.upper(f2.matrix.value)
  f2.matrix.value<-f2.matrix.value[f2.matrix.value!=0]
  f2.matrix.name<-to.upper(f2.matrix.name)
  f2.matrix.name<-f2.matrix.name[f2.matrix.name!=0]
  
  f2.matrix.name<-as.data.frame(f2.matrix.name)
  f2.matrix.value<-as.data.frame(f2.matrix.value)
  F2.table<-cbind(f2.matrix.name,f2.matrix.value)
  names(F2.table)<-c("Name","F2-Value")
  
  return(F2.table)
  
})

# Replace NA with Blank in Mean table
data_a3_mean_summary<-reactive({
  df<-data_a3_mean()
  is.num <- sapply(df, is.numeric)
  df[is.num] <- lapply(df[is.num], round, 2)
  df <- sapply(df, as.character)
  df[is.na(df)] <- " "
  return(as.data.frame(df))
})

data_a3_CV_summary<-reactive({
  df<-data_a3_CV()
  is.num <- sapply(df, is.numeric)
  df[is.num] <- lapply(df[is.num], round, 2)
  df <- sapply(df, as.character)
  df[is.na(df)] <- " "
  return(as.data.frame(df))
})


#__________________________________________________________________________________________________________________________

#--------------------------------------------------------------
output$table <- renderTable({data_a1_a()})
#--------------------------------------------------------------
output$table2<- renderTable({data_a2()})
#--------------------------------------------------------------
output$table3<- renderTable({data_a3_mean_summary()})
output$table4<- renderTable({data_a3_CV_summary()})
output$tablef2<- renderTable({F2_stat_subset()})
#--------------------------------------------------------------
output$plot_1 <- renderPlot(plots())
output$plot_2 <- renderPlot(plotm())


#---------------------------------------------------------------------------------------------------------------------------
#download plot
downloadFileType_plotC<-reactive({input$downloadFileType_plotC})

# write a function to print the plot in Tab2 Num 2
output$download_plotC<-downloadHandler(
  filename=function(){paste(paste(input$sheet, "Vs.", input$sheet2, sep=" "),
                            downloadFileType_plotC(),sep=".")},
  content = function(con){plotFunction<-match.fun(downloadFileType_plotC())                              
                          plotFunction(con) 
                          print(plots())
                          dev.off(which=dev.cur())})




Input.File.Name<-reactive({sub(pattern = "(.*)\\..*$", replacement = "\\1", input$iFile)})

output$download_plot_Tab2_Num1<-downloadHandler(
  filename=function(){paste(paste(Input.File.Name(), "mean_profiles_overlay", sep="_"),
                            downloadFileType_plotC(),sep=".")},
  content = function(con){plotFunction<-match.fun(downloadFileType_plotC())                              
  plotFunction(con) 
  print(plotm())
  dev.off(which=dev.cur())})

#---------------------------------------------------------------------------------------------------------------------------- 
#download file
#-------------------------------------------------------------------------------------------------------------------------------
#Create Excel file
output$download_dataC<- downloadHandler(
  filename = function() {paste(paste("data", input$sheet, "Vs.", input$sheet2, sep=" "),"xlsx", sep = ".")},    
  content = function(file){
    fname <- paste(file,"xlsx",sep=".")
    wb <- loadWorkbook(fname, create = TRUE)
    createSheet(wb, name = c("Mean", "CV", "Bootstrap", "MVA", "F2"))
    writeWorksheet(wb, data= list(data_a3_mean(), data_a3_CV(), bootS(), MVA(),F2_stat_subset()),
                   sheet = c("Mean", "CV", "Bootstrap", "MVA","F2")) 
    saveWorkbook(wb)
    file.rename(fname,file)
  }
)
#-------------------------------------------------------------------------------------------------------------------------------

##############################################################################################################################
##END
##To draw dissolution plots and perform bootstrapping for two dissolution profiles
###############################################################################################################################
#******************************************************************************************************************************************


##############################################################################################################################
##START: Simulation
##Take user input of mean and SD of dissolution values, and plot one simulation result for each test unit stratified by 3 different stages
###############################################################################################################################



#-------------------------------------------------------------------------------------------------------  
# one has an option to use  "input$var1" instead of "t1_()" to refer to user input var1 
#defined in ui.R file. In such case, the next 6 lines of code can be deleted

#mean
t1_ <- reactive({
  t1<- input$var1 }) 

t2_ <- reactive({
  t2<- input$var2 })   

t3_ <- reactive({       
  t3<- input$var3 })  
#----------------------------------------------------------------------------------------------------------  

#The reason of setting data1 as a reactive ogject is to allow calling this
#same object for either plotting or saving simulated data as csv file

data1<-reactive({
  
  if (t1_() != "" & t2_() != "") {
    
    #implement of resampling option
    input$action      
    size=as.numeric(input$var002)
    batch<-rnorm(size, mean = as.numeric(t1_()), sd = as.numeric(t2_())*as.numeric(t1_())/100) #Generate batch dissolution values based user definded mean and sd
    #mimic stage 1
    no1<-sample(batch,6) 
    
    #mimic stage 2
    no2<-c(no1,sample(batch[-no1],6)) 
    
    #mimic stage 3
    no3<-c(no2,sample(batch[-c(no1,no2)],12))     
    
    s_1 <- 1:6
    s_1x<-rep("Stage 1",6)
    stage_1<-data.frame(s_1, no1, s_1x)
    names(stage_1) <- c("unit","Percentage_dissolution","Stage")
    
    s_2 <- 1:12
    s_2x <-rep("Stage 2",12)
    stage_2 <- data.frame(s_2, no2, s_2x)
    names(stage_2) <- c("unit","Percentage_dissolution","Stage")
    
    s_3<-1:24
    s_3x <-rep("Stage 3",24)
    stage_3 <- data.frame(s_3, no3, s_3x)
    names(stage_3) <- c("unit","Percentage_dissolution","Stage")
    
    Comb <- rbind.fill(stage_1, stage_2, stage_3)    
    ff2<- Comb
    
    if (is.null(ff2)) {
      print("Please make sure a correct name is filled in the blank 2.")
    } 
    
    else {
      return(ff2)
    }
  }
  
})

#Below use data frame built in previous section to draw plots: g1 is for a simulation of stage 1   
#g2 for stage 2, and g3 for stage 3
map2 <- reactive({
  
  if (is.null(data1())) {
    print("Please make sure a correct name is filled in the blank 2.")
    
  }
  else {        
    ff2<-data1()
    
    g1<-ggplot(subset(ff2,Stage=="Stage 1")) +
      geom_point(aes(x=unit,y=Percentage_dissolution)) + 
      
      #set reference line for Q+5
      geom_hline(yintercept=as.numeric(t3_())+5) +  
      
      #set reference line for Q
      geom_hline(yintercept=as.numeric(t3_()), colour="red") + 
      
      #draw point for mean dissolution
      geom_point(aes(x=3.5,y=mean(Percentage_dissolution), size=2, colour="red")) + 
      theme(axis.text.x = element_text(angle=0,family = "sans", colour="black"),
            axis.text.y = element_text(family = "sans",colour="black"),
            legend.position = "none")+ 
      labs(title=" Stage 1") +
      ylab("% Dissolved")+ xlab('Unit No.') +
      scale_y_continuous(limits = c(ifelse(min(ff2$Percentage_dissolution)<as.numeric(t3_())-35,
                                           min(ff2$Percentage_dissolution)-10, as.numeric(t3_())-35),      
                                    
                                    # set minimum and maximum for y axis according to user input
                                    max(ff2$Percentage_dissolution)+10)) 
    
    
    g2<-ggplot(subset(ff2,Stage=="Stage 2")) +
      geom_point(aes(x=unit,y=Percentage_dissolution)) +                                    
      geom_hline(yintercept=as.numeric(t3_()), colour="red") +
      geom_hline(yintercept=as.numeric(t3_())-15, colour="blue") +
      geom_point(aes(x=6.5,y=mean(Percentage_dissolution), size=2, colour="red")) +
      theme(axis.text.x = element_text(angle=0,family = "sans", colour="black"),
            axis.text.y = element_text(family = "sans",colour="black"),
            legend.position = "none") + 
      labs(title=" Stage 2") +
      ylab("")+ xlab('Unit No.') +
      scale_y_continuous(limits = c(ifelse(min(ff2$Percentage_dissolution)<as.numeric(t3_())-35,
                                           min(ff2$Percentage_dissolution)-10, as.numeric(t3_())-35),                                        
                                    max(ff2$Percentage_dissolution)+10)) +
      scale_x_continuous(limits = c(1, 14))
    
    g3<-ggplot(subset(ff2,Stage=="Stage 3")) +
      geom_point(aes(x=unit,y=Percentage_dissolution)) +                                                
      geom_hline(yintercept=as.numeric(t3_())-15, colour="blue") +
      geom_hline(yintercept=as.numeric(t3_()), colour="red") +
      geom_point(aes(x=12.5,y=mean(Percentage_dissolution), size=2, colour = "red")) +
      geom_hline(yintercept=as.numeric(t3_())-25, colour="orange", linetype=2) +          
      theme(axis.text.x = element_text(angle=0,family = "sans", colour="black"),
            axis.text.y = element_text(family = "sans",colour="black"),
            legend.position = "none") + 
      labs(title=" Stage 3") +
      ylab("")+ xlab('Unit No.')+
      scale_y_continuous(limits = c(ifelse(min(ff2$Percentage_dissolution)<as.numeric(t3_())-35,
                                           min(ff2$Percentage_dissolution)-10, as.numeric(t3_())-35),                                        
                                    max(ff2$Percentage_dissolution)+10))
    plot_grid(g1, g2, g3, ncol = 3, nrow = 1)
  }
})


#-------------------------------------------------------------------------------------------------------------
output$map2 <- renderPlot({print(map2())})


#---------------------------------------------------------------------------------------------------------------------------
#download plot
downloadFileType_plot1<-reactive({input$downloadFileType_plot1})
# write a function to print the plot
output$download_plot1<-downloadHandler(
  filename=function(){paste(paste("Simulated dissolution_", "Mean", t1_(), "_", "CV", t2_(), "_",
                                  "Q", t3_(), sep=" "),
                            downloadFileType_plot1(),sep=".")},
  
  content = function(con){plotFunction<-match.fun(downloadFileType_plot1())                              
                          plotFunction(con) 
                          print(map2())
                          dev.off(which=dev.cur())})


#----------------------------------------------------------------------------------------------------------------------------
############
#Simulate 50 times to see the pass rate
############

data2<-reactive({
  input$action_1 
  if (input$action_1 == 0) {
    return() }
  else {
    isolate ({
      if (t1_() != "" & t2_() != "") {
        t3_ <- as.numeric(t3_()) 
        df <- data.frame()
        
        #use "withProgress", so the end user could see the progress and has the estimation on overall process time
        withProgress(message = 'Data Processing',    
                     detail = 'This may take a while...', value = 0, {
                       
                       for (i in 1:input$var4) {
                         incProgress(1/as.numeric(input$var4), detail = paste("Doing part", i, "out of", input$var4, sep=" "))
                         size=as.numeric(input$var002)
                         batch<-rnorm(size, mean = as.numeric(t1_()), sd = as.numeric(t2_())*as.numeric(t1_())/100) #Generate batch dissolution values based user definded mean and sd
                         s24 <- sample(batch,24)  
                         s_1 <- ifelse(mean(ifelse(s24[1:6]>= t3_+5, 1,0)) == 1, 1,  0)  #pass stage 1 count as 1
                         if (s_1 == 1) {  
                           s_2 <- 1
                           s_3 <- 1
                         } else {
                           s_2 <- ifelse(mean(s24[1:12]) >= t3_ & mean(ifelse(s24[1:12]>= t3_-15, 1,0)) ==1, 1, 0)
                           if (s_2 == 1) {  
                             s_3 <- 1
                           } else {
                             s_3 <- ifelse(mean(s24[1:24]) >= t3_ & 
                                             sum(ifelse(s24[1:24]<= t3_-15, 1,0)) <= 2 &
                                             mean(ifelse(s24[1:24]>= t3_-25, 1,0)) == 1
                                           , 1, 0)
                           }
                           
                         }
                         tmp <- data.frame(s_1, s_2, s_3)
                         
                         ifelse(length(df) == 0, df <- tmp, df <- rbind.fill(df, tmp))
                       }
                     }
        )
        
        ff2 <- data.frame(s1 <- 100*sum(df$s_1)/as.numeric(input$var4),
                          s2 <- 100*sum(df$s_2)/as.numeric(input$var4),
                          s3 <- 100*sum(df$s_3)/as.numeric(input$var4))
        ff2$No <- input$var4
        ff2$Mean <- input$var1
        ff2$CV <- input$var2
        ff2$Q <- input$var3    
        
        colnames(ff2)<- c("Pass Stage 1 (%)", "Pass Stage 2 (%)", "Pass Stage 3 (%)", "No. of simulations", 
                          "Mean release (%)", "CV (%)", "Q (%)")
        if (is.null(ff2)) {
          print("Please make sure a correct name is filled in the blank 2.")
        } 
        else {
          return(ff2)
        }
      }
      #end of isolate
    })
  } 
})
output$table5<- renderTable({data2()}, include.rownames=FALSE)

#download file
#-------------------------------------------------------------------------------------------------------------------------------
#Create Excel file
output$download_dataS<- downloadHandler(
  filename = function() {paste(paste("Simulated dissolution_", "Mean", t1_(), "_", "CV", t2_(), "_",
                                     "Q", t3_(), sep=" "),"xlsx", sep = ".")},
  content = function(file){
    fname <- paste(file,"xlsx",sep=".")
    wb <- loadWorkbook(fname, create = TRUE)
    createSheet(wb, name = c("Simulated data for the plot", "Pass rate"))
    writeWorksheet(wb, data= list(data1(), data2()),
                   sheet = c("Simulated data for the plot", "Pass rate")) # writes numbers 1:3 in file
    saveWorkbook(wb)
    file.rename(fname,file)
  }
)
#-------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################
##END: Simulation
##Take user input of mean and SD of dissolution values, and plot one simulation result for each test unit stratified by 3 different stages
###############################################################################################################################
#*********************************************************************************************************************************************************** 
#--------------------------------------------------------------------------------------------------------------------------------


#-------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################
##Start: Summary
###############################################################################################################################
#*********************************************************************************************************************************************************** 
#--------------------------------------------------------------------------------------------------------------------------------

##Drug@FDA
output$table_FDAm_summary_text1<-renderText({if("Drug@FDA" %in% input$Results_Included & !is.null(mached_info())) {"Drug@FDA"} })
output$table_FDAm_summary <- renderTable({
  if("Drug@FDA" %in% input$Results_Included) {mached_info()}
}, include.rownames=FALSE)
output$table_FDAm_summary_text2<-renderText({ 
  if("Drug@FDA" %in% input$Results_Included & !is.null(mached_info())) {"Note: information within RLD column is arranged as (A)NDA number, API, Brand name, Dosage form, Route of administration"}
})

##Therapeutic Equivalents
output$table_FDAg_summary_text1<-renderText({if("Therapeutic Equivalents" %in% input$Results_Included & !is.null(mached_ANDA()[,-3]) ) {"Therapeutic Equivalents"} })
output$table_FDAg_summary <- renderTable({
  if("Therapeutic Equivalents" %in% input$Results_Included){mached_ANDA()[,-3]}
}, include.rownames=FALSE)

##Orange book
output$table_FDAgo_summary_text1<-renderText({if("Orange book" %in% input$Results_Included & !is.null(mached_ANDA_o())) {"Orange book: Reference Standard / Approval date / TE code"} })
output$table_FDAgo_summary <- renderTable({
  if("Orange book" %in% input$Results_Included){mached_ANDA_o_BLANK()}
}, include.rownames=FALSE)

##Exclusivity date from Orange book
output$table_FDAge_summary_text1<-renderText({if("Exclusivity date from Orange book" %in% input$Results_Included & !is.null(mached_ANDA_e())) {"Exclusivity date from Orange book"} })
output$table_FDAge_summary <- renderTable({
  if("Exclusivity date from Orange book" %in% input$Results_Included){mached_ANDA_e_BLANK()}
}, include.rownames=FALSE)

##FDA Dissolution Database
output$table_FDAd_summary_text1<-renderText({if("FDA Dissolution Database" %in% input$Results_Included  & !is.null(df_FDAd())) {"FDA Dissolution Database"} })
output$table_FDAd_summary <- renderTable({
  if("FDA Dissolution Database" %in% input$Results_Included){df_FDAd()}
}, include.rownames=FALSE)

##USP Dissolution Database
output$table_USPd_summary_text1<-renderText({if("USP Dissolution Database" %in% input$Results_Included  & !is.null(df_USPd())) {"USP Dissolution Database"} })
output$table_USPd_summary <- renderTable({
  if("USP Dissolution Database" %in% input$Results_Included){df_USPd_BLANK()}
}, include.rownames=FALSE)

##Drug bank 1
output$bank1_summary_text1<-renderText({if("Drug bank_Pharmacological properties" %in% input$Results_Included) {"Pharmacological properties from Drug bank"} })
output$bank1_summary <- shiny::renderDataTable({
  if("Drug bank_Pharmacological properties" %in% input$Results_Included){DrugBank.Info.1()}
},escape = FALSE,options = list(paging = FALSE,searching = FALSE,dom='t',ordering=F))

##Drug bank 2
output$bank2_summary_text1<-renderText({if("Drug bank_PK properties" %in% input$Results_Included) {"PK properties from Drug bank"} })
output$bank2_summary <- shiny::renderDataTable({
  if("Drug bank_PK properties" %in% input$Results_Included){DrugBank.Info.2()}
},escape = FALSE,options = list(paging = FALSE,searching = FALSE,dom='t',ordering=F))

##Mean dissolution plot
output$plot_2_summary_text2<-renderText({if("Mean dissolution plot" %in% input$Results_Included & !is.null(plotm())) {"Mean dissolution plot"} })
output$plot_2_summary <- renderPlot({
  if("Mean dissolution plot" %in% input$Results_Included){plotm()}
})
output$plot_2_summary_text1<-renderText({if("Mean dissolution plot" %in% input$Results_Included & !is.null(plotm())) {"Red horizontal line: Q(%); Blue horizontal line: Q-15%"} })


##F2 Comparison
output$tablef2_summary_text1<-renderText({if("F2 Comparison" %in% input$Results_Included & !is.null(F2_stat_subset())) {"F2 Comparison"} })
output$tablef2_summary <- renderTable({
  if("F2 Comparison" %in% input$Results_Included){F2_stat_subset()}
})

##Dissolution plots
output$plot_1_summary_text1<-renderText({if("Dissolution plots" %in% input$Results_Included & !is.null(plots())) {"Dissolution plots"} })
output$plot_1_summary <- renderPlot({
  if("Dissolution plots" %in% input$Results_Included){plots()}
})
output$plot_1_summary_text2<-renderText({if("Dissolution plots" %in% input$Results_Included & !is.null(plots())) {"Red line: Q(%);    Blue line: Q-15%;    
  Red dot: mean value for all units per time point. Note, the whole column represents the same time point."} })

##MVA
output$ui_6_summary <-  renderTable({if("MVA" %in% input$Results_Included){MVA()}}, caption=paste("MVA"),
                                    caption.placement = getOption("xtable.caption.placement", "top"),
                                    caption.width = getOption("xtable.caption.width", NULL))
output$ui_6_summary_text1<-renderText({if("MVA" %in% input$Results_Included & !is.null(MVA())) {"In MVA, the similarity can be verified if the upper bound of the confidence interval is smaller or equal to the MAX MSD"} })

##Bootstrapping
output$ui_5_summary <-  renderTable(
  {if("Bootstrapping" %in% input$Results_Included){bootS()}}, caption=paste("Boostrapping result"),
  caption.placement = getOption("xtable.caption.placement", "top"),
  caption.width = getOption("xtable.caption.width", NULL))
output$ui_5_summary_text1<-renderText({if("Bootstrapping" %in% input$Results_Included & !is.null(bootS())) {"In bootstrapping, the similarity can be verified if the lower bound of the confidence interval is larger or equal to 50"} })


##Mean
output$table3_summary<- renderTable({if("Mean" %in% input$Results_Included){data_a3_mean_summary()}})


#CV(%)
output$table4_summary<- renderTable({if("CV(%)" %in% input$Results_Included){data_a3_CV_summary()}})

##Simulated results
output$map2_summary_text1<-renderText({if("Simulated results" %in% input$Results_Included & !is.null(map2())) {"Simulated results"} })
output$map2_summary<-renderPlot({
  if("Simulated results" %in% input$Results_Included){map2()}
})

#Pass rate(%)
output$table5_summary_text1<-renderText({if("Pass rate(%)" %in% input$Results_Included & !is.null(data2())) {"Pass rate(%)"} })
output$table5_summary<-renderTable(
  {
    if("Pass rate(%)" %in% input$Results_Included)
    {data2()}
  },
  include.rownames=FALSE
)


##word document
##======================================================================================
mached_info_report<-reactive({
  input$Results_Included
  if("Drug@FDA" %in% input$Results_Included) {
    return(mached_info())}
})


mached_ANDA_report<-reactive({
  input$Results_Included
  if("Therapeutic Equivalents" %in% input$Results_Included) {
    return(mached_ANDA())}
})


mached_ANDA_o_report<-reactive({
  input$Results_Included
  if("Orange book" %in% input$Results_Included) {
    return(mached_ANDA_o_BLANK())}
})


mached_ANDA_e_report<-reactive({
  input$Results_Included
  if("Exclusivity date from Orange book" %in% input$Results_Included) {
    return(mached_ANDA_e_BLANK())}
})


df_FDAd_report<-reactive({
  input$Results_Included
  if("FDA Dissolution Database" %in% input$Results_Included) {
    return(df_FDAd())}
})


df_USPd_report<-reactive({
  input$Results_Included
  if("USP Dissolution Database" %in% input$Results_Included) {
    return(df_USPd_BLANK())}
})


plotm_report<-reactive({
  input$Results_Included
  if("Mean dissolution plot" %in% input$Results_Included) {
    return(plotm())}
})



F2_stat_subset_report<-reactive({
  input$Results_Included
  if("F2 Comparison" %in% input$Results_Included) {
    return(F2_stat_subset())}
})


plots_report<-reactive({
  input$Results_Included
  if("Dissolution plots" %in% input$Results_Included) {
    return(plots())}
})


MVA_report<-reactive({
  input$Results_Included
  if("MVA" %in% input$Results_Included) {
    return(MVA())}
})


bootS_report<-reactive({
  input$Results_Included
  if("Bootstrapping" %in% input$Results_Included) {
    return(bootS())}
})


data_a3_mean_report<-reactive({
  input$Results_Included
  if("Mean" %in% input$Results_Included & !is.null(input$iFile)) {
    return(data_a3_mean_summary())}
})



data2_data_a3_CV_report<-reactive({
  input$Results_Included
  if("CV(%)" %in% input$Results_Included & !is.null(input$iFile)) {
    return(data_a3_CV_summary())}
})


map2_report<-reactive({
  input$Results_Included
  if("Simulated results" %in% input$Results_Included) {
    return(map2())}
})


data2_report<-reactive({
  input$Results_Included
  if("Pass rate(%)" %in% input$Results_Included) {
    return(data2())}
})

DrugBank.Info.1_report<-reactive({
  input$Results_Included
  if("Drug bank_Pharmacological properties" %in% input$Results_Included) {
    return(DrugBank.Info.1())}
})


DrugBank.Info.2_report<-reactive({
  input$Results_Included
  if("Drug bank_PK properties" %in% input$Results_Included) {
    return(DrugBank.Info.2())}
})



Word.Name.1<-reactive({
  if(!is.null(input$var_lab) & !is.null(input$RLD)){
    return(paste0(input$RLD,"_",sep=""))
  }
})


Word.Name.2<-reactive({
  if(!is.null(input$iFile))
    return(paste0(Input.File.Name()[1],"_",sep=""))
})



output$download_summary <- downloadHandler(
  # filename = "report_001.doc",
  filename = function() {paste0("Summary_",Word.Name.1(),Word.Name.2()[1],"report.doc",sep="")},
  content = function(file) {
    tempReport <- file.path(tempdir(), "report.Rmd")
    file.copy("report.Rmd", tempReport, overwrite = TRUE)
    rmarkdown::render(tempReport, output_file = file,
                      params=list(  
                        Drug_FDA=mached_info_report(),
                        Therapeutic_Equivalents=mached_ANDA_report(),
                        Orange_book=mached_ANDA_o_report(),
                        Exclusivity_date_from_Orange_book=mached_ANDA_e_report(),
                        FDA_Dissolution_Database=df_FDAd_report(),
                        USP_Dissolution_Database=df_USPd_report(),
                        Drug_bank_Pharmacological_properties=DrugBank.Info.1_report(),
                        Drug_bank_PK_properties=DrugBank.Info.2_report(),
                        Mean_dissolution_plot=plotm_report(),
                        F2_Comparison=F2_stat_subset_report(),
                        Dissolution_plots=plots_report(),
                        MVA=MVA_report(),
                        Bootstrapping=bootS_report(),
                        Mean=data_a3_mean_report(),
                        CV=data2_data_a3_CV_report(),
                        Simulated_results=map2_report(),
                        Pass_rate=data2_report()),
                      envir = new.env(parent = globalenv())
    )
  }
)




#-------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################
##End: Summary
###############################################################################################################################
#*********************************************************************************************************************************************************** 
#--------------------------------------------------------------------------------------------------------------------------------






















output$text_C <- renderText({
  
#   paste(c("Colleagues contributing to the realization of this tool are listed below (arranged by last name):",   #2_28_2017_Hopi delete
#           "Anand, Om",             
#           "Chatterjee, Parnali", 
#           "Chen, Hansong",
#           "Delvadia, Poonam",
#           "Duan, John Z.",
#           "Eradiri, Okpo",
#           "Gieser, Gerlie",
#           "Li, Min",
#           "Lin, Ho-Pi",
#           "Ou, Mei", 
#           "Raines, Kimberly",
#           "Seo, Paul",
#           "Wang, Meng",
#           "Wu, Ta-Chen",
#           "Xue, Jie",
#           "Xu, Heng",
#           "Zhang, Qi",
#           "Zhao, Joan"),"\n", sep="")
  
  
  paste(c("The DB review tool working group meets monthly to facilitate the development of the tool.",    #2_28_2017_Hopi change to the following
          "\n",
          "Subgroups listed below (names are arranged alphabetically) may meet more frequently to complete their tasks.",
		"1. Manual writing subgroup",             
                "Heng Xu, Jie Xue,  Min Li, and Parnali Chatterjee", 
               # "\n",
                "2. Validation report writing subgroup",
		"Hansong  Chen, Heng  Xu, and Mei Ou",
	#	"\n",
		"3. Beta testing subgroup", 
		"Joan Zhao, Gerlie Gieser, Poonam Delvadia (beta testing lead), and Qi Zhang",
	#	"\n",
		"4. Proof reading subgroup",
		"Okpo Eradiri, and Ta-Chen Wu",
	#	"\n",
		"5. Developers subgroup",
		"Heng  Xu, Ho-Pi Lin (working group lead) and Jie Xue", 
	#	"\n",
		"6. Senior leadership",
		"John Duan, Kimberly Raines, Paul Seo",
		"\n",
		"The validation reports were done by colleagues who compared  between results from using DB review tool", 
"and those from using alternative tools/methods. Beta testers meet frequently with developers and manual",
		"writers to provide instant feedbacks regarding errors and accuracy and to suggest additional features",
		"that are useful for DB reviewers. The maturation of the tool cannot be done without beta testers.",
		"The developer subgroup maintains the computer codes for the tool and works with all sub groups closely.", 
		"The working group thanks the leadership team for their guidance. Without their visions and supports,", 
      "this project would not be as successful. The working group also thanks Meng Wang, Om Anand, ",
      "and Tien Mien Chen for their helpful comments and/or contributions to the development of this tool."),
		"\n", sep="")
})
})