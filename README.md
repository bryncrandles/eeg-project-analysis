# eeg-project-analysis

## Step 1: Coherence Calculations
* Necessary files to compute coherence under "coherence" folder. 
* Functions: 
- ext_all_cond: separates the data into the different conditions and saves as a cell array: resting, music, emotional faces, and further into eyes open, eyes closed, happy music, sad music, fearful music, happy face, neutral face, fearful face, and angry face.
- PSD.m: calculates the power spectral density of each channel. 
- coh.m: calculates the coherence of each pair of channels in EEG data file, 

* Under folders "controls" and "patients" are matlab scripts to compute and save coherence and power spectral density of the control and patient data sets for the first three conditions from ext_all_cond. For both PSD & coh: 3D matrices from each condition are saved in a cell array.
* Separate matlab scripts are to compute different chunks of these data files for faster analysis on Compute Canada, each with the same format: for each data file in the list, extract all of the conditions using ext_all_cond, and for each of these conditions, calculate the power spectral density and coherence and save all of the results in a cell array.
* Matlab script also included to concatenate cell arrays of control and patient results.

## Step 2: Small World Propensity Analysis
### Group Differences
* Input concatenated cell arrays from part 1 into function SWP_results.
- Function SWP_results calculates small world propensity (and its components clustering and path length) for a specificy frequency band and desired average degree. Uses coh_matrix function and small_world_propensity function from the SWP toolbox written by Eric Bridgeford (Reference: Muldoon, Bridgeford, and Bassett (2015) "Small-World Propensity in Weighted, Real-World Networks" http://arxiv.org/abs/1505.02194) (requires Bioinformatics toolbox).
* Spatial (individual node) results: use function node_clust_path to return the clustering matrix from SWP toolbox (clustering_coef_matrix function) and the average path length vector from the graphallshortestpaths function (Bioinformatics toolbox) for each participant.
* Use anova.R for mixed anova with repeated measures; anova_permtest.R to confirm results






