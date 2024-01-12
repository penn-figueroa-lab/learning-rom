
clc, clear, close all
addpath (genpath('.\'))

% HJCT
load ("HJCT_arm_left.mat")

ind0 = find(qTrain_ba(:,5)==0);
invalidArm = qTrain_ba(ind0,:);
ind1 = find(qTrain_ba(:,5)==1);
validArm = qTrain_ba(ind1,:);

validArm = validArm(:,[3,1,2,4]) * 180/pi;
invalidArm = invalidArm(:,[3,1,2,4]) * 180/pi;
validArm(:,2:3) = -validArm(:,2:3);
invalidArm(:,2:3) = -invalidArm(:,2:3);

% ROM data classified by HJCT
load ("HJCT_subject3_arm_left.mat")

ind0_test = find(qTrain_ba_RoM(:,5)==0);
invalidRoM = qTrain_ba_RoM(ind0_test,:);
ind1_test = find(qTrain_ba_RoM(:,5)==1);
validRoM = qTrain_ba_RoM(ind1_test,:);

validRoM = validRoM(:,[3,1,2,4]) * 180/pi;
invalidRoM = invalidRoM(:,[3,1,2,4]) * 180/pi;
validRoM(:,2:3) = -validRoM(:,2:3);
invalidRoM(:,2:3) = -invalidRoM(:,2:3);
FN = length(ind0_test)/length(qTrain_ba_RoM) * 100;


% Visualize - Valid vs. Invalid
% ShRot, ShAA, ShFE, ElFE 
figtitle = ['HJCT: valid (blue) vs. invalid (red) ~~~~ ROM Healthy_3: valid (green) vs. invalid (black) ~~ False negative = ', num2str(round(FN,1)), '%'];
figurepath = '.\figures\Other datasets\HJCTvsROM\';

test1 = validArm;
test2 = invalidArm;
test3 = validRoM;
test4 = invalidRoM;

figure('Position', get(0, 'Screensize'))
t = tiledlayout(2,3);
title(t, figtitle, 'FontSize', 14)
nexttile
scatter (test3(:,2),test3(:,3),'g*');
hold on
scatter (test4(:,2),test4(:,3),'k*');
scatter (test1(:,2),test1(:,3),'b.','SizeData',100);
scatter (test2(:,2),test2(:,3),'r.','SizeData',80);
axis equal
xlabel('Shoulder AA')
ylabel('Shoulder FE')
nexttile
scatter (test3(:,1),test3(:,2),'g*');
hold on
scatter (test4(:,1),test4(:,2),'k*');
scatter (test1(:,1),test1(:,2),'b.','SizeData',100);
scatter (test2(:,1),test2(:,2),'r.','SizeData',80);
axis equal
xlabel('Shoulder Rot')
ylabel('Shoulder AA')
nexttile
scatter (test3(:,1),test3(:,3),'g*');
hold on
scatter (test4(:,1),test4(:,3),'k*');
scatter (test1(:,1),test1(:,3),'b.','SizeData',100);
scatter (test2(:,1),test2(:,3),'r.','SizeData',80);
axis equal
xlabel('Shoulder Rot')
ylabel('Shoulder FE')
nexttile
scatter (test3(:,4),test3(:,2),'g*');
hold on
scatter (test4(:,4),test4(:,2),'k*');
scatter (test1(:,4),test1(:,2),'b.','SizeData',100);
scatter (test2(:,4),test2(:,2),'r.','SizeData',80);
axis equal
xlabel('Elbow FE')
ylabel('Shoulder AA')
nexttile
scatter (test3(:,4),test3(:,3),'g*');
hold on
scatter (test4(:,4),test4(:,3),'k*');
scatter (test1(:,4),test1(:,3),'b.','SizeData',100);
scatter (test2(:,4),test2(:,3),'r.','SizeData',80);
axis equal
xlabel('Elbow FE')
ylabel('Shoulder FE')
nexttile
scatter (test3(:,4),test3(:,1),'g*');
hold on
scatter (test4(:,4),test4(:,1),'k*');
scatter (test1(:,4),test1(:,1),'b.','SizeData',100);
scatter (test2(:,4),test2(:,1),'r.','SizeData',80);
axis equal
xlabel('Elbow FE')
ylabel('Shoulder Rot')

saveas(gcf,fullfile(figurepath,'HJCTvsSubject3.jpeg'));