% % % %  ----------------                                           % % % % 
% % % %  https://github.com/penn-figueroa-lab/learning-rom          % % % % 
% % % %  Shafagh Keyvanian: shkey@seas.upenn.edu                    % % % %
% % % %  ----------------                                           % % % %                                                             % % % %

% % 2_ Converts skeleton struck to joints angles and visualize the ROM % %

% % % %  Skeleton: Conventional Upper (27 Markers) - 43 Bones      % % % %
% % % %  Input: Skeleton for each subject in different tests       % % % %
% % % %  calls extractAngMot: cul: angGlobal(8:10) angLocal(11:13) % % % % 
% % % %  Visualize results: all wrt time, eul angles wrt eachother % % % %
% % % %  Store 7DoF angles for each and each test in solved_angles % % % %
% % % %  7DoF order: ShRot, ShAA, ShFE, ElFE, ElPS, WrFE, WrDev    % % % %

clc, clear, close all
addpath '.\functions';
addpath '.\data\edited_exports\2023-04-01\Subject3';

% % % % HEALTHY Arm (Left)

load ('Subject3_healthyL_Free.mat')                     % Load Skeleton for Test:Free
sklFree = skl;
eraseNAN(sklFree);                              % Erase NAN Frames(rows)
Fs=1; sklFree = startFrom(sklFree,Fs);         % Start with Frame Fs, Removes frames before Fs
% Fe=50; skl = endFrame(skl,Fe);                % Keeps only the first Fe frames
tFree = sklFree.time;                           % Store time 
sklFree = extractAngMot (sklFree);              % Extract relative angles

load ('Subject3_healthyL_Active_ind.mat')                   % Load Skeleton for Test:Active-Independent                              
sklInd = skl;
eraseNAN(sklInd);                              
Fs=1; sklInd = startFrom(sklInd,Fs);           
% Fe=50; skl = endFrame(skl,Fe);                
tInd = sklInd.time;                              
sklInd = extractAngMot (sklInd);

load ('Subject3_healthyL_Passive_ind.mat')                  % Load Skeleton for Test:Active-Independent                      
sklPas = skl;
eraseNAN(sklPas);                              
Fs=1; sklPas = startFrom(sklPas,Fs);              
% Fe=50; skl = endFrame(skl,Fe);              
tPas = sklPas.time;                              
sklPas = extractAngMot (sklPas);

% load ('Subject3_healthyL_Reach.mat')                  % Load Skeleton for Test:Reach                      
% sklReach = skl;
% eraseNAN(sklReach);                              
% Fs=1; sklReach = startFrom(sklReach,Fs);              
% % Fe=50; skl = endFrame(skl,Fe);              
% tReach = sklReach.time;                              
% sklReach = extractAngMot (sklReach);


% % % % IMPAIRED ARM (Right)

load ('Subject3_impairedR_Free.mat')                  % Load Skeleton for Test:Free                                
sklFreeImp = skl;
eraseNAN(sklFreeImp);                           
Fs=1; sklFreeImp = startFrom(sklFreeImp,Fs);   
% Fe=50; arm = endFrame(skl,Fe);              
tFreeImp = sklFreeImp.time;                     
sklFreeImp = extractAngMot (sklFreeImp);

load ('Subject3_impairedR_Active_ind.mat')                % Load Skeleton for Test:Active-Independent
sklIndImp = skl;
eraseNAN(sklIndImp);                         
Fs=1; sklIndImp = startFrom(sklIndImp,Fs);   
% Fe=50; arm = endFrame(skl,Fe);             
tIndImp = sklIndImp.time;                
sklIndImp = extractAngMot (sklIndImp);

% load ('Subject3_impairedR_Active_ind3.mat')                % Load Skeleton for Test:Active-Independent
% sklIndImp2 = skl;
% eraseNAN(sklIndImp2);                         
% Fs=1; sklIndImp2 = startFrom(sklIndImp2,Fs);   
% % Fe=50; arm = endFrame(skl,Fe);             
% tIndImp2 = sklIndImp2.time;                
% sklIndImp2 = extractAngMot (sklIndImp2);

load ('Subject3_impairedR_Passive_ind.mat')               % Load Skeleton for Test:Active-Independent
sklPasImp = skl;
eraseNAN(sklPasImp);                           
Fs=1; sklPasImp = startFrom(sklPasImp,Fs);             
% Fe=50; arm = endFrame(skl,Fe);               
tPasImp = sklPasImp.time;                           
sklPasImp = extractAngMot (sklPasImp);

