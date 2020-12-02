% concatenate coherence files into one cell array

% add path to coherence data
addpath('/home/bc11xx/projects/def-wjmarsha/bc11xx/coherence_results/august_5_2020')

% load files
load('coh_psd_1.mat', 'coh_psd_1') 
load('coh_psd_2.mat', 'coh_psd_2')
load('coh_psd_3.mat', 'coh_psd_3')
load('coh_psd_4.mat', 'coh_psd_4')

% combine into cell array 
coh_psd = [coh_psd_1; coh_psd_2; coh_psd_3; coh_psd_4];

save('coh_psd.mat', 'coh_psd', '-v7.3');

exit
