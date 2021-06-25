% test my PSD function using 8 Hz sine wave, sampling
% rate of 250, no breakpoints in the data, window length = sampling rate, 
% overlap of 1/2 sampling rate, and no window function

f = 8;
fs = 250;
len = 2*fs;
overlap = fs/2;
breakpoints = [0 len];
window = 0;

% test
psd = test_psd_fct(f, fs, breakpoints, fs, fs/2, window);

% bin width = fs/window_length = 1 Hz
% all power is at 9th index: 7.5-8.5 Hz

% frequency vector for plotting
freq = 1:125;

% plot non-negative frequencies only
figure()
plot(freq, psd(1:fs/2))
ylabel('Power')
xlabel('Frequency')
title('Power spectrum')