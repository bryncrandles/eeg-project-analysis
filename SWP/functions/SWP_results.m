function SWP_results = SWP_results(coh_array, num_cond, freq, avg_deg, threshold, save_name)

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

% num_cond is an integer from 1 to 13 (max # of conditions produced by
% function ext_all_cond) specifying the conditions for which to compute
% SWP. (Recall order of conditions: resting, music, faces, eopen, eclosed,
% hapm, joym, sadm, fearm, hapy, fear, neut, angy).

% freq is a vector specifying frequency band. (Used in this analysis: Delta 1:3, Theta 4:7, Alpha
% 8:12, Low alpha 8:10, High alpha 10:12, Beta 13:30).

% avg_deg is an integer - the desired average degree of the graph resulting
% from the adjacency matrix.

% threshold is a vector of thresholds to test that will result in the
% desired average degree.

% save_name is a string vector of the desired name to save the results.

% Outputs

% Alpha is a 1 x 1 structure with 5 fields - SWP, clustering, path length,
% average degree, and threshold. Each field contains a (number of files
% x 4 [name of file and 3 conditions]) cell array of results. 

% FUNCTION 

coh_psd = coh_array;

% variables
T = threshold;

% initialize cell array for SWP and avg degree 
SWP = cell(length(coh_psd)+ 1 , 4);
avgdeg = cell(length(coh_psd)+ 1 , 4);
clust = cell(length(coh_psd) + 1, 4);
path = cell(length(coh_psd) + 1, 4);
threshold= cell(length(coh_psd) + 1 , 4);

% add names of conditions and names of files to arrays
SWP{1, 2} = "resting";
SWP{1, 3} = "music";
SWP{1, 4} = "faces";
avgdeg{1, 2} = "resting";
avgdeg{1, 3} = "music";
avgdeg{1, 4} = "faces";
clust{1, 2} = "resting";
clust{1, 3} = "music";
clust{1, 4} = "faces";
path{1, 2} = "resting";
path{1, 3} = "music";
path{1, 4} = "faces";
threshold{1, 2} = "resting";
threshold{1, 3} = "music";
threshold{1, 4} = "faces";
SWP(2:size(SWP, 1), 1) = coh_psd(:, 1);
avgdeg(2:size(SWP, 1), 1) = coh_psd(:, 1);
clust(2:size(SWP, 1), 1) = coh_psd(:, 1);
path(2:size(SWP, 1), 1) = coh_psd(:, 1);
threshold(2:size(SWP, 1), 1) = coh_psd(:, 1);

% loop to calculate avg deg and SWP for each condition in each file 
for i = 1:length(coh_psd)
    file_data = coh_psd{i, 2};
    for j = 1:num_cond
        for k = 1:length(T)
            A = coh_matrix(file_data{j, 2}, freq, T(k));
            avg_deg_coh = round(mean(degree(graph(A))));
            if avg_deg_coh == avg_deg
               threshold = T(k);
               break
            end
        end
            avgdeg{i + 1, j + 1} = avg_deg;
            threshold{i + 1, j + 1} = threshold;
            [SWP, net_clust, net_path] = small_world_propensity(A, 'bin');
            SWP{i + 1, j + 1} = SWP;
            clust{i + 1, j + 1} = net_clust;
            path{i + 1, j+ 1} = net_path;
    end
end

% form a structure of all of the cell arrays
SWP = {SWP};
clust = {clust};
path = {path};
avgdeg = {avgdeg};
threshold = {threshold};

SWP_results = struct('SWP', SWP, 'Clustering', clust, 'Path_Length', path, 'Average_Degree', avgdeg, 'Threshold', threshold);

% save the structure 
save_name = [save_name '.mat'];
save(save_name, 'SWP_results', '-v7.3');

end