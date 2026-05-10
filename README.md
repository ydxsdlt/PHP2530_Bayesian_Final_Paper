# PHP2530 Final Paper Repository

This repository contains the paper, code, and output files for my PHP2530 final project, titled:

**A Bayesian Joint Model for Multi-Reader Ordinal Semantic Ratings with Missing Data for Malignancy Prediction**

## Repository contents

### Paper files

- **sample.tex**  
  Main LaTeX source file for the paper.

- **sample.bib**  
  Bibliography file used by the paper.

- **style.sty**  
  Formatting/style file provided for the course paper template.

### Simulation code

- **generate_csvs_run.Rmd**  
  Main R Markdown file used to run the simulation study.  
  This file runs the full simulation and saves the final summary outputs to CSV files.

- **study_model_csv.stan**  
  Stan model file called by `generate_csvs_run.Rmd`.  
  It contains the Bayesian joint model used in the simulation study.

### Simulation outputs

- **simulation_raw_results.csv**  
  Main simulation results file.  
  Contains the performance summaries for each setting, replicate, and method, including metrics such as AUC, Brier score, latent-feature recovery, and correlation-structure recovery.

- **simulation_diagnostics.csv**  
  Convergence and sampling diagnostics from the Stan runs, including summaries based on key global parameters.

### Review / checking files

- **review_results_from_csv.Rmd**  
  R Markdown file used to read the two CSV result files and generate the summary tables and figures used to inspect the final simulation results.

- **review_results_from_csv.pdf**  
  Rendered output from `review_results_from_csv.Rmd`.  
  This file is mainly for checking the final simulation summaries and diagnostics in a convenient report format.

## Reproducibility notes

- The main simulation is run through `generate_csvs_run.Rmd`.
- That file calls the Stan model in `study_model_csv.stan`.
- The final results used in the paper are summarized in:
  - `simulation_raw_results.csv`
  - `simulation_diagnostics.csv`
- The checking/report file `review_results_from_csv.Rmd` reads those CSV files and produces summary tables and plots.

## Notes

- The review files are included for transparency and convenience, but the main analysis depends primarily on:
  - `generate_csvs_run.Rmd`
  - `study_model_csv.stan`
  - `simulation_raw_results.csv`
  - `simulation_diagnostics.csv`

- The paper itself is compiled from:
  - `sample.tex`
  - `sample.bib`
  - `style.sty`
