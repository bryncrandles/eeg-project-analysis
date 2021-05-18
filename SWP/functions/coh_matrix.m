function [A, threshold] = coh_matrix(cohdata, freq, avg_deg)

% Description

% coh_matrix computes the adjacency (connectivity) matrix of the coherence data for an EEG file. 

% Inputs:
%   cohdata (3D array): numchannels x numchannels x window_length matrix
%   freq (vec): frequency range of interest a:b
%   avg_deg: desired average degree of graph

% Outputs:
%   A is the adjacency matrix using threshold describing the connectivity between channels
%   (electrodes).
%   threhsold: threshold that gives adjacency matrix A with desired average
%   degree


% Function 

% number of channels
numchannels = size(cohdata, 1); 

% sum
idx = avg_deg*numchannels;

% initialize matrix for sum of coh values in freq range
coh_sum = zeros(numchannels); 

% sum of coherence values for each pair of channels
for i = 1:numchannels
    for j = 1:numchannels
    coh_sum(i, j) = sum(cohdata(i, j, freq));
    end
end

% remove sums of coherence of channels with themselves
for i = 1:numchannels
    coh_sum(i, i) = 0;
end

% sort coherence values
sort_coh_sum = sort(coh_sum(:), 'descend');

% select threshold so that "idx" connections are greater than or equal to
% threshold 
threshold = sort_coh_sum(idx);

% adjacency matrix 
A = coh_sum >= threshold;

% return error if average degree of graph A is not equal to input avg_deg
if round(mean(degree(graph(A))))~= avg_deg
   error('Error: desired average degree of graph not achieved')
end

end