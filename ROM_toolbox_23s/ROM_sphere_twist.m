% % % %  ----------------                                           % % % % 
% % % %  https://github.com/penn-figueroa-lab/learning-rom          % % % % 
% % % %  Shafagh Keyvanian: shkey@seas.upenn.edu                    % % % %
% % % %  ----------------                                           % % % %                                                             % % % %


clc, clear, close all
addpath (genpath('.\data\edited_exports\2023-04-01\Subject1\'))

% load('.\data\edited_exports\2023-04-01\Subject1\Subject1_healthyL_Active_ind.mat');

load ('Subject1_healthyL_Free.mat')                     % Load Skeleton for Test:Free
sklFree = skl;
eraseNAN(sklFree);                              % Erase NAN Frames(rows)
Fs=1; sklFree = startFrom(sklFree,Fs);         % Start with Frame Fs, Removes frames before Fs
% Fe=50; skl = endFrame(skl,Fe);                % Keeps only the first Fe frames
tFree = sklFree.time;                           % Store time 
sklFree = extractAngMot (sklFree);              % Extract relative angles

load ('Subject1_healthyL_Active_ind.mat')                   % Load Skeleton for Test:Active-Independent                              
sklInd = skl;
eraseNAN(sklInd);                              
Fs=1; sklInd = startFrom(sklInd,Fs);           
% Fe=50; skl = endFrame(skl,Fe);                
tInd = sklInd.time;                              
sklInd = extractAngMot (sklInd);

load ('Subject1_impairedR_Free.mat')                     % Load Skeleton for Test:Free
sklFreeImp = skl;
eraseNAN(sklFreeImp);                              % Erase NAN Frames(rows)
Fs=1; sklFreeImp = startFrom(sklFreeImp,Fs);         % Start with Frame Fs, Removes frames before Fs
% Fe=50; skl = endFrame(skl,Fe);                % Keeps only the first Fe frames
tFreeImp = sklFreeImp.time;                           % Store time 
sklFreeImp = extractAngMot (sklFreeImp);              % Extract relative angles

load ('Subject1_impairedR_Active_ind.mat')                   % Load Skeleton for Test:Active-Independent                              
sklIndImp = skl;
eraseNAN(sklIndImp);                              
Fs=1; sklIndImp = startFrom(sklIndImp,Fs);           
% Fe=50; skl = endFrame(skl,Fe);                
tIndImp = sklIndImp.time;                              
sklIndImp = extractAngMot (sklIndImp);

% load('.\data\edited_exports\2023-04-01\Subject0\Subject0_healthyR_Active_indWrPS.mat');
% skl = rmfield( skl , "time" );
% skl_test = skl;
% for bones = fieldnames(skl)'
%     skl_test.(bones{1}) = [skl_test1.(bones{1});skl_test.(bones{1})];
% end
% load('.\data\edited_exports\2023-04-01\Subject3\Subject3_healthyL_Free.mat');
% skl = rmfield( skl , "time" );
% for m = {'LFHD', 'LBHD', 'RBHD', 'RFHD', 'C7', 'T10', 'RBAK', 'CLAV', 'STRN', 'LSHO', 'LUPA', 'LELB', 'LFRM', 'LWRB', 'LWRA', 'LFIN', 'RSHO', 'RUPA', 'RELB', 'RFRM', 'RWRB', 'RWRA', 'RFIN', 'LASI', 'LPSI', 'RPSI', 'RASI'}
%    skl = rmfield (skl, m);
% end

time = [tInd;tInd(end)+tFree;tInd(end)+tFree(end)+tIndImp;tInd(end)+tFree(end)+tIndImp(end)+tFreeImp];
for bones = fieldnames(sklInd)'
    sklH.(bones{1}) = [sklInd.(bones{1});sklFree.(bones{1});sklIndImp.(bones{1});sklFreeImp.(bones{1})];
end

hip = sklH.Skeleton(:,1:3);
for bones = {'Skeleton','Chest','RShoulder','LShoulder','RUArm','RFArm','RHand','LUArm','LFArm','LHand'}
    for i=1:length(hip)
        sklH.(bones{1})(i,1:3) = (sklH.(bones{1})(i,1:3) - hip(i,:))/1000;
        q_s = sklH.(bones{1})(i,7);
        q_x = sklH.(bones{1})(i,5);
        q_y = sklH.(bones{1})(i,6);
        q_z = sklH.(bones{1})(i,4);
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

sklH_local.Skeleton (:,[7,4:6]) = rotm2quat(Rot_wrtProx([0,0,0,1],sklH.Ab(:,[7,4:6])));
sklH_local.Chest (:,[7,4:6]) = rotm2quat(Rot_wrtProx(sklH.Skeleton(:,[7,4:6]),sklH.Chest(:,[7,4:6])));
sklH_local.RUArm (:,[7,4:6]) = rotm2quat(Rot_wrtProx(sklH.Chest(:,[7,4:6]),sklH.RUArm(:,[7,4:6])));
sklH_local.LUArm (:,[7,4:6]) = rotm2quat(Rot_wrtProx(sklH.Chest(:,[7,4:6]),sklH.LUArm(:,[7,4:6])));
sklH_local.RShoulder (:,[7,4:6]) = rotm2quat(Rot_wrtProx(sklH.Chest(:,[7,4:6]),sklH.RShoulder(:,[7,4:6])));
sklH_local.LShoulder (:,[7,4:6]) = rotm2quat(Rot_wrtProx(sklH.Chest(:,[7,4:6]),sklH.LShoulder(:,[7,4:6])));
% sklH_local.RUArm (:,[7,4:6]) = rotm2quat(Rot_wrtProx(sklH.RShoulder(:,[7,4:6]),sklH.RUArm(:,[7,4:6])));
% sklH_local.LUArm (:,[7,4:6]) = rotm2quat(Rot_wrtProx(sklH.LShoulder(:,[7,4:6]),sklH.LUArm(:,[7,4:6])));
sklH_local.RFArm (:,[7,4:6]) = rotm2quat(Rot_wrtProx(sklH.RUArm(:,[7,4:6]),sklH.RFArm(:,[7,4:6])));
sklH_local.LFArm (:,[7,4:6]) = rotm2quat(Rot_wrtProx(sklH.LUArm(:,[7,4:6]),sklH.LFArm(:,[7,4:6])));
sklH_local.RHand (:,[7,4:6]) = rotm2quat(Rot_wrtProx(sklH.RFArm(:,[7,4:6]),sklH.RHand(:,[7,4:6])));
sklH_local.LHand (:,[7,4:6]) = rotm2quat(Rot_wrtProx(sklH.LFArm(:,[7,4:6]),sklH.LHand(:,[7,4:6])));

for bones = {'Skeleton','Chest','RShoulder','LShoulder','RUArm','RFArm','RHand','LUArm','LFArm','LHand'}
    for i=1:length(hip)
        sklH_local.(bones{1})(i,1:3) = (sklH.(bones{1})(i,1:3) - hip(i,:))/1000;
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

% ST.RUArm_local (:,1:3) = (sklH.RUArm(:,1:3)-sklH.Chest(:,1:3));
% ST.LUArm_local (:,1:3) = (sklH.LUArm(:,1:3)-sklH.Chest(:,1:3));
Sph.RUArm_local (:,1:3) = (sklH.RFArm(:,1:3)-sklH.RUArm(:,1:3));
Sph.LUArm_local (:,1:3) = (sklH.LFArm(:,1:3)-sklH.LUArm(:,1:3));
Sph.RFArm_local (:,1:3) = (sklH.RHand(:,1:3)-sklH.RFArm(:,1:3));
Sph.LFArm_local (:,1:3) = (sklH.LHand(:,1:3)-sklH.LFArm(:,1:3));
Sph.RHand_local (:,1:3) = (sklH.RMiddle1(:,1:3)-sklH.RHand(:,1:3));
Sph.LHand_local (:,1:3) = (sklH.LMiddle1(:,1:3)-sklH.LHand(:,1:3));

[Sph.RUArm(:,5),Sph.RUArm(:,6)] = cart2sph(Sph.RUArm_local(:,3),Sph.RUArm_local(:,1),Sph.RUArm_local(:,2));
[Sph.LUArm(:,5),Sph.LUArm(:,6)] = cart2sph(Sph.LUArm_local(:,3),Sph.LUArm_local(:,1),Sph.LUArm_local(:,2));
[Sph.RFArm(:,5),Sph.RFArm(:,6)] = cart2sph(Sph.RFArm_local(:,3),Sph.RFArm_local(:,1),Sph.RFArm_local(:,2));
[Sph.LFArm(:,5),Sph.LFArm(:,6)] = cart2sph(Sph.LFArm_local(:,3),Sph.LFArm_local(:,1),Sph.LFArm_local(:,2));
[Sph.RHand(:,5),Sph.RHand(:,6)] = cart2sph(Sph.RHand_local(:,3),Sph.RHand_local(:,1),Sph.RHand_local(:,2));
[Sph.LHand(:,5),Sph.LHand(:,6)] = cart2sph(Sph.LHand_local(:,3),Sph.LHand_local(:,1),Sph.LHand_local(:,2));

for bones = {'RUArm','RFArm','RHand','LUArm','LFArm','LHand'}
    for i=1:length(hip)
        Sph.(bones{1})(i,1:6) = round(180/pi* Sph.(bones{1})(i,1:6),2);
    end
end
ST.LUArm(:,5) =  ST.LUArm(:,5) + 90;        % Shoulder Abduction
% ST.LUArm(:,6) = -ST.LUArm(:,6);        % Shoulder Extention
ST.LUArm(:,4) = -ST.LUArm(:,4);             % Shoulder Rotation
ST.LFArm(:,4) = -ST.LFArm(:,4);             % Elbow Extention
ST.LFArm(:,6) = -ST.LFArm(:,6);             % Elbow Supination

ST.RUArm(:,5) = -ST.RUArm(:,5) + 90;        % Shoulder Abduction
% ST.RUArm(:,6) = -ST.RUArm(:,6);        % Shoulder Extention
ST.RFArm(:,6) = -ST.RFArm(:,6);             % Elbow Supination
ST.RHand(:,5) = -ST.RHand(:,5);             % Wrist Extention
ST.RHand(:,4) = -ST.RHand(:,4);             % Wrist Deviation

RoM_left(:,1:7) = [sklH.LUArm(:,11:13), sklH.LFArm(:,11), sklH.LFArm(:,13), sklH.LHand(:,11:12)]; 
RoM_right(:,1:7) = [sklH.RUArm(:,11:13), sklH.RFArm(:,11), sklH.RFArm(:,13), sklH.RHand(:,11:12)]; 

ST_left(:,1:7) = [ST.LUArm(:,4:6), ST.LFArm(:,4), ST.LFArm(:,6), ST.LHand(:,4:5)]; 
ST_right(:,1:7) = [ST.RUArm(:,4:6), ST.RFArm(:,4), ST.RFArm(:,6), ST.RHand(:,4:5)];

%% Visualize
figure('Position', get(0, 'Screensize'))
t = tiledlayout(2,3);
nexttile
plot (time,ST.LFArm(:,4),'k',time,Sph.LFArm(:,4),'b');
ylabel('Elbow Z')
nexttile
plot (time,ST.LFArm(:,5),'k',time,Sph.LFArm(:,5),'b');
ylabel('Elbow X')
nexttile
plot (time,ST.LFArm(:,6),'k',time,Sph.LFArm(:,6),'b');
ylabel('Elbow Y')
nexttile
plot (time,ST.LUArm(:,4),'k',time,Sph.LUArm(:,4),'b');
ylabel('Shoulder X')
nexttile
plot (time,ST.LUArm(:,5),'k',time,Sph.LUArm(:,5),'b');
ylabel('Shoulder Y')
nexttile
plot (time,ST.LUArm(:,6),'k',time,Sph.LUArm(:,6),'b');
ylabel('Shoulder Z')

%%

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
% nexttile
% plot (time,ST.LShoulder(:,4),'k',time,sklH.LShoulder(:,11),'b');
% ylabel('Clavicle X')
% nexttile
% plot (time,ST.LShoulder(:,5),'k',time,sklH.LShoulder(:,12),'b');
% ylabel('Clavicle Y')
% nexttile
% plot (time,ST.LShoulder(:,6),'k',time,sklH.LShoulder(:,13),'b');
% ylabel('Clavicle Z')
nexttile
plot (time,ST.LFArm(:,4),'k',time,sklH.LFArm(:,11),'b');
ylabel('Elbow Z')
nexttile
plot (time,ST.LFArm(:,5),'k',time,sklH.LFArm(:,12),'b');
ylabel('Elbow X')
nexttile
plot (time,ST.LFArm(:,6),'k',time,sklH.LFArm(:,13),'b');
ylabel('Elbow Y')
nexttile
plot (time,ST.LUArm(:,4),'k',time,sklH.LUArm(:,11),'b');
ylabel('Shoulder X')
nexttile
plot (time,ST.LUArm(:,5),'k',time,sklH.LUArm(:,12),'b');
ylabel('Shoulder Y')
nexttile
plot (time,ST.LUArm(:,6),'k',time,sklH.LUArm(:,13),'b');
ylabel('Shoulder Z')

figure('Position', get(0, 'Screensize'))
t = tiledlayout(2,3);
nexttile
plot (time,ST.LFArm(:,4),'k',time,sklH.LFArm(:,11),'b');
ylabel('Elbow Z')
nexttile
plot (time,ST.LFArm(:,5),'k',time,sklH.LFArm(:,12),'b');
ylabel('Elbow X')
nexttile
plot (time,ST.LFArm(:,6),'k',time,sklH.LFArm(:,13),'b');
ylabel('Elbow Y')
nexttile
plot (time,ST.LHand(:,4),'k',time,sklH.LHand(:,11),'b');
ylabel('Wrist X')
nexttile
plot (time,ST.LHand(:,5),'k',time,sklH.LHand(:,12),'b');
ylabel('Wrist Y')
nexttile
plot (time,ST.LHand(:,6),'k',time,sklH.LHand(:,13),'b');
ylabel('Wrist Z')



%% % % % Store solved 7DoF RoM data
% ShRot, ShAA, ShFE, ElFE, ElPS, WrFE, WrDev 

test1 = RoM_left;
test2 = ST_left;

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


%% Shoulder
figure
title ('Euler (blue) ~~ swing-twist (red)')
scatter3 (test1(:,1),test1(:,2),test1(:,3),'o','LineWidth',2);
% hold on
% scatter3 (test2(:,1),test2(:,2),test2(:,3),'r','LineWidth',2);
xlabel('Shoulder Rot')
ylabel('Shoulder AA')
zlabel('Shoulder FE')
