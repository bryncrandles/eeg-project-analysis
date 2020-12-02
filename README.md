# eeg-project-analysis

## Coherence Calculations
Necessary files to compute coherence under "coherence" folder. 
Functions: PSD.m calculates the power spectral density of each channel, coh.m calculates the coherence of each pair of channels in the EEG data file, ext_all_cond, which separates the data into the different conditions: resting, music, emotional faces, and further into eyes open, eyes closed, happy music, sad music, fearful music, happy face, neutral face, fearful face, and angry face, and saves the separated data in a cell array. 

Under folders "controls" and "patients" are matlab scripts to compute and save coherence and power spectral density of the control and patient data sets.
Separate matlab scripts are to compute different chunks of these data files for faster analysis on Compute Canada, each with the same format: for each data file in the list, extract all of the conditions using ext_all_cond, and for each of these conditions, calculate the power spectral density and coherence and save all of the results in a cell array).

## Small World Propensity Analysis
### Patients: Resting vs Music vs Faces