% load ('Subject3_impairedR_Passive_ind2.mat')               % Load Skeleton for Test:Active-Independent
% sklPasImp2 = skl;
% eraseNAN(sklPasImp2);                           
% Fs=1; sklPasImp2 = startFrom(sklPasImp2,Fs);             
% % Fe=50; arm = endFrame(skl,Fe);               
% tPasImp2 = sklPasImp2.time;                           
% sklPasImp2 = extractAngMot (sklPasImp2);

load ('Subject3_impairedR_Reach.mat')                  % Load Skeleton for Test:Reach                      
sklReachImp = skl;
eraseNAN(sklReachImp);                              
Fs=1; sklReachImp = startFrom(sklReachImp,Fs);              
% Fe=50; skl = endFrame(skl,Fe);              
tReachImp = sklReachImp.time;                              
sklReachImp = extractAngMot (sklReachImp);

%% Visualize
% % Figures - Check one test, Joint angles wrt TIME
figAngTime (sklInd,tInd,'l','actind')
figAngTime (sklFree,tFree,'l','actfree')
% figAngTime (sklPas,tPas,'l','pas')
% figAngTime (sklIndImp,tIndImp,'r','actind')
% figAngTime (sklIndImp2,tIndImp2,'r','actind')
figAngTime (sklFreeImp,tFreeImp,'r','actfree')
% figAngTime (sklPasImp,tPasImp,'r','pas')
% figAngTime (sklReach,tReach,'l','act')
% figAngTime (sklReachImp,tReachImp,'r','act')

% % Figures - Check one test, Joint angles wrt EACHOTHER
% figAngRel (sklInd,'l','actind')
% figAngRel (sklFree,'l','actfree')
% figAngRel (sklPas,'l','pas')

% % Figures - ROM (comparing two tests)
% figRoM (sklFreeImp, sklIndImp, 'r')
% figRoM (sklFree, sklInd, 'l')
% figRoM (sklIndImp, sklPasImp, 'r')

% figRoM (sklPasImp, sklActImp, 'r')
% figRoM (sklReach, sklReach, 'l')

%% % % % Store solved 7DoF RoM data
% ShRot, ShAA, ShFE, ElFE, ElPS, WrFE, WrDev 

freeL(:,1:7) = [sklFree.LUArm(:,11:13), sklFree.LFArm(:,11), sklFree.LFArm(:,13), sklFree.LHand(:,11:12)]; 
aindL(:,1:7) = [sklInd.LUArm(:,11:13), sklInd.LFArm(:,11), sklInd.LFArm(:,13), sklInd.LHand(:,11:12)]; 
% activeL (:,1:7) = [sklAct.LUArm(:,11:13), sklAct.LFArm(:,11), sklAct.LFArm(:,13), sklAct.LHand(:,11:12)]; 
passL(:,1:7) = [sklPas.LUArm(:,11:13), sklPas.LFArm(:,11), sklPas.LFArm(:,13), sklPas.LHand(:,11:12)]; 
% ReachL(:,1:7) = [sklReach.LUArm(:,11:13), sklReach.LFArm(:,11), sklReach.LFArm(:,13), sklReach.LHand(:,11:12)]; 

freeR(:,1:7) = [sklFreeImp.RUArm(:,11:13), sklFreeImp.RFArm(:,11), sklFreeImp.RFArm(:,13), sklFreeImp.RHand(:,11:12)]; 
aindR(:,1:7) = [sklIndImp.RUArm(:,11:13), sklIndImp.RFArm(:,11), sklIndImp.RFArm(:,13), sklIndImp.RHand(:,11:12)]; 
% aindR2(:,1:7) = [sklIndImp2.RUArm(:,11:13), sklIndImp2.RFArm(:,11), sklIndImp2.RFArm(:,13), sklIndImp2.RHand(:,11:12)]; 
% activeR (:,1:7) = [sklActImp.RUArm(:,11:13), sklActImp.RFArm(:,11), sklActImp.RFArm(:,13), sklActImp.RHand(:,11:12)]; 
passR(:,1:7) = [sklPasImp.RUArm(:,11:13), sklPasImp.RFArm(:,11), sklPasImp.RFArm(:,13), sklPasImp.RHand(:,11:12)]; 
% ReachR(:,1:7) = [sklReachImp.RUArm(:,11:13), sklReachImp.RFArm(:,11), sklReachImp.RFArm(:,13), sklReachImp.RHand(:,11:12)]; 


