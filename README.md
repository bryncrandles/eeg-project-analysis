# eeg-project-analysis

## Coherence Calculations
The necessary files to calculate the coherence of each EEG data file are under the folder coherence_scripts. Under the functions folder, PSD calculates the power spectral density of each channel, coh calculates the coherence of each pair of channels in the EEG data file. Also under the functions folder is ext_all_cond, which separates the data into the different conditions: resting, music, emotional faces, and further into eyes open, eyes closed, happy music, sad music, fearful music, happy face, neutral face, fearful face, and angry face. 

Under the folders controls and patients are matlab scripts to compute and save coherence and power spectral density of the control and patient data sets. There are separate matlab scripts to compute different chunks of these data files for faster analysis on Compute Canada. 


