function Node_Results = node_clust_path(coh_psd, freq, avg_deg, threshold_vector, save_name)

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

% coh_psd is a (# number of data files x 2) cell array, where the first 
% column is the name of the data file and the second
% column is a (# of conditions x 3) cell array. Within this, the first
% column is the name of condition, second is the coherence (num channels x 
% num channels x sampling rate) matrix , and the third
% is the power spectral density [PSD not used in this code]. 

% freq is a vector specifying frequency band. (Used in this analysis: Delta 1:3, Theta 4:7, Alpha
% 8:12, Low alpha 8:10, High alpha 10:12, Beta 13:30).

% avg_deg is an integer - the desired average degree of the graph resulting
% from the adjacency matrix.

% threshold_vector is a vector of thresholds to test that will result in the
% desired average degree.

% Outputs:
% Node_Results is a 1x1 structure containing the fields Threshold, Clust,
% and Path, each which are (# of eeg files) x 4 cell arrays ( 1
% column for file name, 3 columns for resting, music and faces conditions).

% FUNCTION 

% variables
T = threshold_vector;

% initialize cell arrays
Clust = cell(length(coh_psd) + 1 , 4);
Path = cell(length(coh_psd) + 1, 4);
Threshold = cell(length(coh_psd) + 1, 4);

% name columns 
Clust{1, 2} = "resting";
Clust{1, 3} = "music";
Clust{1, 4} = "faces";
Path{1, 2} = "resting";
Path{1, 3} = "music";
Path{1, 4} = "faces";
Threshold{1, 2} = "resting";
Threshold{1, 3} = "music";
Threshold{1, 4} = "faces";

% input file names 
Clust(2:size(Clust, 1), 1) = coh_psd(:, 1);
Path(2:size(Path, 1), 1) = coh_psd(:, 1);
Threshold(2:size(Threshold, 1), 1) = coh_psd(:, 1);

% loop to calculate individual node clustering coefficients and path
% lengths
for i = 1:length(coh_psd)
    file_data = coh_psd{i, 2};
    for j = 1:3
        for k = 1:length(T)
            A = coh_matrix(file_data{j, 2}, freq, T(k));
            avg_deg_coh = round(mean(degree(graph(A))));
            if avg_deg_coh == avg_deg
               threshold_value = T(k);
               break
            end
        end
            Threshold{i + 1, j + 1} = threshold_value;
            C = clustering_coef_matrix(A, 'bin');
            Clust{i + 1, j + 1} = C;
            M = sparse(A);
            D = graphallshortestpaths(M);
            Path{i + 1, j + 1} = D;
    end
end

Threshold = {Threshold};
Clust = {Clust};
Path = {Path};

Node_Results = struct('Threshold', Threshold, 'Clust', Clust, 'Path', Path);

% save the structure 
save_name = [save_name '.mat'];
save(save_name, 'Node_Results', '-v7.3');

end

