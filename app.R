source("libraries.R")

# Import all modules
source("server/utils.R")
source("server/module_input_data.R")
source("server/module_resampling.R")
source("server/module_inference.R")
source("server/module_confidence.R")
source("server/module_survival_input.R")
source("server/module_survival_steps.R")
source("server/module_survival_output.R")
source("server/module_save_project.R")

server <- function(input, output, session) {

  # -----------------------------
  # REACTIVE VALUES (GLOBAL STATE)
  # -----------------------------
  reshaped_data        <- reactiveVal(NULL)
  reshaped_data2       <- reactiveVal(NULL)
  reshaped_data_matrix <- reactiveVal(NULL)

  genotype_table       <- reactiveVal(NULL)
  genotype_table_surv  <- reactiveVal(NULL)

  resampling_res       <- reactiveVal(NULL)
  conf_res             <- reactiveVal(NULL)

  surv_data            <- reactiveVal(NULL)
  reshaped_dataSurv    <- reactiveVal(NULL)
  orig_genotypeSurv    <- reactiveVal(NULL)
  orig_dataSurv        <- reactiveVal(NULL)
  evo_step             <- reactiveVal(NULL)

  resExampleEvosigs    <- reactiveVal(NULL)

  # type detection for both inference and survival
  case                 <- reactiveVal(NULL)
  case_surv            <- reactiveVal(NULL)

  selected_folder      <- reactiveVal(NULL)

  visualizeInferenceOutput <- reactiveVal(FALSE)
  visualizeConfidenceOutput <- reactiveVal(FALSE)
  visualize_del <- reactiveVal(FALSE)

  # --------------------------------------------
  # ATTACH MODULES AND PASS REACTIVES TO THEM
  # --------------------------------------------

  # 1. Input Genotype + Resampling
  module_input_data_server(input, output, session,
                           reshaped_data, reshaped_data_matrix,
                           reshaped_data2, genotype_table,
                           case, selected_folder)

  # 2. Resampling file (bulk single)
  module_resampling_server(input, output, session,
                           reshaped_data2)

  # 3. Inference
  module_inference_server(input, output, session,
                          reshaped_data, reshaped_data_matrix,
                          genotype_table, reshaped_data2,
                          case, selected_folder,
                          resampling_res, visualizeInferenceOutput)

  # 4. Confidence estimation
  module_confidence_server(input, output, session,
                           reshaped_data2, resampling_res,
                           conf_res, case, visualizeConfidenceOutput)

  # 5. Survival — genotype load
  module_survival_input_server(input, output, session,
                               reshaped_dataSurv, orig_genotypeSurv,
                               genotype_table_surv,
                               case_surv)

  # 6. Survival — compute evolutionary steps
  module_survival_steps_server(input, output, session,
                               case, case_surv,
                               reshaped_data_matrix,
                               reshaped_dataSurv,
                               orig_genotypeSurv,
                               evo_step, surv_data,
                               genotype_table, genotype_table_surv)

  # 7. Survival — evoSigs
  module_survival_output_server(input, output, session,
                                surv_data, evo_step,
                                resExampleEvosigs)

  # 8. Save project
  module_save_project_server(input, output, session,
                             case, case_surv,
                             reshaped_data, reshaped_data2,
                             reshaped_dataSurv, orig_genotypeSurv,
                             reshaped_data_matrix, surv_data,
                             resampling_res, conf_res,
                             evo_step, resExampleEvosigs,
                             selected_folder)

}


