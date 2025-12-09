source("libraries.R")

ui <- dashboardPage(

  ###########################################################################
  # HEADER
  ###########################################################################
  dashboardHeader(
    title = HTML("ASCETIC-<i>Vision</i>"),
    tags$li(class = "dropdown",
            style = "display: flex; justify-content: center;
                     align-items: center; color: #222D32; font-size: 15px;
                     font-weight: bold; padding: 15px 10px 0 0;",
            uiOutput("project_info")
    ),
    tags$li(class = "dropdown",
            conditionalPanel(
              condition = "input.sidebarMenu != 'home'",
              actionButton("resetBtn", "Reset", class = "custom-button",
                           style = "margin-right: 20px;")
            ),
            style = "display: flex; align-items: center; margin-left: 20px; margin-top: 10px;"
    )
  ),

  ###########################################################################
  # SIDEBAR
  ###########################################################################
  dashboardSidebar(
    tags$head(
      tags$style(HTML("
        .fa-i, .fa-s {
          transition: color 0.3s ease-in-out;
        }
        .sidebar-menu li.active .fa-i,
        .sidebar-menu li.active .fa-s {
          color: #222D32 !important;
        }
        .fa-i {
          color: #A8FA7F !important;
        }
        .fa-s {
          color: white !important;
        }
        table.dataTable thead th {
          text-align: right !important;
        }
      "))
    ),

    sidebarMenu(
      id = "sidebarMenu",

      menuItem("Home page", tabName = "home", icon = icon("home")),

      menuItem(
        HTML("Input data - Genomic <span style='float: right; transform: scale(0.6);'><i class='fa fa-i'></i></span>"),
        tabName = "input",
        icon = icon("database")
      ),

      menuItem(
        HTML("Evolution model <br>inference<span style='float: right; transform: scale(0.6);'><i class='fa fa-i'></i></span>"),
        tabName = "inference",
        icon = icon("chart-line")
      ),

      menuItem(
        HTML("Confidence estimation<span style='float: right; transform: scale(0.55);'><i class='fa fa-i'></i></span>"),
        tabName = "confidence_estimation",
        icon = icon("think-peaks")
      ),

      menuItem(
        HTML("Input data - Survival<span style='float: right; transform: scale(0.55);'><i class='fa fa-s'></i></span>"),
        tabName = "input_surv",
        icon = icon("database")
      ),

      menuItem(
        HTML("Evolutionary signatures <span style='float: right; transform: scale(0.55);'><i class='fa fa-s'></i></span>"),
        tabName = "output_surv",
        icon = icon("chart-line")
      ),

      menuItem("Save project", tabName = "save", icon = icon("save"))
    )
  ),

  ###########################################################################
  # BODY
  ###########################################################################
  dashboardBody(
    tags$head(tags$link(rel = "stylesheet",
                        href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css")),
    includeCSS("./style.css"),

    tabItems(

      #######################################################################
      # HOME TAB
      #######################################################################
      tabItem(
        tabName = "home",
        fluidPage(
          class = "custom-fluid-homePage",
          fluidRow(
            titlePanel("Project list"),
            tags$br(), tags$br(),
            DTOutput("projectList")
          ),
          fluidRow(
            class = "custom-fluid-homeRow",
            column(3,
                   actionButton("loadProjBtn", "Load existing project",
                                class = "custom-button")
            ),
            column(3, offset = 1,
                   actionButton("create_project_button", "Create New Project",
                                class = "custom-button")
            )
          )
        )
      ),

      #######################################################################
      # INPUT DATA - GENOMIC
      #######################################################################
      tabItem(
        tabName = "input",
        fluidPage(
          class = "custom-fluid-inputPage",

          fluidRow(
            column(6,
                   selectInput("data_type",
                               "Select the type of data you want to load",
                               choices = c("Select data type",
                                           "Bulk single",
                                           "Bulk multiple",
                                           "Single cell"),
                               selected = "Select data type"),
                   uiOutput("dataFile")
            ),

            column(6,
                   div(style = "margin-top: 70px;",
                       uiOutput("dataFile2"),
                       div(style = "margin-top: -10px;",
                           uiOutput("loadBtn2")),
                       fluidRow(
                         column(width = 12, style = "margin-top: 2px; margin-bottom: 30px;",
                                uiOutput("directoryInput"))
                       )
                   )
            )
          ),

          conditionalPanel(
            condition = "input.data_type === 'Select data type'",
            wellPanel(
              tags$div(
                tags$h4("Select a data type and upload a tab-delimited text file."),
                tags$p("Below are the details for each data type:"),
                tags$strong("Bulk single:"), tags$ul(tags$li("SAMPLE"), tags$li("GENE"), tags$li("CCF")),
                tags$strong("Bulk multiple:"), tags$ul(tags$li("SAMPLE"), tags$li("REGION"), tags$li("GENE"), tags$li("CCF")),
                tags$strong("Single cell:"), tags$ul(tags$li("PATIENT"), tags$li("CELL"), tags$li("GENE"), tags$li("CCF / VALUE"))
              )
            )
          ),

          conditionalPanel(
            condition = "input.data_type === 'Bulk single' && output.dataTable2 == null",
            wellPanel(
              tags$div(
                tags$h4("Additional file requirements for resampling:"),
                tags$ul(
                  tags$li("SAMPLE"),
                  tags$li("GENE"),
                  tags$li("REF_COUNT"),
                  tags$li("ALT_COUNT"),
                  tags$li("COPY_NUMBER"),
                  tags$li("NORMAL_PLOIDY"),
                  tags$li("CCF_ESTIMATE")
                )
              )
            )
          ),

          conditionalPanel(
            condition = "output.DeleteColumn != null",
            h3("Sample and Features Selection", style = "margin-top: 20px;")
          ),

          fluidRow(
            column(6, uiOutput("DeleteColumn")),
            column(6, uiOutput("binarization"))
          ),
          fluidRow(
            column(6, uiOutput("DeleteRow")),
            column(6, uiOutput("binarization_perc"))
          ),

          fluidRow(
            column(12,
                   div(style = "display: flex; justify-content: flex-end;
                                margin-top: 20px; margin-bottom: 20px; margin-right: -20px;",
                       actionButton("inferenceBtn", "Evolution model inference",
                                    class = "custom-button2")
                   ),
                   DTOutput("dataTable")
            )
          ),

          uiOutput("content"),
          uiOutput("heatmapPlot"),

          conditionalPanel(
            condition = "output.dataTable2 != null",
            tags$div("Resampling", style = "font-weight: bold; margin-top: 85px;
                     margin-left: 0px; font-size: 17px; margin-bottom: 20px;")
          ),

          DTOutput("dataTable2")
        )
      ),

      #######################################################################
      # INFERENCE TAB
      #######################################################################
      tabItem(
        tabName = "inference",
        fluidPage(
          style = "margin-left: 10px; margin-right: 10px;",

          h3(HTML("ASCETIC <i>plus</i> hyperparameters"), style = "margin-top: 20px;"),

          fluidRow(
            column(6,
                   selectInput("regularization", "Regularization",
                               c("aic","bic","loglik","ebic",
                                 "bde","bds","mbde","bdla",
                                 "k2","fnml","qnml","nal","pnal"),
                               multiple = TRUE, selected = "aic"),
                   selectInput("command", "Search algorithm", c("hc","tabu")),
                   numericInput("restarts", "Likelihood fit restarts", 10, min = 1)
            ),
            column(6,
                   numericInput("seed", "Seed", 12345, min = 0),
                   checkboxInput("resamplingFlag", HTML("<strong>Resampling</strong>")),
                   uiOutput("nresampling")
            )
          ),

          actionButton("submitBtn", "Run", class = "custom-button"),

          div(style = "display: flex; justify-content: flex-end;",
              actionButton("confidenceBtn", "Confidence estimation",
                           class = "custom-button2")
          ),

          fluidRow(
            column(6,
                   uiOutput("visualize_inference"),
                   sliderInput("fontSize", "Font size", min = 5, max = 40, value = 12),
                   uiOutput("gene_graph_tab")
            ),
            column(6,
                   downloadButton("downloadCSV", "Download inferred matrix",
                                  class = "custom-width1"),
                   sliderInput("nodeSize", "Node size", min = 5, max = 30, value = 8)
            )
          ),

          visNetworkOutput("graph_inference", width = "80%", height = "500px"),

          DTOutput("selected_result_output")
        )
      ),

      #######################################################################
      # CONFIDENCE TAB
      #######################################################################
      tabItem(
        tabName = "confidence_estimation",
        fluidPage(
          style = "margin-left: 10px; margin-right: 10px;",

          fluidRow(
            column(6,
                   checkboxInput("resamplingFlag_conf",
                                 HTML("<strong>Resampling</strong>")),
                   uiOutput("nresampling_conf")
            ),
            column(6,
                   numericInput("iteration_confEstimation",
                                "Confidence estimate repetitions",
                                value = 10, min = 3)
            )
          ),

          actionButton("submitBtn_confEstimation", "Run", class = "custom-button"),

          div(style = "display: flex; justify-content: flex-end;",
              actionButton("survBtn", "Input data survival", class = "custom-button2")
          ),

          fluidRow(
            column(6,
                   uiOutput("visualize_conf"),
                   sliderInput("fontSize_conf", "Font size", min = 5, max = 40, value = 12),
                   uiOutput("gene_graph_tab_conf")
            ),
            column(6,
                   downloadButton("downloadCSV_conf",
                                  class = "custom-width1"),
                   sliderInput("nodeSize_conf", "Node size", min = 5, max = 30, value = 8)
            )
          ),

          visNetworkOutput("graph_conf", width = "80%", height = "500px"),

          DTOutput("selected_result_output_conf")
        )
      ),

      #######################################################################
      # INPUT SURVIVAL
      #######################################################################
      tabItem(
        tabName = "input_surv",
        fluidPage(
          class = "custom-fluid-inputPage",

          fluidRow(
            column(6,
                   selectInput("regularization_surv", "Select an evolution model", choices = NULL),
                   uiOutput("dataFile2_surv"),
                   tags$br(),
                   wellPanel(
                     tags$div(
                       tags$h4("Upload a survival dataset (.txt)"),
                       tags$ul(
                         tags$li("SAMPLE"),
                         tags$li("STATUS"),
                         tags$li("TIMES")
                       )
                     )
                   )
            ),

            column(6,
                   checkboxInput("load_file",
                                 HTML("<strong>Use the same model with a different dataset</strong>")),
                   uiOutput("data_type_surv"),
                   uiOutput("dataFile_surv")
            )
          ),

          actionButton("submit_surv", "Show evolutionary step occurrence matrix",
                       class = "custom-button"),

          actionButton("out_survBtn", "Evolutionary signatures",
                       class = "custom-button2"),

          fluidRow(
            column(6, uiOutput("DeleteColumn_surv")),
            column(6, uiOutput("binarization_surv"))
          ),

          fluidRow(
            column(6, uiOutput("DeleteRow_surv")),
            column(6, uiOutput("binarization_percSurv"))
          ),

          DTOutput("dataTable_GenotypeSurv"),
          uiOutput("heatmap_GenotypeSurv"),

          fluidRow(
            column(6, uiOutput("DeleteColumn_surv2")),
            column(6, uiOutput("binarization_surv2"))
          ),

          uiOutput("DeleteRow_surv2"),
          DTOutput("dataTable_surv"),
          uiOutput("heatmap_surv")
        )
      ),

      #######################################################################
      # OUTPUT SURVIVAL
      #######################################################################
      tabItem(
        tabName = "output_surv",
        fluidPage(
          actionButton("calc_surv", "Run Regularized Cox Regression",
                       class = "custom-button"),

          girafeOutput("combined_graph", width = "100%", height = "700px"),
          plotlyOutput("survPlot", width = "100%", height = "400px"),
          plotlyOutput("survPlot2", width = "100%", height = "200px"),
          plotlyOutput("survPlot3", width = "100%", height = "200px")
        )
      ),

      #######################################################################
      # SAVE PROJECT
      #######################################################################
      tabItem(
        tabName = "save",
        fluidPage(
          textInput("project_name", "Project name", ""),
          actionButton("saveBtn", "Save", class = "custom-button")
        )
      )

    ) # end tabItems
  )   # end dashboardBody

)     # end dashboardPage

