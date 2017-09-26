

shinyUI(navbarPage("BioPharm tools",
                   navbarMenu("Info collection",
                              tabPanel(
                                "Info collection based on drug name",
                                fluidRow(   
                                  tags$div(
                                    HTML(paste("It may take upto ", tags$span(style = "color:red", "1 minute"),
                                               "for the data to be downloaded. The App can be non-responsive before then.", 
                                               sep = " "))),
                                  helpText(h5("Note: Opening this application in Chrome or Firefox is known to provide good resolution.")),
                                  helpText(h5("Please report any error messages to \"ho-pi.lin@fda.hhs.gov\" 
                                              with the uploaded file if applicable. Thank you!")),
                                  helpText(h5("Please also report error messages to \"Jie.Xue@fda.hhs.gov\" and \"Heng.Xu@fda.hhs.gov\". Thank you!")),
                                  helpText(h4(tags$b("Please type in generic name of the drug of interest."))),
                                  column(4,wellPanel(wellPanel(
                                    textInput("var_lab", 
                                              label = "Name of API")
                                  ),
                                  br(),
                                  tags$hr(),
                                  uiOutput(outputId = "ui_FDA1"),
                                  helpText("Please select RLD of interest."),
                                  tags$hr(),
                                  downloadButton(outputId='download_dataL',label='Download data file')#),width=3)
                                  )),
                                  
                                  mainPanel(
                                    helpText(h4("Drug@FDA")),
                                    tableOutput('table_FDAm'),
                                    textOutput('FDA_Error_Message'),
                                    tags$head(tags$style("#FDA_Error_Message{color: red;font-size: 20px;
                                                         font-style: italic;
                                                         }")),
                   helpText(h5(paste("Note: information within RLD column is arranged as", "(A)NDA number, API, Brand name, Dosage form, Route of administration", sep=" "))),  #2_23_2017_Hopi delete "strength"
                   br(),
                   helpText(h4("Therapeutic Equivalents")),
                   tableOutput('table_FDAg'),
                   br(),
                   tags$hr(),
                   helpText(h4("Therapeutic Equivalents: Reference Standard / Approval date / TE code")), #2_23_2017_Hopi change
                   tableOutput('table_FDAgo'),
                   br(),
                   tags$hr(),
                   helpText(h4("Exclusivity date from Orange book")),
                   tableOutput('table_FDAge'),
                   br(),
                   tags$hr(),
                   helpText(h4("FDA Dissolution Database")),
                   tableOutput('table_FDAd'),
                   textOutput('FDA_diss_Error_Message'),
                   tags$head(tags$style("#FDA_diss_Error_Message{color: red;font-size: 20px;
                                        font-style: italic;
                                        }")),
                   br(),
                   br(),
                   helpText(h4("USP Dissolution Database")),
                   tableOutput('table_USPd'),
                   textOutput('USP_Error_Message'),
                   tags$head(tags$style("#USP_Error_Message{color: red;font-size: 20px;
                                        font-style: italic;
                                        }"))))),
                   
                   tabPanel("DrugBank",
                            sidebarPanel(
                              # fileInput(inputId = "iFile", multiple = F, label = "Upload Excel files", accept="application/vnd.ms-excel"),
                              # br(),
                              # tags$hr(),
                              # uiOutput(outputId = "ui_3"),
                              # tags$hr(),
                              # uiOutput(outputId = "ui_4")
                              helpText(h4(tags$b("Please type in generic name of the drug of interest."))),
                              textInput("var_lab_DB", "Name of API"),
                              # updateTextInput("var_lab_DB", 
                              #           label = "Name of API",value=uiOutput(outputId = "ui_FDA1")),
                              br(),
                              tags$hr(),
                              uiOutput(outputId = "ui_DrugBankSelect"),
                              helpText("Please select Drug of interest.")
                            ),
                            mainPanel(
                              textOutput('DrugBank_Error_Message_1'),
                              tags$head(tags$style("#DrugBank_Error_Message_1{color: black;
                                                   font-size: 20px;
                                                   font-style: italic;
                                                   }"
                                                  )
                                        ),
                              dataTableOutput('DrugBankTable_1'),
                              br(),
                              textOutput('DrugBank_Error_Message_2'),
                              tags$head(tags$style("#DrugBank_Error_Message_2{color: black;
                                                                              font-size: 20px;
                                                                              font-style: italic;
                                                                            }"
                                                   )
                                        ),
                              dataTableOutput('DrugBankTable_2')
                            )
                                )
                              )
                   ,
                   tabPanel("Dissolution Comparison",
                            helpText(h5("Note: Opening this application in Firefox is known to provide good resolution.")),
                            # Control panel;
                            sidebarPanel(
                              fileInput(inputId = "iFile", multiple = F, label = "Upload Excel files", accept="application/vnd.ms-excel"),
                              # uiOutput(outputId = "ui_3"),
                              br(),
                              downloadButton(
                                outputId = "download_plot_Tab2_Num1", 
                                label = "Download mean profiles overlay"),
                              tags$hr(),
                              uiOutput(outputId = "ui_a1_a"),
                              uiOutput(outputId = "ui_3"),
                              uiOutput(outputId = "ui_F2_Time"),
                              uiOutput(outputId = "ui_a1_b"),
                              br(),
                              tags$hr(),
                              uiOutput(outputId = "ui_1"),
                              uiOutput(outputId = "ui_2"),
                              uiOutput(outputId = "ui_4"),
                              tags$hr(), 
                              textInput("var001", value = 500,
                                        label = "Number of replications for the bootstrapping"), 
                              actionButton("action_2", "Press for bootstrapping"),
                              tags$hr(),
                              selectInput(
                                inputId = "downloadFileType_plotC",
                                label = h4("Select download file type"),
                                choices = list(
                                  "pdf" = "pdf",
                                  "bmp" = "bmp",
                                  "jpeg" = "jpeg",
                                  "png" = "png",
                                  "tiff"="tiff")),
                              div(),
                              downloadButton(
                                outputId = "download_plotC", 
                                label    = "Download jitter plots"),
                              tags$hr(),
                              downloadButton(outputId='download_dataC',label='Download data file'),
                              width = 3),
                            tags$head(
                              tags$style(HTML("
                                              .shiny-output-error-validation {
                                              color: red;
                                              }
                                              "))
                              ),
                            mainPanel(
                              plotOutput('plot_2'),
                              helpText(h4("Mean plot: Red horizontal line: Q(%);    Blue horizontal line: Q-15%  
                                          ")),
                              br(),
                              tableOutput('tablef2'),
                              br(),
                              plotOutput('plot_1'),
                              helpText(h4("Red line: Q(%);    Blue line: Q-15%;    
                                          Red dot: mean value for all units per time point. Note, the whole column represents the same time point.")),
                              br(),
                              # plotOutput('plot_2'),
                              #  helpText(h4("Mean plot: Red horizontal line: Q(%);    Blue horizontal line: Q-15%  
                              #          ")),
                              br(),
                              tags$hr(),                        
                              tableOutput('ui_6'),
                              helpText(h4("In MVA, the similarity can be verified if the upper bound of the confidence interval is smaller or equal to the MAX MSD  
                                          ")),
                              br(),
                              tags$hr(),
                              tableOutput('ui_5'),
                              helpText(h4("In bootstrapping, the similarity can be verified if the lower bound of the confidence interval is larger or equal to 50  
                                          ")),
                              br(),
                              br(),
                              tags$hr(),
                              tableOutput('table3'),
                              br(),
                              tags$hr(),
                              tableOutput('table4')
                              )
                              ),
                   
                   tabPanel("Simulation Tool",
                            sidebarLayout(sidebarPanel(wellPanel(
                              helpText(h4("Change the default numbers to 
                                          display graphical results based on user inputs and the assumption of normal distribution.")),
                              textInput("var3", value = 80,
                                        label = "specification of dissolution: Q (%)"),  
                              textInput("var002", value = 100000,   #2_23_2017_Hopi change from 5000
                                        label = "Size of each batch"),
                              textInput("var1", value = 83,
                                        label = "mean dissolution (%) of each batch"),
                              helpText("i.e. 80 means mean percent dissolution is 80%"),
                              textInput("var2", value = 10,
                                        label = "CV% of dissolution of each batch"),
                              helpText("i.e. 10 means CV is 10%"),
                              actionButton("action", "Resample")),  
                              div(),
                              tags$hr(),
                              helpText(h4("Estimate pass rate based on mean and CV")),
                              textInput("var4", value = 50,
                                        label = "Number of batches simulated"),  
                              actionButton("action_1", "Simulate to see batch pass rate"),  
                              tags$hr(),
                              selectInput(
                                inputId = "downloadFileType_plot1",
                                label = h4("Select download file type"),
                                choices = list(
                                  "pdf" = "pdf",
                                  "bmp" = "bmp",
                                  "jpeg" = "jpeg",
                                  "png" = "png",
                                  "tiff"="tiff")),
                              div(),
                              downloadButton(
                                outputId = "download_plot1", 
                                label    = "Download the plot"),
                              tags$hr(),
                              downloadButton(outputId='download_dataS',label='Download data file'),
                              width=3),  
                              mainPanel(
                                helpText(h3("Per USP, for IR formulation, to pass stage 1: each unit is not less than Q+5%; 
                                            To pass stage 2: Average (S1+S2) is equal to or greater than Q, and no usnit is less than Q-15%; 
                                            To pass stage 3: Average (S1+S2+S3) is equal to or greater than Q, not more than 2 units are less than Q-15%, and
                                            no unit is less than Q-25%")),
                                helpText(h4("Graph displays the simulated results based on user defined dissolution specs, mean, and %CV")),
                                plotOutput("map2"),
                                helpText(h4("Black line: User defined specs(Q)+5%;    Red line: Q(%);    Blue line: Q-15%;    
                                            dash red line: Q-25%;    Red dot: mean value for all units per time point")),
                                br(),
                                helpText(h3("Pass rate (%) based on number of simulations specified")),
                                tableOutput('table5')
                                )
                                )
                              ),
                   tabPanel("Summary",
                            
                            helpText(h3("Note: This page is only to collect a summary report based on the previous results,")),
                            helpText(h3("Please operate in previous tabs first, otherwise nothing will show here.")),
                            sidebarPanel(
                              checkboxGroupInput("Results_Included", "Choose what to include in the summary report", 
                                                 choices  = c("Drug@FDA","Therapeutic Equivalents","Orange book","Exclusivity date from Orange book","FDA Dissolution Database","USP Dissolution Database",
                                                              "Drug bank_Pharmacological properties", "Drug bank_PK properties", "Mean dissolution plot","F2 Comparison","Dissolution plots","MVA","Bootstrapping","Mean","CV(%)","Simulated results","Pass rate(%)"),
                                                 selected  = c("Drug@FDA","Therapeutic Equivalents","Orange book","Exclusivity date from Orange book","FDA Dissolution Database","USP Dissolution Database",
                                                              "Mean dissolution plot","F2 Comparison","Dissolution plots","MVA","Bootstrapping","Mean","CV(%)","Simulated results","Pass rate(%)")),
                              downloadButton(
                                outputId = "download_summary", 
                                label    = "Download the summary")
                              
                              
                            ),
                            mainPanel(
                              helpText(h2("Summary Report")),
                              br(),
                              ####First tab===================================================
                              textOutput("table_FDAm_summary_text1"),
                              tableOutput('table_FDAm_summary'),
                              textOutput("table_FDAm_summary_text2"),
                              br(),
                              textOutput('table_FDAg_summary_text1'),
                              tableOutput('table_FDAg_summary'),
                              br(),
                              textOutput('table_FDAgo_summary_text1'),
                              tableOutput('table_FDAgo_summary'),
                              br(),
                              textOutput('table_FDAge_summary_text1'),
                              tableOutput('table_FDAge_summary'),
                              br(),
                              textOutput('table_FDAd_summary_text1'),
                              tableOutput('table_FDAd_summary'),
                              br(),
                              textOutput('table_USPd_summary_text1'),
                              tableOutput('table_USPd_summary'),
                              br(),
                              textOutput('bank1_summary_text1'),
                              dataTableOutput('bank1_summary'),
                              br(),
                              textOutput('bank2_summary_text1'),
                              dataTableOutput('bank2_summary'),
                              br(),
                              ##Second tab=====================================================
                              textOutput('plot_2_summary_text2'),
                              plotOutput('plot_2_summary'),
                              textOutput('plot_2_summary_text1'),
                              br(),
                              textOutput('tablef2_summary_text1'),
                              tableOutput('tablef2_summary'),
                              br(),
                              textOutput('plot_1_summary_text1'),
                              plotOutput('plot_1_summary'),
                              textOutput('plot_1_summary_text2'),
                              br(),
                              tableOutput('ui_6_summary'),
                              textOutput('ui_6_summary_text1'),
                              br(),
                              tableOutput('ui_5_summary'),
                              textOutput('ui_5_summary_text1'),
                              br(),
                              tableOutput('table3_summary'),
                              br(),
                              tableOutput('table4_summary'),
                              br(),
                              ##Third tab======================================================
                              textOutput('map2_summary_text1'),
                              plotOutput("map2_summary"),
                              br(),
                              textOutput('table5_summary_text1'),
                              tableOutput("table5_summary")
                              
                            )
                   ),
                   tabPanel("Resource & Acknowledgement",
                            sidebarLayout(sidebarPanel(width = 0),
                                          mainPanel(width= 11.2,     #2_28_2017_Hopi add "width= 11.2". Also change names
                                                    helpText(h2("Resources")),
                                                    p(a("Manual", href = "http://my.fda.gov/personal/ho-pi_lin/DB_review_tool/Shared%20Documents/Forms/AllItems.aspx?RootFolder=%2Fpersonal%2Fho%2Dpi%5Flin%2FDB%5Freview%5Ftool%2FShared%20Documents%2FSupporting%5FDoc%2FManual", target = "_blank")),
                                                    p(a("Validation Report",href="http://my.fda.gov/personal/ho-pi_lin/DB_review_tool/Shared%20Documents/Forms/AllItems.aspx?RootFolder=%2Fpersonal%2Fho%2Dpi%5Flin%2FDB%5Freview%5Ftool%2FShared%20Documents%2FSupporting%5FDoc%2FValidation%5FReport", target = "_blank")),
                                                    p(a("IVRT Tool",href="http://my.fda.gov/personal/ho-pi_lin/DB_review_tool/Shared%20Documents/Forms/AllItems.aspx?RootFolder=%2Fpersonal%2Fho-pi_lin%2FDB_review_tool%2FShared%20Documents%2FSupporting_Doc%2FIVRT%2FIVRT", target = "_blank")),
                                                    p(a("Database and other resources",href="http://my.fda.gov/personal/ho-pi_lin/DB_review_tool/Shared%20Documents/Forms/AllItems.aspx?RootFolder=%2Fpersonal%2Fho%2Dpi%5Flin%2FDB%5Freview%5Ftool%2FShared%20Documents%2FSupporting%5FDoc%2FLinks%5Fto%5Fresources&FolderCTID=0x01200001AD5E468E09DF45BDD3C90E818FF186&View={8B33DA18-D2AE-47A1-BC39-903A6B9B2A03}", target = "_blank")),
                                                    br(),
                                                    helpText(h3("Contact us:")),
                                                    helpText(h4("For error report, please contact:")),
                                                    helpText(h5("Heng Xu  (Heng.Xu@fda.hhs.gov)")),
                                                    helpText(h5("Ho-Pi Lin (Ho-Pi.Lin@fda.hhs.gov)")),
                                                    helpText(h5("Jie Xue (Jie.Xue@fda.hhs.gov)")),
                                                    br(),
                                                    helpText(h4("For assistance concerning tool usage or results interpretations, please contact super-users:")),
                                                    helpText(h5("Hansong Chen (Hansong.Chen@fda.hhs.gov)")),
                                                    helpText(h5("Joan Zhao (Joan.Zhao@fda.hhs.gov)")),
                                                    helpText(h5("Min Li (Min.Li@fda.hhs.gov)")),
                                                    helpText(h5("Poonam Delvadia (Poonam.Delvadia@fda.hhs.gov)")),
                                                    helpText(h5("Qi Zhang (Qi.Zhang@fda.hhs.gov)")),
                                                    br(),
                                                    helpText(h4("For feature suggestions, please contact Point of Contact(s) for each branch:")),
                                                    helpText(h5("Joan Zhao (I) (Joan.Zhao@fda.hhs.gov)")),
                                                    helpText(h5("Hansong Chen (II)  (Hansong.Chen@fda.hhs.gov)")),
                                                    helpText(h5("Kimberly Raines (III) (Kimberly.Raines@fda.hhs.gov)")),
                                                    helpText
                                                    (h5("Ho-Pi Lin (III) (Ho-Pi.Lin@fda.hhs.gov)")),
                                                    br(),
                                                    br(),
                                                    helpText(h2("Acknowledgement")),
                                                    br(),
                                                    helpText(h4("The Division of Biopharmaceutics Automation Tool Working Group (BATWG) meets monthly to facilitate the development of a web-based tool to simplify and standardize components of the Biopharmaceutics Review.")),
                                                    br(),
                                                    helpText(h4("Activities of the Working Group are segmented into the subgroups listed below (names are arranged alphabetically).  These subgroups may meet more frequently to complete their designated tasks.")),
                                                    br(),
                                                    helpText(h4("1. Manual writers")),
                                                    br(),
                                                    helpText(h4("Heng Xu, Jie Xue,  Min Li, and Parnali Chatterjee")),
                                                    br(),
                                                    helpText(h4("2. Validation report writers")),
                                                    br(),
                                                    helpText(h4("Hansong  Chen, Heng  Xu, and Mei Ou")),
                                                    br(),
                                                    helpText(h4("3. Beta-Testers")),
                                                    br(),
                                                    helpText(h4("Joan Zhao, Gerlie Gieser, Poonam Delvadia (beta testing lead), and Qi Zhang")),
                                                    br(),
                                                    helpText(h4("4. Editors")),
                                                    br(),
                                                    helpText(h4("Okpo Eradiri, and Ta-Chen Wu")),
                                                    br(),
                                                    helpText(h4("5. Developers")),
                                                    br(),
                                                    helpText(h4("Heng  Xu, Ho-Pi Lin (working group lead) and Jie Xue")),
                                                    br(),
                                                    helpText(h4("6. Senior leadership")),
                                                    br(),
                                                    helpText(h4("John Duan, Kimberly Raines, Paul Seo")),
                                                    br(),
                                                    br(),
                                                    helpText(h4("Summary of Workgroup Activities:")),
                                                    br(),
                                                    helpText(h5("The validation reports were done by colleagues who compared  between results from using DB review tool")), 
                                                    helpText(h5("and those from using alternative tools/methods. Beta testers meet frequently with developers and manual")),
                                                    helpText(h5("writers to provide instant feedbacks regarding errors and accuracy and to suggest additional features")),
                                                    helpText(h5("that are useful for DB reviewers. The maturation of the tool cannot be done without beta testers.")),
                                                    helpText(h5("The developer subgroup maintains the computer codes for the tool and works with all sub groups closely.")), 
                                                    helpText(h5("The working group thanks the leadership team for their guidance. Without their visions and supports,")), 
                                                    helpText(h5("this project would not be as successful. The working group also thanks Meng Wang, Om Anand,")),
                                                    helpText(h5("and Tien Mien Chen for their helpful comments and/or contributions to the development of this tool.")),
                                                    br(),
                                                    br(),
                                                    helpText(h4("Special Recognition: ")),
                                                    br(),
                                                    helpText(h4("1. The Working Group also thanks Meng Wang, Om Anand, and Tien Mien Chen for their helpful comments and contributions to the development of this tool.")),
                                                    br(),
                                                    helpText(h4("2. The source codes for bootstrapping analysis and MVA are modified from those originally written by John Duan and those published on the website ")),
                                                    p(a("http://forum.bebac.at/mix_entry.php?id=12382#p1687",href="http://forum.bebac.at/mix_entry.php?id=12382#p16874", target = "_blank"))
                                                                       
                                                    
                                                    
                                                    
                                                    ))
                   
)))