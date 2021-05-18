function PSD = PSD(data, window_length, brkpnts, overlap, window)

% DESCRIPTION OF FUNCTION
% The function psd calculates the power spectral density of each channel in
% the EEG data.

% Inputs:

% data: is a matrix containing the EEG data with dimensions (number of channels) x (total number of data points).

% window_length: is an integer whose value is the length of the window for
% calculating & averaging power spectrum (we use 1 second windows - length = sampling rate)

% brkpnts: is a row vector whose entries are the breakpoints in the data. Note
% that the first entry of the brkpnts vector should be 0, followed by the
% breakpoints within the data, and the last entry should be the total
% number of points in the data.

% overlap (int); integer ranging from 1 to 1/2 sampling rate - for no
% overlap, use 1 (if use 0 - bug in code).

% window (logical): 1 or 'true': use hann window function with input
% window_length

% Outputs:

% PSD is a (numchannels) x (srate) matrix where the i^th row is the power
% spectral density of the i^th channel.

% FUNCTION CODE

% number of channels
numchannels = size(data, 1);

% hann window function
if window 
    w = hann(window_length)';
else
    w = 1;
end

% size of brkpnts vector
s = length(brkpnts);

% windows
k = 2:s; 
numwindows = sum(floor((brkpnts(k) - brkpnts(k - 1) - window_length)/overlap) + 1);

% create matrix of zeros to store psd 
PSD = zeros(numchannels, window_length);

% loop to calculate psd of each channel 
for i = 1:numchannels
    for k = 2:s
        for l = 1:floor((brkpnts(k) - brkpnts(k - 1) - window_length)/overlap) + 1
            PSD(i, :) = PSD(i, :) + ((abs(fft((data(i, brkpnts(k - 1) + 1 + overlap*(l - 1):(brkpnts(k - 1) + window_length + overlap*(l - 1)))).*w))).^2);
        end
    end
end

% average
PSD = PSD./numwindows; 

end