% calculate SWP for each frequency band for patients

% add path to all necessary functions 
addpath(genpath('/home/bc11xx/projects/def-wjmarsha/bc11xx'))
addpath('/home/bc11xx/projects/def-wjmarsha/bc11xx/SWP')
addpath('/home/bc11xx/projects/def-wjmarsha/bc11xx/coherence_results/patients_august_5_2020')

% load data
load('coh_psd.mat', 'coh_psd')

% set variables
avg_deg = 10;
num_cond = 3;
cond_names = ["resting" "music" "faces"];
delta = 2:4;
theta = 5:8;
alpha = 9:13;
low_alpha = 9:11;
high_alpha = 11:13;
beta = 14:31;

% calculate SWP for each frequency band (functions automatically save
% structures)
SWP_results(coh_psd, num_cond, cond_names, delta, avg_deg, 'Patients_Delta_SWP');
SWP_results(coh_psd, num_cond, cond_names, theta, avg_deg, 'Patients_Theta_SWP');
SWP_results(coh_psd, num_cond, cond_names, alpha, avg_deg, 'Patients_Alpha_SWP');
SWP_results(coh_psd, num_cond, cond_names, low_alpha, avg_deg, 'Patients_Low_Alpha_SWP');
SWP_results(coh_psd, num_cond, cond_names, high_alpha, avg_deg, 'Patients_High_Alpha_SWP');
SWP_results(coh_psd, num_cond, cond_names, beta, avg_deg, 'Patients_Beta_SWP');

exit
