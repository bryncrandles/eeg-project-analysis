function results = SWP_results(coh_array, num_cond, cond_names, freq, avg_deg, save_name)

% DESCRIPTION

% SWP_results computes the adjacency matrix of coherence data for the
% conditions and frequency band of interest using the function coh_matrix, followed by the small 
% world propensity of this adjacency matrix using the function small_world_propensity from the SWP
% toolbox written by Eric Bridgeford (Reference: Muldoon, Bridgeford, and 
% Bassett (2015) "Small-World Propensity in Weighted, 
% Real-World Networks" http://arxiv.org/abs/1505.02194).

% Inputs

% coh_array is a (# number of data files x 2) cell array, where the first 
% column is the name of the data file and the second
% column is a (# of conditions x 3) cell array. Within this, the first
% column is the name of condition, second is the coherence (num channels x 
% num channels x sampling rate) matrix , and the third
% is the power spectral density [PSD not used in this code]. 

% num_cond (int) - 1 to 13 (max # of conditions produced by
% function ext_all_cond) specifying the conditions for which to compute
% SWP. (Recall order of conditions: resting, music, faces, eopen, eclosed,
% hapm, joym, sadm, fearm, hapy, fear, neut, angy).

% cond_names (string): names of conditions used in analysis, in order
% corresponding to cell array of coherence data

% freq (vector) - specifies frequency band of interest. (Used in this analysis: Delta 2:4, Theta 5:8, Alpha
% 9:13, Low alpha 9:11, High alpha 11:13, Beta 14:31).

% avg_deg (int) - the desired average degree of the graph resulting
% from the adjacency matrix.

% save_name (char) - desired name to save the results.

% Outputs

% results is a 1 x 1 structure with 5 fields - SWP, net clustering, net path length,
% average degree, and threshold. Each field contains a (number of files
% x 4 [name of file and 3 conditions]) cell array of results. 

% FUNCTION 

coh_psd = coh_array;

% initialize cell array for SWP and avg degree 
SWP = cell(length(coh_psd)+ 1 , num_cond + 1);
avgdeg = cell(length(coh_psd)+ 1 , num_cond + 1);
clust = cell(length(coh_psd) + 1, num_cond + 1);
path = cell(length(coh_psd) + 1, num_cond + 1);
threshold = cell(length(coh_psd) + 1 , num_cond + 1);

% input names of conditions
for i = 1:length(cond_names)
    SWP{1, i + 1} = cond_names(i);
    avgdeg{1, i + 1} = cond_names(i);
    clust{1, i + 1} = cond_names(i);
    path{1, i + 1} = cond_names(i);
    threshold{1, i + 1} = cond_names(i);
end

% input names of files 
SWP(2:size(SWP, 1), 1) = coh_psd(:, 1);
avgdeg(2:size(SWP, 1), 1) = coh_psd(:, 1);
clust(2:size(SWP, 1), 1) = coh_psd(:, 1);
path(2:size(SWP, 1), 1) = coh_psd(:, 1);
threshold(2:size(SWP, 1), 1) = coh_psd(:, 1);

% loop to calculate avg deg and SWP for each condition in each file 
for i = 1:length(coh_psd)
    file_data = coh_psd{i, 2};
    for j = 1:num_cond
        [A, threshold_value] = coh_matrix(file_data{j, 2}, freq, avg_deg);
        avgdeg{i + 1, j + 1} = avg_deg;
        threshold{i + 1, j + 1} = threshold_value;
        [swp, net_clust, net_path] = small_world_propensity(A, 'bin');
        SWP{i + 1, j + 1} = swp;
        clust{i + 1, j + 1} = net_clust;
        path{i + 1, j + 1} = net_path;
    end
end

% form a structure of all of the cell arrays
SWP = {SWP};
clust = {clust};
path = {path};
avgdeg = {avgdeg};
threshold = {threshold};

results = struct('SWP', SWP, 'Clustering', clust, 'Path_Length', path, 'Average_Degree', avgdeg, 'Threshold', threshold);

% save the structure 
save_name = [save_name '_' date '.mat'];
save(save_name, 'results', '-v7.3');

end