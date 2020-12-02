% add necessary paths for eeglab, text file, and data sets
addpath('/home/bc11xx/projects/def-wjmarsha/bc11xx', '/home/bc11xx/MATLAB/eeglab2019_1')

% folder of data files
datafolder = '/home/bc11xx/projects/def-wjmarsha/bc11xx/eegfiles';

% pattern of files of interest
filepattern = fullfile(datafolder, 'sub-31*_sz_eeg_clean.set'); 

% directory of data files
datafiles = dir(filepattern);

% cell array to store coherence and psd 
coh_psd_2 = cell(length(datafiles), 2);

% input files names into cell array
name = {datafiles.name}';
coh_psd_2(:, 1) = name(1:length(datafiles));

% start timer
tic

% loop to calculate coh, psd for level 300 data files for resting, music
% and faces conditions 
for i = 1:length(datafiles)
    filename = datafiles(i).name;
    fullfilename = fullfile(datafiles(i).folder, filename);
    eeglab
    EEG = pop_loadset(fullfilename);
    all_cond = ext_all_cond(EEG);
    srate = EEG.srate;
    coherence = cell(3, 1);
    powerspd = cell(3, 1);
       for j = 1:3
           coherence{j} = coh(all_cond{j, 2}, srate, all_cond{j, 3}); 
           powerspd{j} = PSD(all_cond{j, 2}, srate, all_cond{j, 3});
       end
       file_coh_psd = cell(3, 3);
       file_coh_psd(:, 1) = all_cond(1:3, 1);
       file_coh_psd(:, 2) = coherence(:, 1);
       file_coh_psd(:, 3) = powerspd(:, 1);
       coh_psd_2{i, 2} = file_coh_psd;
end

toc

save('coh_psd_2.mat', 'coh_psd_2', '-v7.3')

exit