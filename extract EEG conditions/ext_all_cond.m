function all_cond = ext_all_cond(EEG)

% DESCRIPTION OF FUNCTION 

% ext_all_cond inputs an EEG file and outputs a cell array of the data and
% corresponding breakpoints of the following conditions of interest:
% resting, music, emotional faces, eyes open, eyes closed, happy music, joyful music, sad
% music, fear music, happy face, fearful face, neutral face, and angry
% face.

% Input:

% EEG is an EEG data file (a 1x1 structure) with fields "event" and "srate".  "event" is a
% structure that contains the markers of the event types and their
% latencies. "srate" is the sampling rate of the EEG data.

% Output:

% all_cond is a cell array with dimensions (# of conditions X 3), where the first column is the name of the condition, 
% the second column is the EEG data of the corresponding condition, and the
% third column is the vector of the corresponding breakpoints in the data
% for that condition. 

% FUNCTION 

% create string vector of the types of event markers
type = string({EEG.event.type});

% create vector of the latencies of the event markers
latency = cell2mat({EEG.event.latency});

% create vector of boundary points in event structure
boundarypnts = floor(latency(type == 'boundary'));

%% extract resting condition

% beginning of resting condition
bgncond_rest = floor(latency(type == 'eopn'));

% if no eopn marker, use open marker instead
if isempty(bgncond_rest)
   bgncond_rest = floor(latency(type == 'open'));
end

% select the first eopen or open for beginning of condition
bgncond_rest = bgncond_rest(1);

% end of resting condition 
endcond_rest = floor(latency(type == 'ecld')); 

% if no ecld marker, use clos instead
if isempty(endcond_rest)
   endcond_rest = floor(latency(type == 'clos'));
end

endcond_rest = endcond_rest(length(endcond_rest)) + 60*EEG.srate + 1;

% create a vector of the indices of the resting condition
condition_rest = bgncond_rest:endcond_rest;

% extract resting data from EEG 
restingdata = EEG.data(:, condition_rest);

% search for boundary points within the resting condition
boundarypnts_rest = find(ismember(condition_rest, boundarypnts));

% end point of data 
endpnt_rest = length(condition_rest);

% final breakpoints vector 
restingbrkpnts = sort(unique([0 boundarypnts_rest endpnt_rest]));


%% extract music condition

% search for start of condition
musicidx = find(endsWith(type, 'm'));

% create vectors of the beginning points of condition and end points of condition
bgncond_music = floor(latency(musicidx(1)));
endcond_music = floor(latency(musicidx(length(musicidx)))) + (60*EEG.srate + 1);

% create a vector of the indices of the desired condition
condition_music = cell(1, length(bgncond_music));
for i = 1:length(bgncond_music)
    condition_music{i} = bgncond_music(i):endcond_music(i);
end
condition_music = cell2mat(condition_music);

% extract data from EEG 
musicdata = EEG.data(:, condition_music);

% search for boundary points within the condition
boundarypnts_music = find(ismember(condition_music,boundarypnts));

% make boundary points between endcond and bgncond 
endpnts_music = zeros(1, length(endcond_music));
for i = 1:length(endcond_music)
    endpnts_music(i) = find(condition_music == endcond_music(i));
end

% final breakpoints vector 
musicbrkpnts = sort(unique([0 boundarypnts_music endpnts_music]));

%% extract faces condition data

% faces
bgn_all_faces = sort([find(endsWith(type, 'h1')), find(endsWith(type, 'f2')), find(endsWith(type, 'n3')), find(endsWith(type, 'a4'))]);

bgn_faces = bgn_all_faces(bgn_all_faces > musicidx(1));
bgnidx_faces = zeros(1, 5);
endidx_faces = zeros(1, 5);
bgnidx_faces(1) = bgn_faces(1);

typeidx_faces = 1:length(type);
idx_faces = find(typeidx_faces > bgnidx_faces(1));

% parse into two sections if they exist, otherwise, leave as one section
sess = find(type == 'SESS');
sess = sess(ismember(sess, idx_faces));

if ~isempty(sess)
    for i = 1:length(sess)
        endidx_faces(i) = sess(i) - 1;
        bgnidx_faces(i + 1) = sess(i) + 6;
    end
    endidx_faces(length(sess) + 1) = length(type);
    bgnidx_faces = bgnidx_faces(bgnidx_faces > 0);
    endidx_faces = endidx_faces(endidx_faces > 0);
else
    endidx_faces(1) = length(type);
    bgnidx_faces = bgnidx_faces(bgnidx_faces > 0);
    endidx_faces = endidx_faces(endidx_faces > 0);
end

% create vectors of the beginning points of condition and end points of condition
bgncond_faces = floor(latency(bgnidx_faces));
endcond_faces = floor(latency(endidx_faces));

% create a vector of the indices of the desired condition
condition_faces = cell(1, length(bgncond_faces));
for i = 1:length(bgncond_faces)
    condition_faces{i} = bgncond_faces(i):endcond_faces(i);
end
condition_faces = cell2mat(condition_faces);

% extract data from EEG 
facesdata = EEG.data(:, condition_faces);

% search for boundary points within the condition
boundarypnts_faces = find(ismember(condition_faces, boundarypnts));

% make boundary points between endcond and bgncond 
endpnts_faces = zeros(1, length(endcond_faces));
for i = 1:length(endcond_faces)
    endpnts_faces(i) = find(condition_faces == endcond_faces(i));
end

% final breakpoints vector 
facesbrkpnts = sort(unique([0 boundarypnts_faces endpnts_faces]));


%% eyes open condition

% % latencies of the end of the eyes open condition
% endcond_eopen = floor(latency(type == 'clos'));
% 
% % if there is not clos marker, use ecld
% if isempty(endcond_eopen)
%     endcond_eopen = floor(latency(type == 'ecld'));
% end
% 
% % extract 60 seconds prior to each clos
% bgncond_eopen = endcond_eopen - (60*EEG.srate + 1);
% 
% % create a vector of the indices of the eyes open condition
% condition_eopen = cell(1, length(bgncond_eopen));
% for i = 1:length(bgncond_eopen)
%     condition_eopen{i} = bgncond_eopen(i):endcond_eopen(i);
% end
% condition_eopen = cell2mat(condition_eopen);
% 
% % in case 60 seconds prior to clos is too much
% condition_eopen = condition_eopen(condition_eopen > 0);
% 
% % extract eyes open data from EEG 
% eyesopendata = EEG.data(:, condition_eopen);
% 
% % search for boundary points within the condition
% boundarypnts_eopen = find(ismember(condition_eopen, boundarypnts));
% 
% % make boundary points between endcond and bgncond 
% endpnts_eopen = zeros(1, length(endcond_eopen));
% for i = 1:length(endcond_eopen)
%     endpnts_eopen(i) = find(condition_eopen == endcond_eopen(i));
% end
% 
% % final breakpoints vector 
% eyesopenbrkpnts = sort(unique([0 boundarypnts_eopen endpnts_eopen]));
% 
% 
% %% eyes closed condition
% 
% % create vectors of the beginning points of condition and end points of condition
% bgncond_eclosed = floor(latency(type == 'ecld'));
% 
% % if there is no ecld marker, use clos marker
% if isempty(bgncond_eclosed)
%     bgncond_eclosed = floor(latency(type == 'clos'));
% end
% 
% % end points - 60 seconds later
% endcond_eclosed = bgncond_eclosed + 60*EEG.srate + 1;
% 
% % create a vector of the indices of the desired condition
% condition_eclosed = cell(1, length(bgncond_eclosed));
% for i = 1:length(bgncond_eclosed)
%      condition_eclosed{i} = bgncond_eclosed(i):endcond_eclosed(i);
% end
% condition_eclosed = cell2mat(condition_eclosed);
% 
% % extract data from EEG 
% eyescloseddata = EEG.data(:, condition_eclosed);
% 
% % search for boundary points within the condition
% boundarypnts_eclosed = find(ismember(condition_eclosed,boundarypnts));
% 
% % make boundary points between endcond and bgncond 
% endpnts_eclosed = zeros(1, length(endcond_eclosed));
% for i = 1:length(endcond_eclosed)
%     endpnts_eclosed(i) = find(condition_eclosed == endcond_eclosed(i));
% end
% 
% % final breakpoints vector 
% eyesclosedbrkpnts = sort(unique([0 boundarypnts_eclosed endpnts_eclosed]));
% 
% %% different music - hapm, joym, sadm, feam conditions
% 
% % names of start of music conditions
% bgnname_diff_music = ["hapm", "joym", "sadm", "feam"];
% 
% % check that all music conditions are in the data set
% for i = 1:length(bgnname_diff_music)
%     rm = find(type == bgnname_diff_music(i), 1);
%     if isempty(rm)
%        bgnname_diff_music(i) = "rm";
%     end
% end
% 
% % remove name of music condition that is not in data set
% rm = find(bgnname_diff_music == "rm");
% if ~isempty(rm)
%     bgnname_diff_music(rm) = [];
% end
% 
% % find indices of the beginning of each music condition
% bgnidx_diff_music = zeros(1, length(bgnname_diff_music));
% for i = 1:length(bgnname_diff_music)
%     bgnidx_diff_music(i) = find(type == bgnname_diff_music(i));
% end
% 
% % latencies of start and end of each music condition
% bgncond_diff_music = floor(latency(bgnidx_diff_music));
% endcond_diffmusic = bgncond_diff_music + 60*EEG.srate + 1;
% 
% % create a cell array where each array is the indices of the different
% % music conditions
% condition_diff_music = cell(length(bgncond_diff_music), 1);
% for i = 1:length(bgncond_diff_music)
%     condition_diff_music{i} = bgncond_diff_music(i):endcond_diffmusic(i);
% end
% 
% % find boundary points in each music condition
% boundarypnts_diff_music = cell(size(condition_diff_music, 1), 1);
% for i = 1:length(condition_diff_music)
%     boundarypnts_diff_music{i} = find(ismember(condition_diff_music{i}, boundarypnts));
% end
% 
% % total number of data points in each music condition
% endpnt_diff_music = length(condition_diff_music{1});
% 
% % breakpoints of each music condition
% diff_music_brkpnts = cell(length(condition_diff_music), 1);
% for i = 1:length(condition_diff_music)
%     diff_music_brkpnts{i} = sort(unique([0 boundarypnts_diff_music{i} endpnt_diff_music]));
% end
% 
% % extract data
% diff_music_data = cell(length(condition_diff_music), 1);
% for i = 1:length(condition_diff_music)
%     diff_music_data{i} = EEG.data(:, condition_diff_music{i});
% end
% 
% %% different faces - hapy, fear, neut, angy conditions
% % names of markers
% bgnname_diff_faces = ["h1", "f2", "n3", "a4"];
% 
% % find indices of the beginning of each face condition
% bgnidx_diff_faces = cell(length(bgnname_diff_faces), 1);
% for i = 1:length(bgnname_diff_faces)
%     bgnidx_diff_faces{i} = find(endsWith(type, bgnname_diff_faces(i)));
% end
% 
% % check if lengths between each marker are less than 2 seconds - if so, put
% % them together 
% length_bgnidx_diff_faces = cell(length(bgnidx_diff_faces), 1);
% for i = 1:length(bgnidx_diff_faces)
%     j = 2:length(bgnidx_diff_faces{i});
%     length_bgnidx_diff_faces{i} = (latency(bgnidx_diff_faces{i}(j)) - latency(bgnidx_diff_faces{i}(j - 1)) - 1)/EEG.srate;
% end
%     
% for i = 1:length(length_bgnidx_diff_faces)
%     d = zeros(1, length(bgnidx_diff_faces{i}));
%     for j = 1:length(length_bgnidx_diff_faces{i})
%         if length_bgnidx_diff_faces{i}(j) <= 2
%            d(j) = bgnidx_diff_faces{i}(j + 1);
%         end
%     end
%     d = nonzeros(d);
%     rm = zeros(1, length(bgnidx_diff_faces{i}));
%     for k = 1:length(d)
%         rm(k) = find(bgnidx_diff_faces{i} == d(k));
%     end
%     rm = nonzeros(rm);
%     bgnidx_diff_faces{4}(rm) = [];
% end
% 
% % latencies of start and end of each face condition
% bgncond_diff_faces = cell(length(bgnidx_diff_faces), 1);
% for i = 1:length(bgnidx_diff_faces)
%     bgncond_diff_faces{i} = floor(latency(bgnidx_diff_faces{i}));
% end
% 
% endcond_diff_faces = cell(length(bgncond_diff_faces), 1);
% for i = 1:length(bgncond_diff_faces)
%     endcond_diff_faces{i} = bgncond_diff_faces{i} + (2.0*EEG.srate + 1);
% end
% 
% condition_diff_faces = cell(length(bgncond_diff_faces), 1);
% segment_length = length(bgncond_diff_faces{1}(1):endcond_diff_faces{1}(1));
% for i = 1:length(condition_diff_faces)
%     condition_diff_faces{i} = zeros(1, length(bgncond_diff_faces{i})*segment_length);
%     for j = 1:length(bgncond_diff_faces{i})
%         condition_diff_faces{i}((1 + (j - 1)*segment_length):(j*segment_length)) = bgncond_diff_faces{i}(j):endcond_diff_faces{i}(j);
%     end
% end
% 
% % remove points that are greater than the total number of data points 
% for i = 1:length(condition_diff_faces)
%     rm = find(condition_diff_faces{i} > length(EEG.data), 1);
%     if ~isempty(rm)
%     condition_diff_faces{i} = condition_diff_faces{i}(1:rm - 1);
%     end
% end
% 
% % find boundary points in each face condition
% boundarypnts_diff_faces = cell(length(condition_diff_faces), 1);
% for i = 1:length(condition_diff_faces)
%     boundarypnts_diff_faces{i} = find(ismember(condition_diff_faces{i}, boundarypnts));
% end
% 
% % remove endpoints that are larger than total number of data points
% for i = 1:length(endcond_diff_faces)
%     rm = find(endcond_diff_faces{i} > length(EEG.data));
%     if ~isempty(rm)
%         endcond_diff_faces{i} = endcond_diff_faces{i}(1:rm - 1);
%     end
% end
% 
% % make boundary points between endcond and bgncond 
% endpnts_diff_faces = cell(length(condition_diff_faces), 1);
% for i = 4%:length(endpnts_diff_faces)
%     endpnts_diff_faces{i} = zeros(1, length(endcond_diff_faces{i}));
%     for j = 4%:length(endcond_diff_faces{i})
%         endpnts_diff_faces{i}(j) = find(condition_diff_faces{i} == endcond_diff_faces{i}(j));
%     end
% end
% 
% % breakpoints of each face condition
% diff_faces_brkpnts = cell(length(condition_diff_faces), 1);
% for i = 1:length(condition_diff_faces)
%     diff_faces_brkpnts{i} = sort(unique([0 boundarypnts_diff_faces{i} endpnts_diff_faces{i}]));
% end
% 
% % data
% diff_faces_data = cell(length(condition_diff_faces), 1);
% for i = 1:length(condition_diff_faces)
%     diff_faces_data{i} = EEG.data(:, condition_diff_faces{i});
% end

%% cell array of all of the conditions 
cond_names = ["resting" "music" "faces"];% "eyesopen" "eyesclosed" bgnname_diff_music bgnname_diff_faces];

all_cond = cell(length(cond_names), 4);

for i = 1:length(cond_names)
    all_cond{i, 1} = cond_names(i);
end

all_cond{1, 2} = restingdata;
all_cond{1, 3} = restingbrkpnts;
all_cond{2, 2} = musicdata;
all_cond{2, 3} = musicbrkpnts;
all_cond{3, 2} = facesdata;
all_cond{3, 3} = facesbrkpnts;
% all_cond{4, 2} = eyesopendata;
% all_cond{4, 3} = eyesopenbrkpnts;
% all_cond{5, 2} = eyescloseddata;
% all_cond{5, 3} = eyesclosedbrkpnts;

% for i = 1:length(diff_music_data)
%     all_cond{i + 5, 2} = diff_music_data{i}; 
%     all_cond{i + 5, 3} = diff_music_brkpnts{i};
% end
% 
% for i = 1:length(diff_faces_data)
%     all_cond{i + 5 + length(diff_music_data), 2} = diff_faces_data{i};
%     all_cond{i + 5 + length(diff_music_data), 3} = diff_faces_brkpnts{i};
% end

for i = 1:length(cond_names)
    all_cond{i, 4} = ((length(all_cond{i, 2}) - 1)/EEG.srate)/60;
end

end
