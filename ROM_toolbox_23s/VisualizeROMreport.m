clc, clear, close all
addpath (genpath('.\'))

% % load all ROM arrays % %
romFiles = dir(fullfile('.\data\solved_angles\2023-04-01\cleaned\','*.mat'));
load (romFiles(1).name)
load (romFiles(2).name)
subject0_healthy = activeL;
subject0_impaired = activeR;
load (romFiles(3).name)
load (romFiles(4).name)
subject1_healthy = activeL;
subject1_impaired = activeR;
load (romFiles(5).name)
load (romFiles(6).name)
subject2_healthy = activeL;
subject2_impaired = activeR;
load (romFiles(7).name)
load (romFiles(8).name)
subject3_healthy = activeL;
subject3_impaired = activeR;

%% % % visualize the ROM
test1 = subject3_healthy;
test2 = subject0_impaired;
figtitle = 'Subject3 healthy: 2d visualization for 7DoF pairs';

figure 
t = tiledlayout(3,7);
title (t, figtitle)
nexttile
scatter (test1(:,2),test1(:,3),'.');
xlabel('Shoulder AA')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,1),test1(:,2),'.');
xlabel('Shoulder Rot')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,1),test1(:,3),'.');
xlabel('Shoulder Rot')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,4),test1(:,2),'.');
xlabel('Elbow FE')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,4),test1(:,3),'.');
xlabel('Elbow FE')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,4),test1(:,1),'.');
xlabel('Elbow FE')
ylabel('Shoulder Rot')
nexttile
scatter (test1(:,5),test1(:,2),'.');
xlabel('Elbow PS')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,5),test1(:,3),'.');
xlabel('Elbow PS')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,5),test1(:,1),'.');
xlabel('Elbow PS')
ylabel('Shoulder Rot')
nexttile
scatter (test1(:,6),test1(:,2),'.');
xlabel('Wrist FE')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,6),test1(:,3),'.');
xlabel('Wrist FE')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,6),test1(:,1),'.');
xlabel('Wrist FE')
ylabel('Shoulder Rot')
nexttile
scatter (test1(:,7),test1(:,2),'.');
xlabel('Wrist Dev')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,7),test1(:,3),'.');
xlabel('Wrist Dev')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,7),test1(:,1),'.');
xlabel('Wrist Dev')
ylabel('Shoulder Rot')
nexttile
scatter (test1(:,4),test1(:,5),'.');
xlabel('Elbow FE')
ylabel('Elbow SP')
nexttile
scatter (test1(:,4),test1(:,6),'.');
xlabel('Elbow FE')
ylabel('Wrist FE')
nexttile
scatter (test1(:,4),test1(:,7),'.');
xlabel('Elbow FE')
ylabel('Wrist Dev')
nexttile
scatter (test1(:,5),test1(:,6),'.');
xlabel('Elbow PS')
ylabel('Wrist FE')
nexttile
scatter (test1(:,5),test1(:,7),'.');
xlabel('Elbow PS')
ylabel('Wrist Dev')
nexttile
scatter (test1(:,6),test1(:,7),'.');
xlabel('Wrist FE')
ylabel('Wrist Dev')

%% % % visualize the ROM
test1 = subject0_healthy;
test2 = subject0_impaired;
figtitle = 'Healthy and impaired ROM for different levels of disability';

figure
t = tiledlayout(4,6);
title (t, figtitle)
nexttile
scatter (subject0_healthy(:,2),subject0_healthy(:,3),'o');
hold on
scatter (subject0_impaired(:,2),subject0_impaired(:,3),'ro','SizeData',8);
xlabel('Shoulder AA')
ylabel('Shoulder FE')
nexttile
scatter (subject0_healthy(:,1),subject0_healthy(:,2),'o');
hold on
scatter (subject0_impaired(:,1),subject0_impaired(:,2),'ro','SizeData',8);
xlabel('Shoulder Rot')
ylabel('Shoulder AA')
nexttile
scatter (subject0_healthy(:,1),subject0_healthy(:,3),'o');
hold on
scatter (subject0_impaired(:,1),subject0_impaired(:,3),'ro','SizeData',8);
xlabel('Shoulder Rot')
ylabel('Shoulder FE')
nexttile
scatter (subject0_healthy(:,4),subject0_healthy(:,2),'o');
hold on
scatter (subject0_impaired(:,4),subject0_impaired(:,2),'ro','SizeData',8);
xlabel('Elbow FE')
ylabel('Shoulder AA')
nexttile
scatter (subject0_healthy(:,4),subject0_healthy(:,3),'o');
hold on
scatter (subject0_impaired(:,4),subject0_impaired(:,3),'ro','SizeData',8);
xlabel('Elbow FE')
ylabel('Shoulder FE')
nexttile
scatter (subject0_healthy(:,4),subject0_healthy(:,1),'o');
hold on
scatter (subject0_impaired(:,4),subject0_impaired(:,1),'ro','SizeData',8);
xlabel('Elbow FE')
ylabel('Shoulder Rot')

