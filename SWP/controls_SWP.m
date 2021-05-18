% calculate SWP for each frequency band for controls

% add path to all necessary functions 
addpath(genpath('/home/bc11xx/projects/def-wjmarsha/bc11xx'))
addpath('/home/bc11xx/projects/def-wjmarsha/bc11xx/SWP')
addpath('/home/bc11xx/projects/def-wjmarsha/bc11xx/SWPresults')
addpath('/home/bc11xx/projects/def-wjmarsha/bc11xx/coherence_results/controls_sept_11_2020')

% load data
load('controls_coh_psd.mat', 'controls_coh_psd')

% set variables
num_cond = 3;
cond_names = ["resting" "music" "faces"];
avg_deg = 10;
delta = 2:4;
theta = 5:8;
alpha = 9:13;
low_alpha = 9:11;
high_alpha = 11:13;
beta = 14:31;

% calculate SWP for each frequency band (functions automatically save
% structures)
SWP_results(controls_coh_psd, num_cond, cond_names, delta, avg_deg, 'Controls_Delta_SWP');
SWP_results(controls_coh_psd, num_cond, cond_names, theta, avg_deg, 'Controls_Theta_SWP');
SWP_results(controls_coh_psd, num_cond, cond_names, alpha, avg_deg, 'Controls_Alpha_SWP');
SWP_results(controls_coh_psd, num_cond, cond_names, low_alpha, avg_deg, 'Controls_Low_Alpha_SWP');
SWP_results(controls_coh_psd, num_cond, cond_names, high_alpha, avg_deg, 'Controls_High_Alpha_SWP');
SWP_results(controls_coh_psd, num_cond, cond_names, beta, avg_deg, 'Controls_Beta_SWP');

exit
