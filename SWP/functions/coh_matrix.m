function A = coh_matrix(cohdata, freq, threshold)

% coh_matrix computes the adjacency (connectivity) matrix of the coherence data for an EEG file. 

% Inputs:
% cohdata is a numchannels x numchannels x srate matrix
% freq is a frequency range of interest [a, b], input as a:b.
% threshold is a numerical value above which the sum of coherence values for pair of channels is considered significant. 

% Outputs:
% A is the adjacency matrix describing the connectivity between channels
% (electrodes).

% number of channels
numchannels = size(cohdata, 1); 

% initialize matrix for sum of coh values in freq range
coh_sum = zeros(numchannels, 1); 

% sum of coherence values for each pair of channels
for i = 1:numchannels
    for j = 1:numchannels
    coh_sum(i, j) = sum(cohdata(i, j, freq));
    end
end

% adjacency matrix of channel pairs with sum of coherence values above
% threshold, do not consider coherence of channels with themselves
A = coh_sum > threshold & round(coh_sum) ~= length(freq);

end