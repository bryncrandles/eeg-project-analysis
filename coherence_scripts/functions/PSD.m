function PSD = PSD(data, srate, brkpnts);

% DESCRIPTION OF FUNCTION
% The function psd calculates the power spectral density of each channel in
% the EEG data.

% Inputs:

% data: is a matrix containing the EEG data with dimensions (number of channels) x (total number of data points).

% srate: is an integer whose value is the sampling rate of the data collected. 

% brkpnts: is a row vector whose entries are the breakpoints in the data. Note
% that the first entry of the brkpnts vector should be 0, followed by the
% breakpoints within the data, and the last entry should be the total
% number of points in the data.

% Outputs:

% PSD is a (numchannels) x (srate) matrix where the i^th row is the power
% spectral density of the i^th channel.

% FUNCTION CODE

% number of channels
numchannels = size(data, 1);

% hann window function
w = hann(srate)';

% overlap
overlap = floor(srate/2);

% size of brkpnts vector
s = size(brkpnts, 2);

% windows
k = 2:s; 
numwindows = sum(floor((brkpnts(k) - brkpnts(k-1) - srate)/overlap) + 1);

% create matrix of zeros to store psd 
PSD = zeros(numchannels, srate);

% loop to calculate psd of each channel 
for i = 1:numchannels
    for k = 2:s
        for l = 1:floor((brkpnts(k) - brkpnts(k - 1) - srate)/overlap) + 1
            PSD(i, :) = PSD(i, :) + ((abs(fft((data(i, brkpnts(k - 1) + 1 + overlap*(l - 1):(brkpnts(k - 1) + srate + overlap*(l - 1)))).*w))).^2)./numwindows;
        end
    end
end

end