% freeR ([1000:1130, 1750:1820, 2300:2810],:)= [];
% aindR ([1300:1630, 3100:3500,1800:2200],:) = [];

% % Subject 1
% freeR ([1000:1130, 1750:1820, 2300:2810],:)= [];
% aindR ([1300:1630],:) = [];
% % Subject 2
% freeL (2885:2960,:)= [];
% freeR (2550:3400,:)= [];

activeL = [freeL; aindL];
passiveL = [activeL; passL];
activeR = [freeR; aindR];
passiveR = [activeR; passR];


% folderPath = '.\data\solved_angles';
% folder_name = 'Subject3';
% path = fullfile(folderPath, folder_name);
% if ~exist(path, 'dir')
%     mkdir(path);
% end
% save(fullfile(path, 'ROM_freeL'),'freeL');
% save(fullfile(path, 'ROM_aindL'),'aindL');
% save(fullfile(path, 'ROM_activeL'),'activeL');
% save(fullfile(path, 'ROM_passL'),'passL');
% save(fullfile(path, 'ROM_ReachL'),'ReachL');
% save(fullfile(path, 'ROM_freeR'),'freeR');
% save(fullfile(path, 'ROM_aindR'),'aindR');
% save(fullfile(path, 'ROM_activeR'),'activeR');
% save(fullfile(path, 'ROM_passR'),'passR');
% save(fullfile(path, 'ROM_ReachR'),'ReachR');

% Visualize - Healthy vs. Impaired
% ShRot, ShAA, ShFE, ElFE, ElPS, WrFE, WrDev 

figure
t = tiledlayout(3,3);
title (t, 'Healthy (blue) vs. Impaired (red) - Shoulder & Elbow')
nexttile
scatter (activeL(:,2),activeL(:,3),'.');
hold on
scatter (activeR(:,2),activeR(:,3),'r.');
xlabel('Shoulder AA')
ylabel('Shoulder FE')
nexttile
scatter (activeL(:,1),activeL(:,2),'.');
hold on
scatter (activeR(:,1),activeR(:,2),'r.');
xlabel('Shoulder Rot')
ylabel('Shoulder AA')
nexttile
scatter (activeL(:,1),activeL(:,3),'.');
hold on
scatter (activeR(:,1),activeR(:,3),'r.');
xlabel('Shoulder Rot')
ylabel('Shoulder FE')
nexttile
scatter (activeL(:,4),activeL(:,2),'.');
hold on
scatter (activeR(:,4),activeR(:,2),'r.');
xlabel('Elbow FE')
ylabel('Shoulder AA')
nexttile
scatter (activeL(:,4),activeL(:,3),'.');
hold on
scatter (activeR(:,4),activeR(:,3),'r.');
xlabel('Elbow FE')
ylabel('Shoulder FE')
nexttile
scatter (activeL(:,4),activeL(:,1),'.');
hold on
scatter (activeR(:,4),activeR(:,1),'r.');
xlabel('Elbow FE')
ylabel('Shoulder Rot')
nexttile
scatter (activeL(:,5),activeL(:,2),'.');
hold on
scatter (activeR(:,5),activeR(:,2),'r.');
xlabel('Elbow PS')
ylabel('Shoulder AA')
nexttile
scatter (activeL(:,5),activeL(:,3),'.');
hold on
scatter (activeR(:,5),activeR(:,3),'r.');
xlabel('Elbow PS')
ylabel('Shoulder FE')
nexttile
scatter (activeL(:,5),activeL(:,1),'.');
hold on
scatter (activeR(:,5),activeR(:,1),'r.');
xlabel('Elbow PS')
ylabel('Shoulder Rot')

