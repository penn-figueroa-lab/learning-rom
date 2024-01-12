% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % %  ----------------                                           % % % % 
% % % %  https://github.com/penn-figueroa-lab/learning-rom          % % % % 
% % % %  Shafagh Keyvanian: shkey@seas.upenn.edu                    % % % %
% % % %  ----------------                                           % % % %                                                             % % % %
% % % %                                                             % % % %
% % % % Convert Motive export to skl struct and joints angles array % % % %
% % % %                                                             % % % %
% % % %   Model each arm as 7DoF chain and returns relative angles  % % % %
% % % %   7DoF order : ShRot, ShAA, ShFE, ElFE, ElPS, WrFE, WrDev   % % % %
% % % %                                                             % % % %
% % % %                      -------------------                    % % % % 
% % % %                      OptiTrack procedure                    % % % %
% % % %                      -------------------                    % % % %
% % % %  OptiTrack exp - Skeleton: Conventional Upper (27 Markers)  % % % %
% % % %  Skeleton assets should be reconstructed, labeled, solved   % % % %
% % % %  Markers checked, relabeled and gaps filled: Interpolation  % % % %
% % % %  Takes saved & named as: Subject# Test (L/R)(non/imp) date  % % % %
% % % %  export info: bones, bone markers, +fin , meas coord, quat  % % % %
% % % %                                                             % % % %
% % % %                        ----------------                     % % % % 
% % % %                           This script                       % % % % 
% % % %                        ----------------                     % % % % 
% % % %  raw_exports:                                               % % % %
% % % %  Motive exported data .csv  43 Bones(+fingers), 27 Markers  % % % % 
% % % %  rows=frames, cols= #, time, Bones-quat & pos, Markers-pos  % % % %
% % % %  path: .\data\raw_exports\date\Subject# -- file: Take name  % % % %
% % % %  edited_exports:                                            % % % %
% % % %  saves skeleton as skl.mat -- Fields: time, bones, markers  % % % % 
% % % %  path: .\data\edited_exports\date\Subject# -- Subject#_test % % % %
% % % %  bones fields: rows=frames, col=(quat(x y z w) pos[x y z])  % % % %
% % % %  solved_angles:                                             % % % %
% % % %  converts skeleton struct quats to ROM array: joint angles  % % % %
% % % %  calls extractAngMot: col: angGlobal(8:10) angLocal(11:13)  % % % % 
% % % %  file: ROM_Subject#_(healthy/impaired)(L/R)_test            % % % %
% % % %  path: .\data\solved_angles\date\Subject# --                % % % %
% % % %                                                             % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


%% % save skl struct in edited_exports % %

