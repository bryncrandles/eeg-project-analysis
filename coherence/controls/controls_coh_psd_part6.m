% add necessary paths for eeglab, text file, and data sets
addpath('/home/bc11xx/projects/def-wjmarsha/bc11xx', '/home/bc11xx/MATLAB/eeglab2019_1')

% folder of data files
datafolder = '/home/bc11xx/projects/def-wjmarsha/bc11xx/eegfiles';

% pattern of files of interest
filepattern = fullfile(datafolder, 'sub-45*_szcontrol_eeg_clean.set');

% directory of data files
datafiles = dir(filepattern);

% cell array to store coherence and psd 
coh_psd_ctrl_6 = cell(length(datafiles), 2);

% input files names into cell array
name = {datafiles.name}';
coh_psd_ctrl_6(:, 1) = name(1:length(datafiles));

% use window function in coherence estimates
window = 1;

% loop to calculate coh, psd for level 450 controls 
parfor i = 1:length(datafiles)
    filename = datafiles(i).name;
    fullfilename = fullfile(datafiles(i).folder, filename);
    eeglab
    EEG = pop_loadset(fullfilename);
    all_cond = ext_all_cond(EEG);
    srate = EEG.srate;
    overlap = srate / 2;
    coherence = cell(3, 1);
    powerspd = cell(3, 1);
       for j = 1:3
           coherence{j} = coh(all_cond{j, 2}, srate, all_cond{j, 3}, overlap, window); 
           powerspd{j} = PSD(all_cond{j, 2}, srate, all_cond{j, 3}, overlap, window);
       end
       file_coh_psd = cell(3, 3);
       file_coh_psd(:, 1) = all_cond(1:3, 1);
       file_coh_psd(:, 2) = coherence(:, 1);
       file_coh_psd(:, 3) = powerspd(:, 1);
       coh_psd_ctrl_6{i, 2} = file_coh_psd;
end

save(['coh_psd_ctrl_6_' date '.mat'], 'coh_psd_ctrl_6', '-v7.3')

exit