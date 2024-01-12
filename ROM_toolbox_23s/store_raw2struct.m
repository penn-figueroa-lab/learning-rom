% % % %  ----------------                                           % % % % 
% % % %  https://github.com/penn-figueroa-lab/learning-rom          % % % % 
% % % %  Shafagh Keyvanian: shkey@seas.upenn.edu                    % % % %
% % % %  ----------------                                           % % % %                                                             % % % %


% % 1_ Converts Motive export .csv to struck with time,bones,markers % %
% % % %  Input: OptiTrack data - Motive exported .csv file       % % % %
% % % %  Skeleton: Conventional Upper (27 Markers) - 43 Bones    % % % %
% % % %  Gaps manually filled with "Linear Interpolation"        % % % %
% % % %  Export: Bones- position & quaternion, Markers- position % % % %
% % % %  Output: skl struct file. Fields: time, bones, markers   % % % %
% % % %  saves .mat struct file to folder: edited_exports\date   % % % %
% % % %  File name: 1st-3rd word of take name, folder: Subject   % % % %
% % % %  bones fields: rows=frames, col=(quat(x y z w) pos[x y z]) % % % 

clc, clear, close all
addpath '.\functions';

% % % % Import .csv File % % % % % % % % % % % % % % % % % % % % % % % %
addpath '.\data\raw_exports\23-04-01\Subject2';
csvfile = 'Subject2 Passive L 2023-04-01';
% NumBones = 13;  
NumBones = 43;  % with fingers
NumMarkers = 27;

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

rawSeg = readcell(csvfile);      % readcell to keep string Data
rawSeg (:,[1,2]) = [];
Track = strsplit(char(rawSeg(1,2)));        % Track Name
header = erase (rawSeg(3,:),"Skeleton:");   % Bones Names

raw = readmatrix(csvfile);       % readmatrix to use cleanData function
raw ([1,2,3,4,5,6], : ) = [];

markerColumn = NumBones*7 +1;
% [dataCleaned, tol, dataPercent] = cleanData (raw , markerColumn);  % Remove similar data

t = raw (:,2) - raw (1,2);
raw (:,[1,2]) = [];

skl = struct;
skl.time = t;

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

% Store the Arm Struct

folderPath = '.\data\edited_exports\2023-04-01';
folder_name = char(Track(1,1));
path = fullfile(folderPath, folder_name);
if ~exist(path, 'dir')
    mkdir(path);
end
name = string(Track(1,1)) + "_" + string(Track(1,2)) + string(Track(1,3))
file = fullfile(path, name);
save(file,'skl');