clc, clear, close all
addpath (genpath('.\'))

date    = '2023-04-01';
rawFiles = dir(fullfile('.\data\raw_exports\',date,'**\*.csv'));

for k = 1:numel(rawFiles)

    csvfile = rawFiles(k).name;
    fprintf('raw data processing::: %s\n',csvfile)

    rawSeg = readcell(csvfile);                 % readcell to keep string data
    rawSeg (:,[1,2]) = [];
    Track = strsplit(char(rawSeg(1,2)));        % Take Name
    header = erase (rawSeg(3,:),"Skeleton:");   % Bones Names
    
    raw = readmatrix(csvfile);                  % readmatrix to edit raw data
    raw ([1,2,3,4,5,6], : ) = [];
    % markerColumn = NumBones*7+1;              % cleanData: removes similar
    % [dataCleaned, tol, dataPercent] = cleanData (raw , markerColumn);  % 
    t = raw (:,2) - raw (1,2);
    raw (:,[1,2]) = [];

    skl = struct;
    skl.time = t;
    
    NumBones   = 43;    % 13 without fingers, 43 with fingers
    NumMarkers = 27;
    segName = {};
    segData = {};
    for j = 1:NumBones
          segName{j} = (header(7*j));
          segData{j} = (raw(:,[7*j-2:7*j, 7*j-6:7*j-3]));
          skl = setfield(skl,char(segName{j}),segData{j});
    end
    
    for m = 1:NumMarkers
          segName{NumMarkers+m} = (header(NumBones*7+3*m));
          segData{NumMarkers+m} = (raw(:,NumBones*7+3*m-2:NumBones*7+3*m));
          skl = setfield(skl,char(segName{NumMarkers+m}),segData{NumMarkers+m});
    end
    
    structPath = fullfile('.\data\edited_exports\',date,char(Track(1,1)));
    if ~exist(structPath, 'dir')
        mkdir(structPath);
    end
    
    arm = char(Track(1,3));
    RL = arm(1:1);
    if contains(arm,"imp")
        cond = "impaired";
    else
        cond = "healthy";
    end    
    structFilename = string(string(Track(1,1)) + "_" + cond + RL + "_" + string(Track(1,2)));
    structfile = fullfile(structPath, structFilename);
    save(structfile,'skl');
    fprintf('skl struct saved::::::: %s \n',structFilename)

end


%% % % save ROM array in solved_angles % % % % 

clc, clear, close all
addpath (genpath('.\'))

date    = '2023-04-01';
sklFiles = dir(fullfile('.\data\edited_exports\',date,'**\*.mat'));

for k = 1:numel(sklFiles)
    
    sklStruct = load (sklFiles(k).name);
    sklName = char(sklFiles(k).name);
    fprintf('processing skl::: %s\n',sklName)
    
    subject = char(sklName);
    subject = subject(1:8);
    if contains(sklName,"imp")
        cond = "impaired";
    else
        cond = "healthy";
    end   
    if contains(sklName,"R_")
        RL = "R";
    elseif contains(sklName,"L_")
        RL = "L";
    else
        RL = "not specified";
    end
    
    skl = extractAngMot (sklStruct.skl);                  % Extract relative angles

    if RL == 'R'
        rom(:,1:7) = [skl.RUArm(:,11:13), skl.RFArm(:,11), skl.RFArm(:,13), skl.RHand(:,11:12)]; 
    elseif RL == 'L'
        rom(:,1:7) = [skl.LUArm(:,11:13), skl.LFArm(:,11), skl.LFArm(:,13), skl.LHand(:,11:12)]; 
    else
        fprintf('Arm not specified in the Take name')
        continue
    end
    
    % % save ROM array in solved_angles % % % % 
    romPath = fullfile('.\data\solved_angles\',date,subject);
    if ~exist(romPath, 'dir')
        mkdir(romPath);
    end

    romFilename = string("ROM_" + sklName);
    ROMfile = fullfile(romPath, romFilename);
    save(ROMfile,'rom');
    fprintf('ROM array saved:::::::: %s \n',romFilename)
    
    clearvars -except path date sklFiles k

end
%% % % creat active and passive ROM
clear, clc
path = addpath (genpath('data\solved_angles\2023-04-01\'));

ROM_Subject0_healthyR_Active_ind = load ('ROM_Subject0_healthyR_Active_ind');
ROM_Subject0_healthyR_Active_indWrPS = load('ROM_Subject0_healthyR_Active_indWrPS');
ROM_Subject0_healthyR_Free = load('ROM_Subject0_healthyR_Free');
ROM_Subject0_healthyR_Passive_ind = load('ROM_Subject0_healthyR_Passive_ind');
ROM_Subject0_impairedR_Active_ind  = load('ROM_Subject0_impairedR_Active_ind');
ROM_Subject0_impairedR_Passive_ind = load('ROM_Subject0_impairedR_Passive_ind');

ROM_Subject1_healthyL_Active_ind = load('ROM_Subject1_healthyL_Active_ind'); 
ROM_Subject1_healthyL_Free = load('ROM_Subject1_healthyL_Free');
ROM_Subject1_healthyL_Passive_ind = load('ROM_Subject1_healthyL_Passive_ind');
ROM_Subject1_impairedR_Active_ind = load('ROM_Subject1_impairedR_Active_ind');
ROM_Subject1_impairedR_Free = load('ROM_Subject1_impairedR_Free');
ROM_Subject1_impairedR_Passive_ind = load('ROM_Subject1_impairedR_Passive_ind');

ROM_Subject2_healthyL_Active_ind = load('ROM_Subject2_healthyL_Active_ind');
ROM_Subject2_healthyL_Free = load('ROM_Subject2_healthyL_Free');
ROM_Subject2_healthyL_Passive_ind = load('ROM_Subject2_healthyL_Passive_ind');
ROM_Subject2_impairedR_Active_ind1 = load('ROM_Subject2_impairedR_Active_ind1'); 
ROM_Subject2_impairedR_Active_ind3 = load('ROM_Subject2_impairedR_Active_ind3');
ROM_Subject2_impairedR_Free = load('ROM_Subject2_impairedR_Free');
ROM_Subject2_impairedR_Passive_ind = load('ROM_Subject2_impairedR_Passive_ind');
ROM_Subject2_impairedR_Passive_ind2 = load('ROM_Subject2_impairedR_Passive_ind2');

ROM_Subject3_healthyL_Active_ind = load('ROM_Subject3_healthyL_Active_ind'); 
ROM_Subject3_healthyL_Free = load('ROM_Subject3_healthyL_Free');
ROM_Subject3_healthyL_Passive_ind = load('ROM_Subject3_healthyL_Passive_ind');
ROM_Subject3_impairedR_Active_ind = load('ROM_Subject3_impairedR_Active_ind'); 
ROM_Subject3_impairedR_Free = load('ROM_Subject3_impairedR_Free');
ROM_Subject3_impairedR_Passive_ind = load('ROM_Subject3_impairedR_Passive_ind');

ROM_Subject0_healthyR_Active   = [ROM_Subject0_healthyR_Active_ind.rom; ROM_Subject0_healthyR_Active_indWrPS.rom;...
                                  ROM_Subject0_healthyR_Free.rom];
ROM_Subject0_healthyR_Passive  = [ROM_Subject0_healthyR_Active; ROM_Subject0_healthyR_Passive_ind.rom];
ROM_Subject0_impairedR_Active  = [ROM_Subject0_impairedR_Active_ind.rom];
ROM_Subject0_impairedR_Passive = [ROM_Subject0_impairedR_Active; ROM_Subject0_impairedR_Passive_ind.rom];

ROM_Subject1_healthyL_Active   = [ROM_Subject1_healthyL_Active_ind.rom; ROM_Subject1_healthyL_Free.rom];
ROM_Subject1_healthyL_Passive  = [ROM_Subject1_healthyL_Active; ROM_Subject1_healthyL_Passive_ind.rom];
ROM_Subject1_impairedR_Active  = [ROM_Subject1_impairedR_Active_ind.rom; ROM_Subject1_impairedR_Free.rom];
ROM_Subject1_impairedR_Passive = [ROM_Subject1_impairedR_Active; ROM_Subject1_impairedR_Passive_ind.rom];

ROM_Subject2_healthyL_Active   = [ROM_Subject2_healthyL_Active_ind.rom; ROM_Subject2_healthyL_Free.rom];
ROM_Subject2_healthyL_Passive  = [ROM_Subject2_healthyL_Active; ROM_Subject2_healthyL_Passive_ind.rom];
ROM_Subject2_impairedR_Active  = [ROM_Subject2_impairedR_Active_ind1.rom; ROM_Subject2_impairedR_Active_ind3.rom;...
                                  ROM_Subject2_impairedR_Free.rom];
ROM_Subject2_impairedR_Passive = [ROM_Subject2_impairedR_Active; ROM_Subject2_impairedR_Passive_ind.rom;...
                                  ROM_Subject2_impairedR_Passive_ind2.rom];

ROM_Subject3_healthyL_Active   = [ROM_Subject3_healthyL_Active_ind.rom; ROM_Subject3_healthyL_Free.rom];
ROM_Subject3_healthyL_Passive  = [ROM_Subject3_healthyL_Active; ROM_Subject3_healthyL_Passive_ind.rom];
ROM_Subject3_impairedR_Active  = [ROM_Subject3_impairedR_Active_ind.rom; ROM_Subject3_impairedR_Free.rom];
ROM_Subject3_impairedR_Passive = [ROM_Subject3_impairedR_Active; ROM_Subject3_impairedR_Passive_ind.rom];


path = '.\data\solved_angles\2023-04-01';

save(fullfile(path, 'ROM_Subject0_healthyR_Active'),'ROM_Subject0_healthyR_Active');
save(fullfile(path, 'ROM_Subject0_healthyR_Passive'),'ROM_Subject0_healthyR_Passive');
save(fullfile(path, 'ROM_Subject0_impairedR_Active'),'ROM_Subject0_impairedR_Active');
save(fullfile(path, 'ROM_Subject0_impairedR_Passive'),'ROM_Subject0_impairedR_Passive');
save(fullfile(path, 'ROM_Subject1_healthyL_Active'),'ROM_Subject1_healthyL_Active');
save(fullfile(path, 'ROM_Subject1_healthyL_Passive'),'ROM_Subject1_healthyL_Passive');
save(fullfile(path, 'ROM_Subject1_impairedR_Active'),'ROM_Subject1_impairedR_Active');
save(fullfile(path, 'ROM_Subject1_impairedR_Passive'),'ROM_Subject1_impairedR_Passive');
save(fullfile(path, 'ROM_Subject2_healthyL_Active'),'ROM_Subject2_healthyL_Active');
save(fullfile(path, 'ROM_Subject2_healthyL_Passive'),'ROM_Subject2_healthyL_Passive');
save(fullfile(path, 'ROM_Subject2_impairedR_Active'),'ROM_Subject2_impairedR_Active');
save(fullfile(path, 'ROM_Subject2_impairedR_Passive'),'ROM_Subject2_impairedR_Passive');
save(fullfile(path, 'ROM_Subject3_healthyL_Active'),'ROM_Subject3_healthyL_Active');
save(fullfile(path, 'ROM_Subject3_healthyL_Passive'),'ROM_Subject3_healthyL_Passive');
save(fullfile(path, 'ROM_Subject3_impairedR_Active'),'ROM_Subject3_impairedR_Active');
save(fullfile(path, 'ROM_Subject3_impairedR_Passive'),'ROM_Subject3_impairedR_Passive');


