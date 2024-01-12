clc, clear, close all
addpath (genpath('.\'))

% This script shows how to use the isvalid function, to see if a 3D pose
% satisfies the joint-angle limits or not. The input to this function is a
% 3-by-17 matrix consisting of 3D coordiantes of the joints and output is
% 16 dimensional binary vector telling whether the corresponding bone is 
% valid or not. Please see readme to know how the bones and joints are 
% defined in the 3D pose
%
% copyright: Ijaz Akhter, MPI Tuebingen
% May 20, 2015

prtName = {'back-bone', 'R-shldr', 'R-Uarm', 'R-Larm', 'L-shldr', 'L-Uarm', 'L-Larm', 'head', ...
    'R-hip', 'R-Uleg', 'R-Lleg', 'R-feet', 'L-hip', 'L-Uleg', 'L-Lleg', 'L-feet'}; % the bones in the 3D pose
N = length(prtName);          % # of bones  (= 16)

% Testing the isvalid function with a valid test pose
load('testPose.mat')        % load a testPose, S1 (3-by-17 matrix) and the connectivity, edges (16-by-2 matrix)

% flags = isvalid(S1)         % flags is a 16 dimensional binary vector telling which of the bones are valid
%all the falgs should be one

% % load all ROM arrays % %
load('.\data\edited_exports\2023-04-01\Subject0\Subject0_healthyR_Active_ind.mat');
skl = rmfield( skl , "time" );
skl_test1 = skl;
load('.\data\edited_exports\2023-04-01\Subject0\Subject0_healthyR_Active_indWrPS.mat');
skl = rmfield( skl , "time" );
skl_test = skl;
for bones = fieldnames(skl)'
    skl_test.(bones{1}) = [skl_test1.(bones{1});skl_test.(bones{1})];
end
load('.\data\edited_exports\2023-04-01\Subject0\Subject0_healthyR_Free.mat');
skl = rmfield( skl , "time" );
for bones = fieldnames(skl)'
    skl.(bones{1}) = [skl_test.(bones{1});skl.(bones{1})];
end

hip = skl.Skeleton(:,1:3);
for bones = fieldnames(skl)'
    skl.(bones{1})(:,1:3) = (skl.(bones{1})(:,1:3) - hip)/1000;
end
pose([1,3,2],1,:) = (skl.RShoulder(:,1:3)'+skl.LShoulder(:,1:3)')/2;
pose([1,3,2],2,:) = skl.RUArm(:,1:3)';
pose([1,3,2],3,:) = skl.RFArm(:,1:3)';
pose([1,3,2],4,:) = skl.RHand(:,1:3)';
pose([1,3,2],5,:) = skl.LUArm(:,1:3)';
pose([1,3,2],6,:) = skl.LFArm(:,1:3)';
pose([1,3,2],7,:) = skl.LHand(:,1:3)';
pose([1,3,2],8,:) = (skl.RBHD(:,1:3)'+skl.RFHD(:,1:3)'+skl.LBHD(:,1:3)'+skl.LFHD(:,1:3)')/4;

for i=1:size(pose,3)
pose(1:3, 9,i) = [-0.932084722327057,-1.49660989775842,2.26144598019409]';
pose(1:3,10,i) = [-2.12761783763220,-7.32061213332881,2.57734114014413]';
pose(1:3,11,i) = [-4.84750356223436,-14.8330334223518,3.29252650446515]';
pose(1:3,12,i) = [-6.80811643346082,-15.2717101598622,3.29332189648304]';
pose(1:3,13,i) = [-1.26403563611755,-1.67375095663903,-1.67375095663903]';
pose(1:3,14,i) = [-0.513231128175099,-7.74714200478147,-1.59867478562472]';
pose(1:3,15,i) = [2.17131931398836,-14.9228616101032,-2.82554185612631]';
pose(1:3,16,i) = [2.85223445693671,-16.0829526630915,-1.77172593826227]';
end

for i=1:size(pose,3)
pose(1:3, 9,i) = [-0.15  -0.1     0]';
pose(1:3,10,i) = [-0.15  -0.7     0]';
pose(1:3,11,i) = [-0.15  -1.4     0]';
pose(1:3,12,i) = [-0.15  -1.4  -0.2]';
pose(1:3,13,i) = [0.15   -0.1     0]';
pose(1:3,14,i) = [0.15   -0.7     0]';
pose(1:3,15,i) = [0.15   -1.4     0]';
pose(1:3,16,i) = [0.15   -1.4  -0.2]';
end

fr = 1000;
figure
scatter3 (pose(1,9:16,fr),-pose(3,9:16,fr),pose(2,9:16,fr))
hold on
scatter3 (0,0,0,"filled",'k')
scatter3 (pose(1,1:8,fr),-pose(3,1:8,fr),pose(2,1:8,fr),"filled")
axis equal

S1(1:3,2:17) = pose(1:3,1:16,fr);
flags = isvalid(S1)         % flags is a 16 dimensional binary vector telling which of the bones are valid
%all the falgs should be one
sum(flags(2:4))

%%
validInd = [];
invalidInd = [];
invalidBones = [];
for i=1:size(pose,3)
    i 
    Si(1:3,2:17) = pose(1:3,1:16,i);
    flags_i = isvalid(Si);
    if sum(flags_i(2:4)) == 3
        validInd = [validInd, i];
    else
        invalidInd = [invalidInd, i];
        invalidBones = [invalidBones;[i,flags_i(2:4)]];        % the invalid bones
    end
end

%% Store the workspace

load('.\data\solved_angles\2023-04-01\ROM_Subject0_healthyR_Active.mat');
validRoM = ROM_Subject0_healthyR_Active(validInd,:);
invalidRoM = ROM_Subject0_healthyR_Active(invalidInd,:);
FN = length(invalidRoM)/length(ROM_Subject0_healthyR_Active) * 100;

folderPath = '.\data';
folder_name = "ROM_cl_PosePrior";
path = fullfile(folderPath, folder_name);
if ~exist(path, 'dir')
    mkdir(path);
end
name = "Subject0_activeHealthyR_PPclassified";
file = fullfile(path, name);
save (file, "skl", "ROM_Subject0_healthyR_Active", "FN", "validRoM", "invalidRoM", ...
    "invalidBones", "validInd", "invalidInd", "pose", "edges", "prtName"); 

%% Check the angles by the indeces

figurepath = '.\figures\Other datasets\PosePriorvsROM\';
figtitle = ['RoM data classified by PosePrior: valid (blue) vs. invalid (red) ~~ False negative = ', num2str(round(FN,1)), '%'];

test1 = validRoM;
test2 = invalidRoM;

figure('Position', get(0, 'Screensize'))
t = tiledlayout(2,3);
title (t, figtitle)
nexttile
scatter (test1(:,2),test1(:,3),'o','filled');
hold on
scatter (test2(:,2),test2(:,3),'r.','SizeData',80);
xlabel('Shoulder AA')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,1),test1(:,2),'o','filled');
hold on
scatter (test2(:,1),test2(:,2),'r.','SizeData',80);
xlabel('Shoulder Rot')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,1),test1(:,3),'o','filled');
hold on
scatter (test2(:,1),test2(:,3),'r.','SizeData',80);
xlabel('Shoulder Rot')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,4),test1(:,2),'o','filled');
hold on
scatter (test2(:,4),test2(:,2),'r.','SizeData',80);
xlabel('Elbow FE')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,4),test1(:,3),'o','filled');
hold on
scatter (test2(:,4),test2(:,3),'r.','SizeData',80);
xlabel('Elbow FE')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,4),test1(:,1),'o','filled');
hold on
scatter (test2(:,4),test2(:,1),'r.','SizeData',80);
xlabel('Elbow FE')
ylabel('Shoulder Rot')
saveas(gcf,fullfile(figurepath,'PPvsSubject0_healthyR1.jpeg'));

