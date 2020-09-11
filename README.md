# eeg-project-analysis

## Coherence Calculations
The necessary files to calculate the coherence of each EEG data file are under the folder coherence_scripts. Under the functions folder, PSD.m calculates the power spectral density of each channel, and coh.m calculates the coherence of each pair of channels in the EEG data file. Also under the functions folder is ext_all_cond, which separates the data into the different conditions: resting, music, emotional faces, and further into eyes open, eyes closed, happy music, sad music, fearful music, happy face, neutral face, fearful face, and angry face, and saves the separated data in a cell array. 

Under the folders controls and patients are matlab scripts to compute and save coherence and power spectral density of the control and patient data sets. There are separate matlab scripts to compute different chunks of these data files for faster analysis on Compute Canada. Each script has the same format: for each data file in the list, extract all of the conditions using ext_all_cond, and for each of these conditions, calculate the power spectral density and coherence and save all of the results in a cell array.

## Small World Propensity Analysis
### Patients: Resting vs Music vs Faces




