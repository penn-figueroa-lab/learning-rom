function sklAngles = extractAngMot (skl)

% % % %  Skeleton: Conventional Upper (27 Markers) - 43 Bones    % % % %
% % % %  Input: Skeleton Struct, col=(pos[x y z] quat(x y z w))  % % % %
% % % %  Remove Time from skl && Set Hip(Skeleton) as base frame   % % % 
% % % %  Store joint angles wrt world for visualing frames (8:10)  % % % 
% % % %  Store joint angles wrt proximal joints: quat -> rot -> eul  % % 
% % % %  All angles wrt starting Joint Angles at t=0 - zero config   % % 
% % % %  Cols=(pos(1:3) quat(5:7) angGlobal(8:10) eulAngLocal(11:13) % % 
% % % %  Visualize results: all wrt time, eul angles wrt eachothe  % % % 

% Remove time and markers
skl = rmfield( skl , "time" );  
for m = {'LFHD', 'LBHD', 'RBHD', 'RFHD', 'C7', 'T10', 'RBAK', 'CLAV', 'STRN', 'LSHO', 'LUPA', 'LELB', 'LFRM', 'LWRB', 'LWRA', 'LFIN', 'RSHO', 'RUPA', 'RELB', 'RFRM', 'RWRB', 'RWRA', 'RFIN', 'LASI', 'LPSI', 'RPSI', 'RASI'}
   skl = rmfield (skl, m);
end

% Optitrack: Angles global (8:10)
for bones = fieldnames(skl)'
    [skl.(bones{1})(:,8), skl.(bones{1})(:,9), skl.(bones{1})(:,10)] = quat2angle(skl.(bones{1})(:,[7,4:6]),"ZXY");
end
[skl.Skeleton(:,8), skl.Skeleton(:,9), skl.Skeleton(:,10)] = quat2angle(skl.Skeleton(:,[7,4:6]),'ZYZ');

% Optitrack: Angles local (11:13)
skl.Skeleton (:,11:13) = rotm2eul(Rot_wrtProx([0,0,0,1],skl.Ab(:,[7,4:6])));
skl.Chest (:,11:13) = rotm2eul(Rot_wrtProx(skl.Skeleton(:,[7,4:6]),skl.Chest(:,[7,4:6])));
skl.RUArm (:,11:13) = rotm2eul(Rot_wrtProx(skl.Chest(:,[7,4:6]),skl.RUArm(:,[7,4:6])));
skl.LUArm (:,11:13) = rotm2eul(Rot_wrtProx(skl.Chest(:,[7,4:6]),skl.LUArm(:,[7,4:6])));
skl.RShoulder (:,11:13) = rotm2eul(Rot_wrtProx(skl.Chest(:,[7,4:6]),skl.RShoulder(:,[7,4:6])));
skl.LShoulder (:,11:13) = rotm2eul(Rot_wrtProx(skl.Chest(:,[7,4:6]),skl.LShoulder(:,[7,4:6])));
% skl.RUArm (:,11:13) = rotm2eul(Rot_wrtProx(skl.RShoulder(:,[7,4:6]),skl.RUArm(:,[7,4:6])));
% skl.LUArm (:,11:13) = rotm2eul(Rot_wrtProx(skl.LShoulder(:,[7,4:6]),skl.LUArm(:,[7,4:6])));
skl.RFArm (:,11:13) = rotm2eul(Rot_wrtProx(skl.RUArm(:,[7,4:6]),skl.RFArm(:,[7,4:6])));
skl.LFArm (:,11:13) = rotm2eul(Rot_wrtProx(skl.LUArm(:,[7,4:6]),skl.LFArm(:,[7,4:6])));
skl.RHand (:,11:13) = rotm2eul(Rot_wrtProx(skl.RFArm(:,[7,4:6]),skl.RHand(:,[7,4:6])));
skl.LHand (:,11:13) = rotm2eul(Rot_wrtProx(skl.LFArm(:,[7,4:6]),skl.LHand(:,[7,4:6])));

% % Angles: rad2deg & round
for bones = {'Skeleton','Chest','RShoulder','LShoulder','RUArm','RFArm','RHand','LUArm','LFArm','LHand'}
    skl.(bones{1})(:,8:13) = rad2deg (skl.(bones{1})(:,8:13));
    skl.(bones{1})(:,8:13) = round(skl.(bones{1})(:,8:13),2);
end

% % Correcting the angles: based on the conventional zero definition:
% skl.LUArm(:,12) =  skl.LUArm(:,12) + 90;        % Shoulder Abduction
% % skl.LUArm(:,13) =  skl.LUArm(:,13) + 90;        % Shoulder Extention
% skl.LUArm(:,11) = -skl.LUArm(:,11);             % Shoulder Rotation
% skl.LFArm(:,11) = -skl.LFArm(:,11);             % Elbow Extention
% skl.LFArm(:,13) = -skl.LFArm(:,13);             % Elbow Supination
% 
% skl.RUArm(:,12) = -skl.RUArm(:,12) + 90;        % Shoulder Abduction
% skl.RUArm(:,13) =  skl.RUArm(:,13) + 90;        % Shoulder Extention
% skl.RFArm(:,13) = -skl.RFArm(:,13);             % Elbow Supination
% skl.RHand(:,12) = -skl.RHand(:,12);             % Wrist Extention
% skl.RHand(:,11) = -skl.RHand(:,11);             % Wrist Deviation

sklAngles = skl;

end