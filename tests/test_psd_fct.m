function psd = test_psd_fct(f, fs, breakpoints, window_length, overlap, window)

% test PSD using sine wave

% Inputs

%   f (int): frequency of oscillator
%   fs (int): sampling rate
%   breakpoints (vec): 0 must be first entry. 2*fs must be last entry.
%   window_length (int): length of windows
%   overlap (int [1, fs/2]): amount of overlap for calculating power spectrum. For no overlap, use 1.
%   window (logical): 1 (true) use hann window function 


% Outputs
%   psd (vec): vector of power spectrum for test sine wave.


t = 0:(2 * fs - 1); % time 
x = sin(2 * pi * f/fs  * t); % generate sine wave 

% compute PSD 
psd = PSD(x, window_length, breakpoints, overlap, window);


end