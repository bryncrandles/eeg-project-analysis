% concatenate coherence files into one cell array

% add path to coherence data
addpath('/home/bc11xx/projects/def-wjmarsha/bc11xx/coherence_results/controls_sept_11_2020')

% load files
load('controls_coh_psd_1.mat', 'coh_psd_ctrl_1') 
load('controls_coh_psd_2.mat', 'coh_psd_ctrl_2')
load('controls_coh_psd_3.mat', 'coh_psd_ctrl_3')
load('controls_coh_psd_4.mat', 'coh_psd_ctrl_4')
load('controls_coh_psd_5.mat', 'coh_psd_ctrl_5')
load('controls_coh_psd_6.mat', 'coh_psd_ctrl_6')
load('controls_coh_psd_7.mat', 'coh_psd_ctrl_7')
load('controls_coh_psd_8.mat', 'coh_psd_ctrl_8')

% combine into cell array 
controls_coh_psd = [coh_psd_ctrl_1; coh_psd_ctrl_2; coh_psd_ctrl_3; coh_psd_ctrl_4; coh_psd_ctrl_5; coh_psd_ctrl_6; coh_psd_ctrl_7; coh_psd_ctrl_8];

save('controls_coh_psd.mat', 'controls_coh_psd', '-v7.3');

exit