nexttile
scatter (subject1_healthy(:,2),subject1_healthy(:,3),'o');
hold on
scatter (subject1_impaired(:,2),subject1_impaired(:,3),'ro','SizeData',8);
xlabel('Shoulder AA')
ylabel('Shoulder FE')
nexttile
scatter (subject1_healthy(:,1),subject1_healthy(:,2),'o');
hold on
scatter (subject1_impaired(:,1),subject1_impaired(:,2),'ro','SizeData',8);
xlabel('Shoulder Rot')
ylabel('Shoulder AA')
nexttile
scatter (subject1_healthy(:,1),subject1_healthy(:,3),'o');
hold on
scatter (subject1_impaired(:,1),subject1_impaired(:,3),'ro','SizeData',8);
xlabel('Shoulder Rot')
ylabel('Shoulder FE')
nexttile
scatter (subject1_healthy(:,4),subject1_healthy(:,2),'o');
hold on
scatter (subject1_impaired(:,4),subject1_impaired(:,2),'ro','SizeData',8);
xlabel('Elbow FE')
ylabel('Shoulder AA')
nexttile
scatter (subject1_healthy(:,4),subject1_healthy(:,3),'o');
hold on
scatter (subject1_impaired(:,4),subject1_impaired(:,3),'ro','SizeData',8);
xlabel('Elbow FE')
ylabel('Shoulder FE')
nexttile
scatter (subject1_healthy(:,4),subject1_healthy(:,1),'o');
hold on
scatter (subject1_impaired(:,4),subject1_impaired(:,1),'ro','SizeData',8);
xlabel('Elbow FE')
ylabel('Shoulder Rot')

nexttile
scatter (subject2_healthy(:,2),subject2_healthy(:,3),'o');
hold on
scatter (subject2_impaired(:,2),subject2_impaired(:,3),'ro','SizeData',8);
xlabel('Shoulder AA')
ylabel('Shoulder FE')
nexttile
scatter (subject2_healthy(:,1),subject2_healthy(:,2),'o');
hold on
scatter (subject2_impaired(:,1),subject2_impaired(:,2),'ro','SizeData',8);
xlabel('Shoulder Rot')
ylabel('Shoulder AA')
nexttile
scatter (subject2_healthy(:,1),subject2_healthy(:,3),'o');
hold on
scatter (subject2_impaired(:,1),subject2_impaired(:,3),'ro','SizeData',8);
xlabel('Shoulder Rot')
ylabel('Shoulder FE')
nexttile
scatter (subject2_healthy(:,4),subject2_healthy(:,2),'o');
hold on
scatter (subject2_impaired(:,4),subject2_impaired(:,2),'ro','SizeData',8);
xlabel('Elbow FE')
ylabel('Shoulder AA')
nexttile
scatter (subject2_healthy(:,4),subject2_healthy(:,3),'o');
hold on
scatter (subject2_impaired(:,4),subject2_impaired(:,3),'ro','SizeData',8);
xlabel('Elbow FE')
ylabel('Shoulder FE')
nexttile
scatter (subject2_healthy(:,4),subject2_healthy(:,1),'o');
hold on
scatter (subject2_impaired(:,4),subject2_impaired(:,1),'ro','SizeData',8);
xlabel('Elbow FE')
ylabel('Shoulder Rot')

nexttile
scatter (subject3_healthy(:,2),subject3_healthy(:,3),'o');
hold on
scatter (subject3_impaired(:,2),subject3_impaired(:,3),'ro','SizeData',8);
xlabel('Shoulder AA')
ylabel('Shoulder FE')
nexttile
scatter (subject3_healthy(:,1),subject3_healthy(:,2),'o');
hold on
scatter (subject3_impaired(:,1),subject3_impaired(:,2),'ro','SizeData',8);
xlabel('Shoulder Rot')
ylabel('Shoulder AA')
nexttile
scatter (subject3_healthy(:,1),subject3_healthy(:,3),'o');
hold on
scatter (subject3_impaired(:,1),subject3_impaired(:,3),'ro','SizeData',8);
xlabel('Shoulder Rot')
ylabel('Shoulder FE')
nexttile
scatter (subject3_healthy(:,4),subject3_healthy(:,2),'o');
hold on
scatter (subject3_impaired(:,4),subject3_impaired(:,2),'ro','SizeData',8);
xlabel('Elbow FE')
ylabel('Shoulder AA')
nexttile
scatter (subject3_healthy(:,4),subject3_healthy(:,3),'o');
hold on
scatter (subject3_impaired(:,4),subject3_impaired(:,3),'ro','SizeData',8);
xlabel('Elbow FE')
ylabel('Shoulder FE')
nexttile
scatter (subject3_healthy(:,4),subject3_healthy(:,1),'o');
hold on
scatter (subject3_impaired(:,4),subject3_impaired(:,1),'ro','SizeData',8);
xlabel('Elbow FE')
ylabel('Shoulder Rot')