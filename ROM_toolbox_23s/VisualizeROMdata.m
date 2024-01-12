% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % %                                                             % % % %
% % % %  Load ROM arrays and use figROM function to compare         % % % %
% % % %                                                             % % % %
% % % %  7DoF order : ShRot, ShAA, ShFE, ElFE, ElPS, WrFE, WrDev    % % % %
% % % %                                                             % % % %
% % % %  ROM files from: ROM_Subject1#_(healthy/impaired)(L/R)_test  % % % %
% % % %  path: .\data\solved_angles\date\Subject1# --                % % % %
% % % %                                                             % % % %
% % % %  saves figures:                                             % % % %
% % % %  .\results\ROM_dataPoints\ROM_Subject1#_test vs.test.jpeg    % % % %
% % % %                                                             % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

clc, clear, close all
addpath (genpath('.\'))

% % load ROM arrays % %
date    = '2023-04-01';
romFiles = dir(fullfile('.\data\solved_angles\',date,'*.mat'));

for k = 1:numel(romFiles)
    load (romFiles(k).name)
end



%% Visualize - Impaired: Passive vs. Active
% ShRot, ShAA, ShFE, ElFE, ElPS, WrFE, WrDev 

% test1 = ROM_Subject1_impairedR_Passive;
% test2 = ROM_Subject1_impairedR_Active;
% figtitle = 'Subject1 Impaired Arm Passive(blue) vs. Active (red)';
% figurepath = '.\figures\RoM data points\Impaired Passive vs. Active\';

test1 = ROM_Subject1_healthyL_Active;
test2 = ROM_Subject1_impairedR_Active;
figtitle = 'Subject1 Healthy Arm (blue) vs. Impaired Arm (red)';
figurepath = '.\figures\RoM data points\Healthy vs. Impaired\';

figure
t = tiledlayout(3,3);
title (t, figtitle)
nexttile
scatter (test1(:,2),test1(:,3),'o');
hold on
scatter (test2(:,2),test2(:,3),'r.');
xlabel('Shoulder AA')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,1),test1(:,2),'o');
hold on
scatter (test2(:,1),test2(:,2),'r.');
xlabel('Shoulder Rot')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,1),test1(:,3),'o');
hold on
scatter (test2(:,1),test2(:,3),'r.');
xlabel('Shoulder Rot')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,4),test1(:,2),'o');
hold on
scatter (test2(:,4),test2(:,2),'r.');
xlabel('Elbow FE')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,4),test1(:,3),'o');
hold on
scatter (test2(:,4),test2(:,3),'r.');
xlabel('Elbow FE')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,4),test1(:,1),'o');
hold on
scatter (test2(:,4),test2(:,1),'r.');
xlabel('Elbow FE')
ylabel('Shoulder Rot')
nexttile
scatter (test1(:,5),test1(:,2),'o');
hold on
scatter (test2(:,5),test2(:,2),'r.');
xlabel('Elbow PS')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,5),test1(:,3),'o');
hold on
scatter (test2(:,5),test2(:,3),'r.');
xlabel('Elbow PS')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,5),test1(:,1),'o');
hold on
scatter (test2(:,5),test2(:,1),'r.');
xlabel('Elbow PS')
ylabel('Shoulder Rot')
saveas(gcf,fullfile(figurepath,'Subject1_1.jpeg'));

figure
t = tiledlayout(2,3);
title (t, figtitle)
nexttile
scatter (test1(:,6),test1(:,2),'o');
hold on
scatter (test2(:,6),test2(:,2),'r.');
xlabel('Wrist FE')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,6),test1(:,3),'o');
hold on
scatter (test2(:,6),test2(:,3),'r.');
xlabel('Wrist FE')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,6),test1(:,1),'o');
hold on
scatter (test2(:,6),test2(:,1),'r.');
xlabel('Wrist FE')
ylabel('Shoulder Rot')
nexttile
scatter (test1(:,7),test1(:,2),'o');
hold on
scatter (test2(:,7),test2(:,2),'r.');
xlabel('Wrist Dev')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,7),test1(:,3),'o');
hold on
scatter (test2(:,7),test2(:,3),'r.');
xlabel('Wrist Dev')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,7),test1(:,1),'o');
hold on
scatter (test2(:,7),test2(:,1),'r.');
xlabel('Wrist Dev')
ylabel('Shoulder Rot')
saveas(gcf,fullfile(figurepath,'Subject1_2.jpeg'));

figure
t = tiledlayout(2,3);
title (t, figtitle)
nexttile
scatter (test1(:,4),test1(:,5),'o');
hold on
scatter (test2(:,4),test2(:,5),'r.');
xlabel('Elbow FE')
ylabel('Elbow SP')
nexttile
scatter (test1(:,4),test1(:,6),'o');
hold on
scatter (test2(:,4),test2(:,6),'r.');
xlabel('Elbow FE')
ylabel('Wrist FE')
nexttile
scatter (test1(:,4),test1(:,7),'o');
hold on
scatter (test2(:,4),test2(:,7),'r.');
xlabel('Elbow FE')
ylabel('Wrist Dev')
nexttile
scatter (test1(:,5),test1(:,6),'o');
hold on
scatter (test2(:,5),test2(:,6),'r.');
xlabel('Elbow PS')
ylabel('Wrist FE')
nexttile
scatter (test1(:,5),test1(:,7),'o');
hold on
scatter (test2(:,5),test2(:,7),'r.');
xlabel('Elbow PS')
ylabel('Wrist Dev')
nexttile
scatter (test1(:,6),test1(:,7),'o');
hold on
scatter (test2(:,6),test2(:,7),'r.');
xlabel('Wrist FE')
ylabel('Wrist Dev')
saveas(gcf,fullfile(figurepath,'Subject1_3.jpeg'));


