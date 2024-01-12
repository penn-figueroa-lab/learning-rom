% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % %  ----------------                                           % % % % 
% % % %  https://github.com/penn-figueroa-lab/learning-rom          % % % % 
% % % %  Shafagh Keyvanian: shkey@seas.upenn.edu                    % % % %
% % % %  ----------------                                           % % % % 
% % % %                                                             % % % %
% % % %                        ----------------                     % % % % 
% % % %                           This script                       % % % % 
% % % %                        ----------------                     % % % % 
% % % %  TWIST_SWING parametrization                                % % % %
% % % %                                                             % % % %
% % % %  Convert Motive export to skl struct & joints angles array  % % % %
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
% % % %  export info: bones, bone markers, +fin , meas coord, quat  % % % %
% % % %  bones fields: rows=frames, col=(quat(x y z w) pos[x y z])  % % % % 
% % % %                                                             % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


clc, clear, close all
% addpath '.\functions';

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

time = raw (:,2) - raw (1,2);
raw (:,[1,2]) = [];

skl = struct;
skl.time = time;

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


%% % % Extract twist_swing angles % % % % 

skl_local.Skeleton (:,[7,4:6]) = rotm2quat(Rot_wrtProx([0,0,0,1],skl.Ab(:,[7,4:6])));
skl_local.Chest (:,[7,4:6]) = rotm2quat(Rot_wrtProx(skl.Skeleton(:,[7,4:6]),skl.Chest(:,[7,4:6])));
skl_local.RUArm (:,[7,4:6]) = rotm2quat(Rot_wrtProx(skl.Chest(:,[7,4:6]),skl.RUArm(:,[7,4:6])));
skl_local.LUArm (:,[7,4:6]) = rotm2quat(Rot_wrtProx(skl.Chest(:,[7,4:6]),skl.LUArm(:,[7,4:6])));
skl_local.RShoulder (:,[7,4:6]) = rotm2quat(Rot_wrtProx(skl.Chest(:,[7,4:6]),skl.RShoulder(:,[7,4:6])));
skl_local.LShoulder (:,[7,4:6]) = rotm2quat(Rot_wrtProx(skl.Chest(:,[7,4:6]),skl.LShoulder(:,[7,4:6])));
% skl_local.RUArm (:,[7,4:6]) = rotm2quat(Rot_wrtProx(skl.RShoulder(:,[7,4:6]),skl.RUArm(:,[7,4:6])));
% skl_local.LUArm (:,[7,4:6]) = rotm2quat(Rot_wrtProx(skl.LShoulder(:,[7,4:6]),skl.LUArm(:,[7,4:6])));
skl_local.RFArm (:,[7,4:6]) = rotm2quat(Rot_wrtProx(skl.RUArm(:,[7,4:6]),skl.RFArm(:,[7,4:6])));
skl_local.LFArm (:,[7,4:6]) = rotm2quat(Rot_wrtProx(skl.LUArm(:,[7,4:6]),skl.LFArm(:,[7,4:6])));
skl_local.RHand (:,[7,4:6]) = rotm2quat(Rot_wrtProx(skl.RFArm(:,[7,4:6]),skl.RHand(:,[7,4:6])));
skl_local.LHand (:,[7,4:6]) = rotm2quat(Rot_wrtProx(skl.LFArm(:,[7,4:6]),skl.LHand(:,[7,4:6])));

hip = skl.Skeleton(:,1:3);
for bones = {'Skeleton','Chest','RShoulder','LShoulder','RUArm','RFArm','RHand','LUArm','LFArm','LHand'}
    for i=1:length(hip)
        skl_local.(bones{1})(i,1:3) = (skl.(bones{1})(i,1:3) - hip(i,:))/1000;
        q_s = skl_local.(bones{1})(i,7);
        q_x = skl_local.(bones{1})(i,5);
        q_y = skl_local.(bones{1})(i,6);
        q_z = skl_local.(bones{1})(i,4);
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
ST.LUArm(:,5) =  ST.LUArm(:,5) + 90;        % Shoulder Abduction
% ST.LUArm(:,6) = -ST.LUArm(:,6);           % Shoulder Extention
ST.LUArm(:,4) = -ST.LUArm(:,4);             % Shoulder Rotation
ST.LFArm(:,4) = -ST.LFArm(:,4);             % Elbow Extention
ST.LFArm(:,6) = -ST.LFArm(:,6);             % Elbow Supination

ST.RUArm(:,5) = -ST.RUArm(:,5) + 90;        % Shoulder Abduction
% ST.RUArm(:,6) = -ST.RUArm(:,6);           % Shoulder Extention
ST.RFArm(:,6) = -ST.RFArm(:,6);             % Elbow Supination
ST.RHand(:,5) = -ST.RHand(:,5);             % Wrist Extention
ST.RHand(:,4) = -ST.RHand(:,4);             % Wrist Deviation

ST_left (:,1:7) = [ST.LUArm(:,4:6), ST.LFArm(:,4), ST.LFArm(:,6), ST.LHand(:,4:5)]; 
ST_right(:,1:7) = [ST.RUArm(:,4:6), ST.RFArm(:,4), ST.RFArm(:,6), ST.RHand(:,4:5)];

%% Visualize wrt time

figure('Position', get(0, 'Screensize'))
t = tiledlayout(2,3);
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