figure
t = tiledlayout(2,3);
title (t, 'Healthy (blue) vs. Impaired (red) - Shoulder & Elbow')
nexttile
scatter (activeL(:,6),activeL(:,2),'.');
hold on
scatter (activeR(:,6),activeR(:,2),'r.');
xlabel('Wrist FE')
ylabel('Shoulder AA')
nexttile
scatter (activeL(:,6),activeL(:,3),'.');
hold on
scatter (activeR(:,6),activeR(:,3),'r.');
xlabel('Wrist FE')
ylabel('Shoulder FE')
nexttile
scatter (activeL(:,6),activeL(:,1),'.');
hold on
scatter (activeR(:,6),activeR(:,1),'r.');
xlabel('Wrist FE')
ylabel('Shoulder Rot')
nexttile
scatter (activeL(:,7),activeL(:,2),'.');
hold on
scatter (activeR(:,7),activeR(:,2),'r.');
xlabel('Wrist Dev')
ylabel('Shoulder AA')
nexttile
scatter (activeL(:,7),activeL(:,3),'.');
hold on
scatter (activeR(:,7),activeR(:,3),'r.');
xlabel('Wrist Dev')
ylabel('Shoulder FE')
nexttile
scatter (activeL(:,7),activeL(:,1),'.');
hold on
scatter (activeR(:,7),activeR(:,1),'r.');
xlabel('Wrist Dev')
ylabel('Shoulder Rot')

figure
t = tiledlayout(2,3);
title (t, 'Healthy (blue) vs. Impaired (red) - Shoulder & Elbow')
nexttile
scatter (activeL(:,4),activeL(:,5),'.');
hold on
scatter (activeR(:,4),activeR(:,5),'r.');
xlabel('Elbow FE')
ylabel('Elbow SP')
nexttile
scatter (activeL(:,4),activeL(:,6),'.');
hold on
scatter (activeR(:,4),activeR(:,6),'r.');
xlabel('Elbow FE')
ylabel('Wrist FE')
nexttile
scatter (activeL(:,4),activeL(:,7),'.');
hold on
scatter (activeR(:,4),activeR(:,7),'r.');
xlabel('Elbow FE')
ylabel('Wrist Dev')
nexttile
scatter (activeL(:,5),activeL(:,6),'.');
hold on
scatter (activeR(:,5),activeR(:,6),'r.');
xlabel('Elbow PS')
ylabel('Wrist FE')
nexttile
scatter (activeL(:,5),activeL(:,7),'.');
hold on
scatter (activeR(:,5),activeR(:,7),'r.');
xlabel('Elbow PS')
ylabel('Wrist Dev')
nexttile
scatter (activeL(:,6),activeL(:,7),'.');
hold on
scatter (activeR(:,6),activeR(:,7),'r.');
xlabel('Wrist FE')
ylabel('Wrist Dev')



%% Visualize and save figure - Healthy vs. Impaired
% ShRot, ShAA, ShFE, ElFE, ElPS, WrFE, WrDev 

test1 = activeL;
test2 = activeR;

