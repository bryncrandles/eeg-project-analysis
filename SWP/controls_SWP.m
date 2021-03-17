% calculate SWP for each frequency band for controls

% add path to all necessary functions 
addpath(genpath('/home/bc11xx/projects/def-wjmarsha/bc11xx'))
addpath('/home/bc11xx/projects/def-wjmarsha/bc11xx/SWP')
addpath('/home/bc11xx/projects/def-wjmarsha/bc11xx/SWPresults')
addpath('/home/bc11xx/projects/def-wjmarsha/bc11xx/coherence_results/controls_sept_11_2020')

% load data
load('controls_coh_psd.mat', 'controls_coh_psd')

% set variables
avg_deg = 10;
threshold = 0:0.01:18;
delta = 1:3;
theta = 4:7;
alpha = 8:12;
low_alpha = 8:10;
high_alpha = 10:12;
beta = 13:30;
num_cond = 3;

% calculate SWP for each frequency band (functions automatically save
% structures)
SWP_results(controls_coh_psd, num_cond, delta, avg_deg, threshold, 'Controls_Delta_SWP');
SWP_results(controls_coh_psd, num_cond, theta, avg_deg, threshold, 'Controls_Theta_SWP');
SWP_results(controls_coh_psd, num_cond, alpha, avg_deg, threshold, 'Controls_Alpha_SWP');
SWP_results(controls_coh_psd, num_cond, low_alpha, avg_deg, threshold, 'Controls_Low_Alpha_SWP');
SWP_results(controls_coh_psd, num_cond, high_alpha, avg_deg, threshold, 'Controls_High_Alpha_SWP');
SWP_results(controls_coh_psd, num_cond, beta, avg_deg, threshold, 'Controls_Beta_SWP');

exit
