function Node_Results = node_clust_path(coh_psd, num_cond, cond_names, freq, avg_deg, save_name)

% DESCRIPTION %
% inputs a cell array of coherence data for a number of eeg files, and
% outputs a structure that contains the clustering coefficient matrix and
% a vector of the characteristic path lengths for each node, for each eeg
% file (which are used in computing the small world propensity).

% Uses the clust_coef_matrix function from the small world propensity
% toolbox written by Eric Bridgeford (Reference: Muldoon, Bridgeford, and 
% Bassett (2015) "Small-World Propensity in Weighted, 
% Real-World Networks" http://arxiv.org/abs/1505.02194)
% Also uses the graphallshortestpaths function which is from the
% bioinformatics toolbox.

% Inputs:

%   coh_psd (cell): a (# number of data files x 2) cell array, where the first 
%   column is the name of the data file and the second
%   column is a (# of conditions x 3) cell array. Within this, the first
%   column is the name of condition, second is the coherence (num channels x 
%   num channels x sampling rate) matrix , and the third
%   is the power spectral density [PSD not used in this code]. 

%   num_cond (int): number of tasks 

%   cond_names (string array): array containing names of 

%   freq (vector): is a vector specifying frequency band. (Used in this analysis: Delta 1:3, Theta 4:7, Alpha
%   8:12, Low alpha 8:10, High alpha 10:12, Beta 13:30).

%   avg_deg(int): - the desired average degree of the graph resulting
%   from the adjacency matrix.

%   threshold_vector (vector):  vector of thresholds to test that will result in the
%   desired average degree.

% Outputs:
% Node_Results (struct): 1x1 structure containing the fields Threshold, Clust,
% and Path, each which are (# of eeg files) x 4 cell arrays ( 1
% column for file name, 3 columns for resting, music and faces conditions).

% FUNCTION 

% initialize cell arrays
Clust = cell(length(coh_psd) + 1 , num_cond + 1);
Path = cell(length(coh_psd) + 1, num_cond + 1);
Threshold = cell(length(coh_psd) + 1, num_cond + 1);

% name columns 
% names of conditions

% Clust{1, 2} = "resting";
% Clust{1, 3} = "music";
% Clust{1, 4} = "faces";
% Path{1, 2} = "resting";
% Path{1, 3} = "music";
% Path{1, 4} = "faces";
% Threshold{1, 2} = "resting";
% Threshold{1, 3} = "music";
% Threshold{1, 4} = "faces";

for i = 1:length(cond_names)
    Clust{1, i + 1} = cond_names(i);
    Path{1, i + 1} = cond_names(i);
    Threshold{1, i + 1} = cond_names(i);
end

% input file names 
Clust(2:size(Clust, 1), 1) = coh_psd(:, 1);
Path(2:size(Path, 1), 1) = coh_psd(:, 1);
Threshold(2:size(Threshold, 1), 1) = coh_psd(:, 1);

% loop to calculate individual node clustering coefficients and path
% lengths
for i = 1%:length(coh_psd)
    file_data = coh_psd{i, 2};
    for j = 1%:num_cond
        [A, threshold_value] = coh_matrix(file_data{j, 2}, freq, avg_deg);
        C = clustering_coef_matrix(A, 'bin');
        Clust{i + 1, j + 1} = C;
        L_i = node_path_lengths(A);
        Path{i + 1, j + 1} = L_i;
        Threshold{i + 1, j + 1} = threshold_value;
    end
end

Threshold = {Threshold};
Clust = {Clust};
Path = {Path};

Node_Results = struct('Threshold', Threshold, 'Clust', Clust, 'Path', Path);

% save the structure 
save_name = [save_name '_' date '.mat'];
save(save_name, 'Node_Results', '-v7.3');

end