figure ("InnerPosition",[100 100 1200 600])
t = tiledlayout(2,3);
title (t, 'Mild Healthy Arm (blue) vs. Impaired Arm (red)')
nexttile
scatter (test1(:,2),test1(:,3),'o');
hold on
scatter (test2(:,2),test2(:,3),'ro');
xlabel('Shoulder AA')
ylabel('Shoulder FE')
axis padded
nexttile
scatter (test1(:,1),test1(:,2),'o');
hold on
scatter (test2(:,1),test2(:,2),'ro');
xlabel('Shoulder Rot')
ylabel('Shoulder AA')
axis padded
nexttile
scatter (test1(:,1),test1(:,3),'o');
hold on
scatter (test2(:,1),test2(:,3),'ro');
xlabel('Shoulder Rot')
ylabel('Shoulder FE')
axis padded
nexttile
scatter (test1(:,4),test1(:,2),'o');
hold on
scatter (test2(:,4),test2(:,2),'ro');
xlabel('Elbow FE')
ylabel('Shoulder AA')
axis padded
nexttile
scatter (test1(:,4),test1(:,3),'o');
hold on
scatter (test2(:,4),test2(:,3),'ro');
xlabel('Elbow FE')
ylabel('Shoulder FE')
axis padded
nexttile
scatter (test1(:,4),test1(:,1),'o');
hold on
scatter (test2(:,4),test2(:,1),'ro');
xlabel('Elbow FE')
ylabel('Shoulder Rot')
axis padded
% nexttile
% scatter (test1(:,5),test1(:,2),'o');
% hold on
% scatter (test2(:,5),test2(:,2),'r.');
% xlabel('Elbow PS')
% ylabel('Shoulder AA')
% nexttile
% scatter (test1(:,5),test1(:,3),'o');
% hold on
% scatter (test2(:,5),test2(:,3),'r.');
% xlabel('Elbow PS')
% ylabel('Shoulder FE')
% nexttile
% scatter (test1(:,5),test1(:,1),'o');
% hold on
% scatter (test2(:,5),test2(:,1),'r.');
% xlabel('Elbow PS')
% ylabel('Shoulder Rot')
saveas(gcf,fullfile('.\figures\RoM data points\Healthy vs. Impaired\','Subject3.jpeg'));

% figure
% t = tiledlayout(2,3);
% title (t, 'Subject3 Healthy Arm (blue) vs. Impaired Arm (red)')
% nexttile
% scatter (test1(:,6),test1(:,2),'o');
% hold on
% scatter (test2(:,6),test2(:,2),'r.');
% xlabel('Wrist FE')
% ylabel('Shoulder AA')
% nexttile
% scatter (test1(:,6),test1(:,3),'o');
% hold on
% scatter (test2(:,6),test2(:,3),'r.');
% xlabel('Wrist FE')
% ylabel('Shoulder FE')
% nexttile
% scatter (test1(:,6),test1(:,1),'o');
% hold on
% scatter (test2(:,6),test2(:,1),'r.');
% xlabel('Wrist FE')
% ylabel('Shoulder Rot')
% nexttile
% scatter (test1(:,7),test1(:,2),'o');
% hold on
% scatter (test2(:,7),test2(:,2),'r.');
% xlabel('Wrist Dev')
% ylabel('Shoulder AA')
% nexttile
% scatter (test1(:,7),test1(:,3),'o');
% hold on
% scatter (test2(:,7),test2(:,3),'r.');
% xlabel('Wrist Dev')
% ylabel('Shoulder FE')
% nexttile
% scatter (test1(:,7),test1(:,1),'o');
% hold on
% scatter (test2(:,7),test2(:,1),'r.');
% xlabel('Wrist Dev')
% ylabel('Shoulder Rot')
% saveas(gcf,fullfile('.\figures\RoM data points\Healthy vs. Impaired\','Subject3_2.jpeg'));
% 
% figure
% t = tiledlayout(2,3);
% title (t, 'Subject3 Healthy Arm (blue) vs. Impaired Arm (red)')
% nexttile
% scatter (test1(:,4),test1(:,5),'o');
% hold on
% scatter (test2(:,4),test2(:,5),'r.');
% xlabel('Elbow FE')
% ylabel('Elbow SP')
% nexttile
% scatter (test1(:,4),test1(:,6),'o');
% hold on
% scatter (test2(:,4),test2(:,6),'r.');
% xlabel('Elbow FE')
% ylabel('Wrist FE')
% nexttile
% scatter (test1(:,4),test1(:,7),'o');
% hold on
% scatter (test2(:,4),test2(:,7),'r.');
% xlabel('Elbow FE')
% ylabel('Wrist Dev')
% nexttile
% scatter (test1(:,5),test1(:,6),'o');
% hold on
% scatter (test2(:,5),test2(:,6),'r.');
% xlabel('Elbow PS')
% ylabel('Wrist FE')
% nexttile
% scatter (test1(:,5),test1(:,7),'o');
% hold on
% scatter (test2(:,5),test2(:,7),'r.');
% xlabel('Elbow PS')
% ylabel('Wrist Dev')
% nexttile
% scatter (test1(:,6),test1(:,7),'o');
% hold on
% scatter (test2(:,6),test2(:,7),'r.');
% xlabel('Wrist FE')
% ylabel('Wrist Dev')
% saveas(gcf,fullfile('.\figures\RoM data points\Healthy vs. Impaired\','Subject3_3.jpeg'));

% Save RoM data
folderPath = '.\data\solved_angles';
folder_name = 'cleaned';
path = fullfile(folderPath, folder_name);
if ~exist(path, 'dir')
    mkdir(path);
end
save(fullfile(path, 'ROM_Subjec3_activeL'),'activeL');
save(fullfile(path, 'ROM_Subjec3_activeR'),'activeR');

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

%% Other

% % Modifications based on zero pose in the recorded video  

% % Test: Active Individual motions
% sklInd.LUArm(:,12) =  sklInd.LUArm(:,12) + 90;         % Shoulder Abduction
% sklInd.LUArm(:,13) =  sklInd.LUArm(:,13) + 90;         % Shoulder Extention
% sklInd.LFArm(:,11) = -sklInd.LFArm(:,11) + 20;         % Elbow Flexion
% sklInd.LHand(:,12) = -sklInd.LHand(:,12) - 5 ;         % Wrist Extention
% sklInd.LHand(:,13) =  sklInd.LHand(:,13) + 10;         % Wrist Supination
% % sklInd.LHand(:,13) =  sklInd.LHand(:,13);            % Wrist Deviation
% sklInd.RUArm(:,12) =  sklInd.RUArm(:,12) + 20;         % Shoulder Abduction
% % sklInd.RUArm(:,13) =  sklInd.RUArm(:,13);            % Shoulder Extention
% sklInd.RFArm(:,11) = -sklInd.RFArm(:,11) + 10;         % Elbow Flexion
% sklInd.RHand(:,12) = -sklInd.RHand(:,12) - 5 ;         % Wrist Extention
% % sklInd.RHand(:,13) =  sklInd.RHand(:,13);            % Wrist Supination
% % sklInd.LHand(:,13) =  sklInd.LHand(:,13);            % Wrist Deviation
% 
% % Test: Active Free form motion
% sklFree.LUArm(:,12) =  sklFree.LUArm(:,12) + 30;       % Shoulder Abduction
% sklFree.LUArm(:,13) =  sklFree.LUArm(:,13) + 80;       % Shoulder Extention
% sklFree.LFArm(:,11) = -sklFree.LFArm(:,11) + 20;       % Elbow Flexion
% sklFree.LHand(:,12) = -sklFree.LHand(:,12) - 5 ;       % Wrist Extention
% sklFree.LHand(:,13) =  sklFree.LHand(:,13) + 10;       % Wrist Supination
% % skl.LHand(:,13) =  skl.LHand(:,13);                  % Wrist Deviation
% sklFree.RUArm(:,12) =  sklFree.RUArm(:,12) + 20;       % Shoulder Abduction
% % skl.RUArm(:,13) =  skl.RUArm(:,13) + ;               % Shoulder Extention
% sklFree.RFArm(:,11) = -sklFree.RFArm(:,11) + 10;       % Elbow Flexion
% sklFree.RHand(:,12) = -sklFree.RHand(:,12) - 5 ;       % Wrist Extention
% % skl.RHand(:,13) =  skl.RHand(:,13);                  % Wrist Supination
% % skl.LHand(:,13) =  skl.LHand(:,13);                  % Wrist Deviation
% 
% % Test: Pssive Individual motions
% sklPas.LUArm(:,12) =  sklPas.LUArm(:,12) + 30;         % Shoulder Abduction
% sklPas.LUArm(:,13) =  sklPas.LUArm(:,13) + 85;         % Shoulder Extention
% sklPas.LFArm(:,11) = -sklPas.LFArm(:,11) + 15;         % Elbow Flexion
% sklPas.LHand(:,12) = -sklPas.LHand(:,12) - 5 ;         % Wrist Extention
% sklPas.LHand(:,13) =  sklPas.LHand(:,13) + 10;         % Wrist Supination
% % skl.LHand(:,13) =  skl.LHand(:,13);                  % Wrist Deviation
% sklPas.RUArm(:,12) =  sklPas.RUArm(:,12) + 20;         % Shoulder Abduction
% % skl.RUArm(:,13) =  skl.RUArm(:,13) + ;               % Shoulder Extention
% sklPas.RFArm(:,11) = -sklPas.RFArm(:,11) + 10;         % Elbow Flexion
% sklPas.RHand(:,12) = -sklPas.RHand(:,12) - 5 ;         % Wrist Extention
% % skl.RHand(:,13) =  skl.RHand(:,13);                  % Wrist Supination
% % skl.LHand(:,13) =  skl.LHand(:,13);                  % Wrist Deviation


% % Figure matrix for Right arm DoF
% figure
% bone2 = {'LUArm', 'LFArm', 'LHand'};
% t1 = tiledlayout(3*size(bone2,2),3*size(bone2,2));
% i=0;
% for bone1 = {'LUArm', 'LFArm', 'LHand'}
%     for j = 1:3 
%         for k= 1:3
%             nexttile
%             i=i+1;
%             p(i) = scatter (sklFree.(bone1{1})(:,10+j),sklFree.(bone2{k})(:,11));
%             nexttile
%             i=i+1;
%             p(i) = scatter (sklFree.(bone1{1})(:,10+j),sklFree.(bone2{k})(:,12));
%             nexttile
%             i=i+1;
%             p(i) = scatter (sklFree.(bone1{1})(:,10+j),sklFree.(bone2{k})(:,13));
%         end
%     end
% end
% 
% % figure
% % scatter (p(47).XData,p(47).YData);