figure('Position', get(0, 'Screensize'))
t = tiledlayout(2,3);
title (t, figtitle)
nexttile
scatter (test1(:,6),test1(:,2),'o');
hold on
scatter (test2(:,6),test2(:,2),'r.','SizeData',80);
xlabel('Wrist FE')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,6),test1(:,3),'o');
hold on
scatter (test2(:,6),test2(:,3),'r.','SizeData',80);
xlabel('Wrist FE')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,6),test1(:,1),'o');
hold on
scatter (test2(:,6),test2(:,1),'r.','SizeData',80);
xlabel('Wrist FE')
ylabel('Shoulder Rot')
nexttile
scatter (test1(:,7),test1(:,2),'o');
hold on
scatter (test2(:,7),test2(:,2),'r.','SizeData',80);
xlabel('Wrist Dev')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,7),test1(:,3),'o');
hold on
scatter (test2(:,7),test2(:,3),'r.','SizeData',80);
xlabel('Wrist Dev')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,7),test1(:,1),'o');
hold on
scatter (test2(:,7),test2(:,1),'r.','SizeData',80);
xlabel('Wrist Dev')
ylabel('Shoulder Rot')
saveas(gcf,fullfile(figurepath,'PPvsSubject0_healthyR2.jpeg'));

figure('Position', get(0, 'Screensize'))
t = tiledlayout(2,3);
title (t, figtitle)
nexttile
scatter (test1(:,4),test1(:,5),'o');
hold on
scatter (test2(:,4),test2(:,5),'r.','SizeData',80);
xlabel('Elbow FE')
ylabel('Elbow SP')
nexttile
scatter (test1(:,4),test1(:,6),'o');
hold on
scatter (test2(:,4),test2(:,6),'r.','SizeData',80);
xlabel('Elbow FE')
ylabel('Wrist FE')
nexttile
scatter (test1(:,4),test1(:,7),'o');
hold on
scatter (test2(:,4),test2(:,7),'r.','SizeData',80);
xlabel('Elbow FE')
ylabel('Wrist Dev')
nexttile
scatter (test1(:,5),test1(:,6),'o');
hold on
scatter (test2(:,5),test2(:,6),'r.','SizeData',80);
xlabel('Elbow PS')
ylabel('Wrist FE')
nexttile
scatter (test1(:,5),test1(:,7),'o');
hold on
scatter (test2(:,5),test2(:,7),'r.','SizeData',80);
xlabel('Elbow PS')
ylabel('Wrist Dev')
nexttile
scatter (test1(:,6),test1(:,7),'o');
hold on
scatter (test2(:,6),test2(:,7),'r.','SizeData',80);
xlabel('Wrist FE')
ylabel('Wrist Dev')
saveas(gcf,fullfile(figurepath,'PPvsSubject0_healthyR3.jpeg'));