%% Visualize - Right: Active joints (Free & Independent + Passive)

% figure
% tile = tiledlayout(2,3);
% nexttile
% scatter (sklFreeImp.RFArm(:,11),sklFreeImp.RUArm(:,11),'.');
% hold on
% scatter (sklIndImp.RFArm(:,11),sklIndImp.RUArm(:,11),'r.');
% hold on
% scatter (sklPasImp.RFArm(:,11),sklPasImp.RUArm(:,11),'y.');
% xlabel('Elbow FE')
% ylabel('Shoulder Rotation')
% nexttile
% scatter (sklFreeImp.RFArm(:,11),sklFreeImp.RUArm(:,12),'.');
% hold on
% scatter (sklIndImp.RFArm(:,11),sklIndImp.RUArm(:,12),'r.');
% hold on
% scatter (sklPasImp.RFArm(:,11),sklPasImp.RUArm(:,12),'y.');
% xlabel('Elbow FE')
% ylabel('Shoulder AA')
% nexttile
% scatter (sklFreeImp.RFArm(:,11),sklFreeImp.RUArm(:,13),'.');
% hold on
% scatter (sklIndImp.RFArm(:,11),sklIndImp.RUArm(:,13),'r.');
% hold on
% scatter (sklPasImp.RFArm(:,11),sklPasImp.RUArm(:,13),'y.');
% xlabel('Elbow FE')
% ylabel('Shoulder FE')
% 
% nexttile
% scatter (sklFreeImp.RUArm(:,11),sklFreeImp.RUArm(:,12),'.');
% hold on
% scatter (sklIndImp.RUArm(:,11),sklIndImp.RUArm(:,12),'r.');
% hold on
% scatter (sklPasImp.RUArm(:,11),sklPasImp.RUArm(:,12),'y.');
% xlabel('Shoulder Rotation')
% ylabel('Shoulder AA')
% nexttile
% scatter (sklFreeImp.RUArm(:,11),sklFreeImp.RUArm(:,13),'.');
% hold on
% scatter (sklIndImp.RUArm(:,11),sklIndImp.RUArm(:,13),'r.');
% hold on
% scatter (sklPasImp.RUArm(:,11),sklPasImp.RUArm(:,13),'y.');
% xlabel('Shoulder Rotation')
% ylabel('Shoulder FE')
% nexttile
% scatter (sklFreeImp.RUArm(:,12),sklFreeImp.RUArm(:,13),'.');
% hold on
% scatter (sklIndImp.RUArm(:,12),sklIndImp.RUArm(:,13),'r.');
% hold on
% scatter (sklPasImp.RUArm(:,12),sklPasImp.RUArm(:,13),'y.');
% xlabel('Shoulder AA')
% ylabel('Shoulder FE')
% 
% figure
% tile = tiledlayout(2,3);
% nexttile
% scatter (sklFreeImp.RFArm(:,11),sklFreeImp.RFArm(:,13),'.');
% hold on
% scatter (sklIndImp.RFArm(:,11),sklIndImp.RFArm(:,13),'r.');
% hold on
% scatter (sklPasImp.RFArm(:,11),sklPasImp.RFArm(:,13),'y.');
% xlabel('Elbow FE')
% ylabel('Elbow/Wrist PS')
% nexttile
% scatter (sklFreeImp.RFArm(:,11),sklFreeImp.RHand(:,12),'.');
% hold on
% scatter (sklIndImp.RFArm(:,11),sklIndImp.RHand(:,12),'r.');
% hold on
% scatter (sklPasImp.RFArm(:,11),sklPasImp.RHand(:,12),'y.');
% xlabel('Elbow FE')
% ylabel('Wrist FE')
% nexttile
% scatter (sklFreeImp.RFArm(:,11),sklFreeImp.RHand(:,13),'.');
% hold on
% scatter (sklIndImp.RFArm(:,11),sklIndImp.RHand(:,13),'r.');
% hold on
% scatter (sklPasImp.RFArm(:,11),sklPasImp.RHand(:,13),'y.');
% xlabel('Elbow FE')
% ylabel('Wrist Dev')
% 
% nexttile
% scatter (sklFreeImp.RFArm(:,13),sklFreeImp.RUArm(:,11),'.');
% hold on
% scatter (sklIndImp.RFArm(:,13),sklIndImp.RUArm(:,11),'r.');
% hold on
% scatter (sklPasImp.RFArm(:,13),sklPasImp.RUArm(:,11),'y.');
% xlabel('Elbow/Wrist PS')
% ylabel('Shoulder Rot')
% nexttile
% scatter (sklFreeImp.RFArm(:,13),sklFreeImp.RUArm(:,12),'.');
% hold on
% scatter (sklIndImp.RFArm(:,13),sklIndImp.RUArm(:,12),'r.');
% hold on
% scatter (sklPasImp.RFArm(:,13),sklPasImp.RUArm(:,12),'y.');
% xlabel('Elbow/Wrist PS')
% ylabel('Shoulder AA')
% nexttile
% scatter (sklFreeImp.RFArm(:,13),sklFreeImp.RUArm(:,13),'.');
% hold on
% scatter (sklIndImp.RFArm(:,13),sklIndImp.RUArm(:,13),'r.');
% hold on
% scatter (sklPasImp.RFArm(:,13),sklPasImp.RUArm(:,13),'y.');
% xlabel('Elbow/Wrist PS')
% ylabel('Shoulder FE')


