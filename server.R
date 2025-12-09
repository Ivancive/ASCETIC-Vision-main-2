
server <- function(input, output, session) {

  # -------------------------
  # Reactive global containers
  # -------------------------
  reshaped_data            <- reactiveVal(NULL)
  reshaped_data2           <- reactiveVal(NULL)
  reshaped_dataSurv        <- reactiveVal(NULL)
  genotype_table           <- reactiveVal(NULL)
  genotype_table_surv      <- reactiveVal(NULL)
  evo_step                 <- reactiveVal(NULL)
  surv_data                <- reactiveVal(NULL)

  case                     <- reactiveVal(NULL)
  case_surv                <- reactiveVal(NULL)
  resampling_res           <- reactiveVal(NULL)
  conf_res                 <- reactiveVal(NULL)
  resExampleEvosigs        <- reactiveVal(NULL)
  orig_genotype            <- reactiveVal(NULL)
  orig_genotypeSurv        <- reactiveVal(NULL)
  orig_dataSurv            <- reactiveVal(NULL)
  visualizeInferenceOutput <- reactiveVal(FALSE)
  visualizeConfidenceOutput<- reactiveVal(FALSE)
  visualize_output_surv    <- reactiveVal(FALSE)

  # ============================
  # LOAD UTILITY FUNCTIONS
  # ============================
  source("server/load_modules.R")

  # ============================
  # 1. INPUT DATA MODULE
  # ============================
  module_input_data_server(
    input, output, session,
    reshaped_data   = reshaped_data,
    reshaped_data2  = reshaped_data2,
    case            = case,
    orig_genotype   = orig_genotype
  )

  # ============================
  # 2. RESAMPLING MODULE
  # ============================
  module_resampling_server(
    input, output, session,
    reshaped_data2 = reshaped_data2
  )

  # ============================
  # 3. INFERENCE MODULE
  # ============================
  module_inference_server(
    input, output, session,
    reshaped_data        = reshaped_data,
    reshaped_data2       = reshaped_data2,
    genotype_table       = genotype_table,
    resampling_res       = resampling_res,
    visualizeInferenceOutput = visualizeInferenceOutput,
    case                 = case
  )

  # ============================
  # 4. CONFIDENCE MODULE
  # ============================
  module_confidence_server(
    input, output, session,
    resampling_res            = resampling_res,
    conf_res                  = conf_res,
    visualizeConfidenceOutput = visualizeConfidenceOutput
  )

  # ============================
  # 5. SURVIVAL MODULE
  # ============================
  module_survival_server(
    input, output, session,
    case_surv             = case_surv,
    reshaped_dataSurv     = reshaped_dataSurv,
    orig_genotypeSurv     = orig_genotypeSurv,
    surv_data             = surv_data,
    evo_step              = evo_step,
    genotype_table_surv   = genotype_table_surv,
    visualize_output_surv = visualize_output_surv
  )

  # ============================
  # 6. SAVE PROJECT MODULE
  # ============================
  module_save_project_server(
    input, output, session,
    reshaped_data      = reshaped_data,
    reshaped_data2     = reshaped_data2,
    reshaped_dataSurv  = reshaped_dataSurv,
    surv_data          = surv_data,
    evo_step           = evo_step,
    resampling_res     = resampling_res,
    conf_res           = conf_res,
    case               = case,
    case_surv          = case_surv,
    orig_genotypeSurv  = orig_genotypeSurv,
    resExampleEvosigs  = resExampleEvosigs
  )

}
