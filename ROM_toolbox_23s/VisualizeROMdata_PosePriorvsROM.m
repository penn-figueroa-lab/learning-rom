
clc, clear, close all
addpath (genpath('.\'))

load('.\data\ROM_cl_PosePrior\Subject3_activeL_PPclassified.mat');

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
saveas(gcf,fullfile(figurepath,'PPvsSubject3_L1.jpeg'));

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
saveas(gcf,fullfile(figurepath,'PPvsSubject3_L2.jpeg'));

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
saveas(gcf,fullfile(figurepath,'PPvsSubject3_L3.jpeg'));