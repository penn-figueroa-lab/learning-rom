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
% % % %  Motive exported data.csv,  43 Bones(+fingers), 27 Markers  % % % % 
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

clc, clear, close all
addpath (genpath('.\data\edited_exports\2023-04-01\Subject2\'))

% load('.\data\edited_exports\2023-04-01\Subject1\Subject1_healthyL_Active_ind.mat');

load ('Subject2_healthyL_Free.mat')                     % Load Skeleton for Test:Free
sklFree = skl;
eraseNAN(sklFree);                              % Erase NAN Frames(rows)
Fs=1; sklFree = startFrom(sklFree,Fs);          % Start with Frame Fs, Removes frames before Fs
% Fe=50; skl = endFrame(skl,Fe);                % Keeps only the first Fe frames
tFree = sklFree.time;                           % Store time 
sklFree = extractAngMot (sklFree);              % Extract relative angles

load ('Subject2_healthyL_Active_ind.mat')                   % Load Skeleton for Test:Active-Independent                              
sklInd = skl;
eraseNAN(sklInd);                              
Fs=1; sklInd = startFrom(sklInd,Fs);           
% Fe=50; skl = endFrame(skl,Fe);                
tInd = sklInd.time;                              
sklInd = extractAngMot (sklInd);

load ('Subject2_impairedR_Free.mat')                     % Load Skeleton for Test:Free
sklFreeImp = skl;
eraseNAN(sklFreeImp);                              % Erase NAN Frames(rows)
Fs=1; sklFreeImp = startFrom(sklFreeImp,Fs);         % Start with Frame Fs, Removes frames before Fs
% Fe=50; skl = endFrame(skl,Fe);                % Keeps only the first Fe frames
tFreeImp = sklFreeImp.time;                           % Store time 
sklFreeImp = extractAngMot (sklFreeImp);              % Extract relative angles

load ('Subject2_impairedR_Active_ind1.mat')                   % Load Skeleton for Test:Active-Independent                              
sklIndImp = skl;
eraseNAN(sklIndImp);                              
Fs=1; sklIndImp = startFrom(sklIndImp,Fs);           
% Fe=50; skl = endFrame(skl,Fe);                
tIndImp = sklIndImp.time;                              
sklIndImp = extractAngMot (sklIndImp);

time = tInd;
skl = sklInd;



% time = [tInd;tInd(end)+tFree;tInd(end)+tFree(end)+tIndImp;tInd(end)+tFree(end)+tIndImp(end)+tFreeImp];
% for bones = fieldnames(sklInd)'
%     skl.(bones{1}) = [sklInd.(bones{1});sklFree.(bones{1});sklIndImp.(bones{1});sklFreeImp.(bones{1})];
% end

hip = skl.Skeleton(:,1:3);
for bones = {'Skeleton','Chest','RShoulder','LShoulder','RUArm','RFArm','RHand','LUArm','LFArm','LHand'}
    for i=1:length(hip)
        skl.(bones{1})(i,1:3) = (skl.(bones{1})(i,1:3) - hip(i,:))/1000;
        q_s = skl.(bones{1})(i,7);
        q_x = skl.(bones{1})(i,5);
        q_y = skl.(bones{1})(i,6);
        q_z = skl.(bones{1})(i,4);
        c_y = q_s/sqrt(q_s^2 + q_y^2);
        s_y = q_y/sqrt(q_s^2 + q_y^2);
        c_zx = sqrt(q_s^2 + q_y^2);
        s_x = (q_s*q_x - q_y*q_z)/sqrt(q_s^2 + q_y^2);
        s_z = (q_s*q_z + q_y*q_x)/sqrt(q_s^2 + q_y^2);
        tau = 2* atan(s_y/c_y);
        s1 = 2 * atan(sqrt(s_x^2+s_z^2)/c_zx) * s_x/sqrt(s_x^2+s_z^2);
        s2 = 2 * atan(sqrt(s_x^2+s_z^2)/c_zx) * s_z/sqrt(s_x^2+s_z^2);
        ST.(bones{1})(i,1) = 180/pi* tau;
        ST.(bones{1})(i,2) = 180/pi* s1;
        ST.(bones{1})(i,3) = 180/pi* s2;
    end
end

sklH_local.Skeleton (:,[7,4:6]) = rotm2quat(Rot_wrtProx([0,0,0,1],skl.Ab(:,[7,4:6])));
sklH_local.Chest (:,[7,4:6]) = rotm2quat(Rot_wrtProx(skl.Skeleton(:,[7,4:6]),skl.Chest(:,[7,4:6])));
sklH_local.RUArm (:,[7,4:6]) = rotm2quat(Rot_wrtProx(skl.Chest(:,[7,4:6]),skl.RUArm(:,[7,4:6])));
sklH_local.LUArm (:,[7,4:6]) = rotm2quat(Rot_wrtProx(skl.Chest(:,[7,4:6]),skl.LUArm(:,[7,4:6])));
sklH_local.RShoulder (:,[7,4:6]) = rotm2quat(Rot_wrtProx(skl.Chest(:,[7,4:6]),skl.RShoulder(:,[7,4:6])));
sklH_local.LShoulder (:,[7,4:6]) = rotm2quat(Rot_wrtProx(skl.Chest(:,[7,4:6]),skl.LShoulder(:,[7,4:6])));
% sklH_local.RUArm (:,[7,4:6]) = rotm2quat(Rot_wrtProx(sklH.RShoulder(:,[7,4:6]),sklH.RUArm(:,[7,4:6])));
% sklH_local.LUArm (:,[7,4:6]) = rotm2quat(Rot_wrtProx(sklH.LShoulder(:,[7,4:6]),sklH.LUArm(:,[7,4:6])));
sklH_local.RFArm (:,[7,4:6]) = rotm2quat(Rot_wrtProx(skl.RUArm(:,[7,4:6]),skl.RFArm(:,[7,4:6])));
sklH_local.LFArm (:,[7,4:6]) = rotm2quat(Rot_wrtProx(skl.LUArm(:,[7,4:6]),skl.LFArm(:,[7,4:6])));
sklH_local.RHand (:,[7,4:6]) = rotm2quat(Rot_wrtProx(skl.RFArm(:,[7,4:6]),skl.RHand(:,[7,4:6])));
sklH_local.LHand (:,[7,4:6]) = rotm2quat(Rot_wrtProx(skl.LFArm(:,[7,4:6]),skl.LHand(:,[7,4:6])));

for bones = {'Skeleton','Chest','RShoulder','LShoulder','RUArm','RFArm','RHand','LUArm','LFArm','LHand'}
    for i=1:length(hip)
        sklH_local.(bones{1})(i,1:3) = (skl.(bones{1})(i,1:3) - hip(i,:))/1000;
        q_s = sklH_local.(bones{1})(i,7);
        q_x = sklH_local.(bones{1})(i,5);
        q_y = sklH_local.(bones{1})(i,6);
        q_z = sklH_local.(bones{1})(i,4);
        c_y = q_s/sqrt(q_s^2 + q_y^2);
        s_y = q_y/sqrt(q_s^2 + q_y^2);
        c_zx = sqrt(q_s^2 + q_y^2);
        s_x = (q_s*q_x - q_y*q_z)/sqrt(q_s^2 + q_y^2);
        s_z = (q_s*q_z + q_y*q_x)/sqrt(q_s^2 + q_y^2);
        tau = 2* atan(s_y/c_y);
        s1 = 2 * atan(sqrt(s_x^2+s_z^2)/c_zx) * s_x/sqrt(s_x^2+s_z^2);
        s2 = 2 * atan(sqrt(s_x^2+s_z^2)/c_zx) * s_z/sqrt(s_x^2+s_z^2);
        ST.(bones{1})(i,4) = 180/pi* tau;
        ST.(bones{1})(i,5) = 180/pi* s1;
        ST.(bones{1})(i,6) = 180/pi* s2;
        ST.(bones{1})(i,1:6) = round(ST.(bones{1})(i,1:6),2);
    end
end
% ST.LUArm(:,5) =  ST.LUArm(:,5) + 90;        % Shoulder Abduction
% % ST.LUArm(:,6) = -ST.LUArm(:,6);        % Shoulder Extention
% ST.LUArm(:,4) = -ST.LUArm(:,4);             % Shoulder Rotation
% ST.LFArm(:,4) = -ST.LFArm(:,4);             % Elbow Extention
% ST.LFArm(:,6) = -ST.LFArm(:,6);             % Elbow Supination
% 
% ST.RUArm(:,5) = -ST.RUArm(:,5) + 90;        % Shoulder Abduction
% % ST.RUArm(:,6) = -ST.RUArm(:,6);        % Shoulder Extention
% ST.RFArm(:,6) = -ST.RFArm(:,6);             % Elbow Supination
% ST.RHand(:,5) = -ST.RHand(:,5);             % Wrist Extention
% ST.RHand(:,4) = -ST.RHand(:,4);             % Wrist Deviation

RoM_left(:,1:7) = [skl.LUArm(:,11:13), skl.LFArm(:,11), skl.LFArm(:,13), skl.LHand(:,11:12)]; 
RoM_right(:,1:7) = [skl.RUArm(:,11:13), skl.RFArm(:,11), skl.RFArm(:,13), skl.RHand(:,11:12)]; 

ST_left(:,1:7) = [ST.LUArm(:,4:6), ST.LFArm(:,4), ST.LFArm(:,6), ST.LHand(:,4:5)]; 
ST_right(:,1:7) = [ST.RUArm(:,4:6), ST.RFArm(:,4), ST.RFArm(:,6), ST.RHand(:,4:5)];

%% Visualize

figure('Position', get(0, 'Screensize'))
t = tiledlayout(2,3);
% nexttile
% plot (time,ST.Chest(:,4),'k',time,sklH.Chest(:,11),'b');
% ylabel('Sternum X')
% nexttile
% plot (time,ST.Chest(:,5),'k',time,sklH.Chest(:,12),'b');
% ylabel('Sternum Y')
% nexttile
% plot (time,ST.Chest(:,6),'k',time,sklH.Chest(:,13),'b');
% ylabel('Sternum Z')
nexttile
plot (time,ST.LShoulder(:,4),'k',time,skl.LShoulder(:,11),'b');
ylabel('Clavicle X')
nexttile
plot (time,ST.LShoulder(:,5),'k',time,skl.LShoulder(:,12),'b');
ylabel('Clavicle Y')
nexttile
plot (time,ST.LShoulder(:,6),'k',time,skl.LShoulder(:,13),'b');
ylabel('Clavicle Z')
nexttile
% plot (time,ST.LFArm(:,4),'k',time,sklH.LFArm(:,11),'b');
% ylabel('Elbow Z')
% nexttile
% plot (time,ST.LFArm(:,5),'k',time,sklH.LFArm(:,12),'b');
% ylabel('Elbow X')
% nexttile
% plot (time,ST.LFArm(:,6),'k',time,sklH.LFArm(:,13),'b');
% ylabel('Elbow Y')
% nexttile
plot (time,ST.LUArm(:,4),'k',time,skl.LUArm(:,11),'b');
ylabel('Shoulder X')
nexttile
plot (time,ST.LUArm(:,5),'k',time,skl.LUArm(:,12),'b');
ylabel('Shoulder Y')
nexttile
plot (time,ST.LUArm(:,6),'k',time,skl.LUArm(:,13),'b');
ylabel('Shoulder Z')

figure('Position', get(0, 'Screensize'))
t = tiledlayout(2,3);
nexttile
plot (time,ST.LFArm(:,4),'k',time,skl.LFArm(:,11),'b');
ylabel('Elbow Z')
nexttile
plot (time,ST.LFArm(:,5),'k',time,skl.LFArm(:,12),'b');
ylabel('Elbow X')
nexttile
plot (time,ST.LFArm(:,6),'k',time,skl.LFArm(:,13),'b');
ylabel('Elbow Y')
nexttile
plot (time,ST.LHand(:,4),'k',time,skl.LHand(:,11),'b');
ylabel('Wrist X')
nexttile
plot (time,ST.LHand(:,5),'k',time,skl.LHand(:,12),'b');
ylabel('Wrist Y')
nexttile
plot (time,ST.LHand(:,6),'k',time,skl.LHand(:,13),'b');
ylabel('Wrist Z')



%% % % % Store solved 7DoF RoM data
% ShRot, ShAA, ShFE, ElFE, ElPS, WrFE, WrDev 
left(:,1:7) = [skl.LUArm(:,11:13), skl.LFArm(:,11), skl.LFArm(:,13), ST.LHand(:,4:5)]; 
right(:,1:7) = [skl.RUArm(:,11:13), skl.RFArm(:,11), skl.RFArm(:,13), ST.RHand(:,4:5)];
test1 = RoM_left;
test2 = RoM_right;

figure('Position', get(0, 'Screensize'))
t = tiledlayout(2,3);
title (t, 'Euler (blue) ~~ swing-twist (red)')
nexttile
scatter (test1(:,2),test1(:,3),'o','LineWidth',2);
hold on
scatter (test2(:,2),test2(:,3),'r.');
xlabel('Shoulder AA')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,1),test1(:,2),'o','LineWidth',2);
hold on
scatter (test2(:,1),test2(:,2),'r.');
xlabel('Shoulder Rot')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,1),test1(:,3),'o','LineWidth',2);
hold on
scatter (test2(:,1),test2(:,3),'r.');
xlabel('Shoulder Rot')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,4),test1(:,2),'o','LineWidth',2);
hold on
scatter (test2(:,4),test2(:,2),'r.');
xlabel('Elbow FE')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,4),test1(:,3),'o','LineWidth',2);
hold on
scatter (test2(:,4),test2(:,3),'r.');
xlabel('Elbow FE')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,4),test1(:,1),'o','LineWidth',2);
hold on
scatter (test2(:,4),test2(:,1),'r.');
xlabel('Elbow FE')
ylabel('Shoulder Rot')

figure('Position', get(0, 'Screensize'))
t = tiledlayout(2,3);
title (t, 'PosePrior dataset - 03103: RIGHT(blue) ~~ LEFT(red)')
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

figure('Position', get(0, 'Screensize'))
t = tiledlayout(2,3);
title (t, 'PosePrior dataset - 03103: RIGHT(blue) ~~ LEFT(red)')
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


