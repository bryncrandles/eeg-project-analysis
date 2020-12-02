function COH = coh(data, srate, brkpnts)

% DESCRIPTION OF FUNCTION

% The function coh(data, srate, brkpnts) calculates the coherence between each pair of channels in the EEG data. 

% Inputs: 

% data: is a matrix containing the EEG data with dimensions (number of channels) x (total number of data points).

% srate: is an integer whose value is the sampling rate of the data collected. 

% brkpnts: is a row vector whose entries are the breakpoints in the data. Note
% that the first entry of the brkpnts vector should be 0, followed by the
% breakpoints within the data, and the last entry should be the total
% number of points in the data.

% Outputs:

% COH: is a (numchannels) x (numchannels) x (srate) 3D matrix where the vector (i, j, :) is the coherence between the i^th and j^th channels.

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

% create matrix of zeros to store coherence data 
COH = zeros(numchannels, numchannels, srate);

% loop to calculate coherence of each pair of channels
COH = zeros(numchannels, numchannels, srate);
for i = 1:numchannels
    for j = 1:numchannels
        PSD1 = zeros(1, srate);
        PSD2 = zeros(1, srate);
        CSD = zeros(1, srate);
        for k = 2:s
            for l = 1:floor((brkpnts(k) - brkpnts(k - 1) - srate)/overlap) + 1
                PSD1 = PSD1 + ((abs(fft((data(i, brkpnts(k - 1) + 1 + overlap*(l - 1):(brkpnts(k - 1) + srate + overlap*(l - 1)))).*w))).^2)./numwindows;
                PSD2 = PSD2 + ((abs(fft((data(j, brkpnts(k - 1) + 1 + overlap*(l - 1):(brkpnts(k - 1) + srate + overlap*(l - 1)))).*w))).^2)./numwindows;
                CSD = CSD + (fft((data(i, brkpnts(k - 1) + 1 + overlap*(l - 1):(brkpnts(k - 1) + srate + overlap*(l - 1)))).*w).*conj(fft((data(j, brkpnts(k - 1) + 1 + overlap*(l - 1):(brkpnts(k - 1) + srate + overlap*(l - 1)))).*w)))./numwindows;
            end
        end
        COH(i, j, :) = ((abs(CSD)).^2)./(PSD1.*(PSD2));
    end
end

end
