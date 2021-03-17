% format of code to compute spatial variance in clustering and path length for each control/patient
% change 'freq' to frequency band name

% load controls data
load(' ') % data in the form of Node_Results from node_clust_path function 
Controls_Clustering = Node_Results.Clust;
Controls_Path_Length = Node_Results.Path(:, 2:4);

% load patients data
load('')
Patients_Clustering = Node_Results.Clust;
Patients_Path_Length = Node_Results.Path(:, 2:4);

% Clustering Variance 
Controls_Clust = Controls_Clustering(2:length(Controls_Clustering), :);
Patients_Clust = Patients_Clustering(2:length(Patients_Clustering), :);
Controls_Clust_Var = cell(length(Controls_Clust), 4);
Controls_Clust_Var(:, 1) = {'control'};
Patients_Clust_Var = cell(length(Patients_Clust), 4);
Patients_Clust_Var(:, 1) = {'patient'};

% loops to compute variance of node clustering for each control and patient in each condition 
for i = 1:length(Controls_Clust)
    for j = 1:3
        Controls_Clust_Var{i, j + 1} = var(Controls_Clust{i, j + 1});
    end
end
for i = 1:length(Patients_Clust)
    for j = 1:3
        Patients_Clust_Var{i, j + 1} = var(Patients_Clust{i, j + 1});
    end
end
Clust_Var = [Controls_Clust_Var; Patients_Clust_Var];
Freq_Clust_Var = cell2table(Clust_Var, 'VariableNames', {'group' 'resting' 'music' 'faces'});

% Path Length Variance
Controls_Path = Controls_Path_Length(2:length(Controls_Path_Length), :);
Patients_Path = Patients_Path_Length(2:length(Patients_Path_Length), :);
% take mean of each path length matrix 
numchan = length(Controls_Path{1});
for i = 1:length(Controls_Path)
    for j = 1:3
        for k = 1:numchan
            for l = 1:numchan
                if isinf(Controls_Path{i, j}(k, l))
                    Controls_Path{i, j}(k, l) = 0;
                end
            end
        end
        Controls_Path{i, j} = mean(Controls_Path{i, j});
    end
end
numchan = length(Patients_Path{1});
for i = 1:length(Patients_Path)
    for j = 1:3
        for k = 1:numchan
            for l = 1:numchan
                if isinf(Patients_Path{i, j}(k, l))
                    Patients_Path{i, j}(k, l) = 0;
                end
            end
        end
        Patients_Path{i, j} = mean(Patients_Path{i, j});
    end
end

Controls_Path_Var = cell(length(Controls_Path), 4);
Controls_Path_Var(:, 1) = {'control'};
Patients_Path_Var = cell(length(Patients_Clust), 4);
Patients_Path_Var(:, 1) = {'patient'};

% loops to compute variance of node path lengths for each patient/control
% in each condition
for i = 1:length(Controls_Path)
    for j = 1:3
        Controls_Path_Var{i, j + 1} = var(Controls_Path{i, j});
    end
end

for i = 1:length(Patients_Path)
    for j = 1:3
        Patients_Path_Var{i, j + 1} = var(Patients_Path{i, j});
    end
end

Path_Var = [Controls_Path_Var; Patients_Path_Var];
Freq_Path_Var = cell2table(Path_Var, 'VariableNames', {'group' 'resting' 'music' 'faces'});

%% save tables
writetable(Freq_Clust_Var , 'Freq_Clust_Var.csv')
writetable(Freq_Path_Var, 'Freq_Path_Var.csv')

