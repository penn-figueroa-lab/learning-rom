function sklAngles = storeAngles (skl)

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

skl.RSternum  = (skl.RShoulder+skl.LShoulder)/2; % Adding Sternum (Use position values only)
skl.LSternum  = (skl.RShoulder+skl.LShoulder)/2; % Adding Sternum (Use position values only)

% Positions wrt Hip (1:3)
hip = skl.Skeleton(:,1:3);
for bones = fieldnames(skl)'
    skl.(bones{1})(:,1:3) = (skl.(bones{1})(:,1:3) - hip)/1000;
end

figure

% % % % Right Arm % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %  
SegmentR = {'World','Skeleton','RSternum','RUArm','RFArm','RHand','RMiddle1'};
baddata=0;
for i = 1: size(skl.Skeleton,1)

    % Kinematics: Bones Positions and Lines    
    p(1,1:3) = skl.Skeleton(i,1:3);     
    d(1,1:3) = p(1,1:3);              
    for k= 2:length(SegmentR) 
        p(k,1:3) = skl.(SegmentR{k})(i,1:3);     % Joint positions
        d(k,1:3) = p(k,1:3) - p(k-1,1:3);        % Vector poining from proximal to current
    end
    
    % % Kinematics: Bones Frames based on ISB recommendation
    % World 
        x(1,1:3)=[1 0 0]; 
        y(1,1:3)=[0 1 0]; 
        z(1,1:3)=[0 0 1];
    % HIP: y poining to distal (up), x pointing fw, z pointing right
        kk=2;
        y(kk,1:3) = d(kk+1,1:3)/norm(d(kk+1,1:3));   
        hipAxis = markers.RASI - markers.LASI;
        x(kk,1:3) = cross(y(kk,1:3),hipAxis(i,1:3)) / norm(cross(y(kk,1:3),hipAxis(i,1:3))); 
        z(kk,1:3) = cross(x(kk,1:3),y(kk,1:3));    
    % Sternum: z poining to distal (right), x pointing fw, y pointing up
        kk=3;
        z(kk,1:3) = d(kk+1,1:3)/norm(d(kk+1,1:3));
        strAxis = markers.C7 - markers.T10; % pointing up
        x(kk,1:3) = cross(strAxis(i,1:3),z(kk,1:3)) / norm(cross(strAxis(i,1:3),z(kk,1:3)));
        y(kk,1:3) = cross (z(kk,1:3),x(kk,1:3));
    % Shoulder(GH): y poining to -distal (up), x pointing fw, z pointing right
        kk=4;
        y(kk,1:3) = -d(kk+1,1:3)/norm(d(kk+1,1:3));
        elAxisX(i,1:3) = markers.RELB(i,1:3) - skl.RFArm(i,1:3); % elbow axis pointing lateral
        x(kk,1:3) = -cross(y(kk,1:3),elAxisX(i,1:3)) / norm(cross(y(kk,1:3),elAxisX(i,1:3)));
        z(kk,1:3) = cross(x(kk,1:3),y(kk,1:3));
    % Elbow: y poining to -distal (up), x pointing fw, z pointing right
        kk=5;
        y(kk,1:3) = -d(kk+1,1:3)/norm(d(kk+1,1:3));
        % z(kk,1:3) = cross(d(kk,1:3),d(kk+1,1:3)) / norm(cross(d(kk,1:3),d(kk+1,1:3)));
        % x(kk,1:3) = cross(y(kk,1:3),z(kk,1:3));
        % % The above formula plip the axes at 180
        x(kk,1:3) = -cross(y(kk,1:3),elAxisX(i,1:3)) / norm(cross(y(kk,1:3),elAxisX(i,1:3)));
        z(kk,1:3) = cross (x(kk,1:3),y(kk,1:3));
    % Hand: y poining to -distal (away from fingers), x pointing inwards, z pointing to thumb
        kk=6;
        wrAxis1 = markers.RWRA - markers.RWRB; % pointing lateral (medial: to thumb)
        y(kk,1:3) = -d(kk+1,1:3)/norm(d(kk+1,1:3));
        x(kk,1:3) = cross(y(kk,1:3),wrAxis1(i,1:3)) / norm(cross(y(kk,1:3),wrAxis1(i,1:3)));
        z(kk,1:3) = cross (x(kk,1:3),y(kk,1:3));
        % % If wrist was twisted in the motive, use finger marker:
        % wrAxis2 = markers.RFIN - markers.RWRA; % pointing from wrist to fingers
        % z(kk,1:3) = wrAxis1(i,1:3) / norm(wrAxis1(i,1:3));
        % x(kk,1:3) = -cross(wrAxis1(i,1:3),wrAxis2(i,1:3)) / norm(cross(wrAxis1(i,1:3),wrAxis2(i,1:3)));
        % y(kk,1:3) = cross (z(kk,1:3),x(kk,1:3));
    
    % Kinematics: Bones Frames
    for k=1:length(SegmentR)-1
        R(:,:,k) = [x(k,1:3);y(k,1:3);z(k,1:3)]';
        [out, varargout] = isrot(R(:,:,k)); 
        if ~isrot(R(:,:,k)) || anynan(R)
            baddata=baddata+1;
            fprintf('ROT matrix error: Frame%d (time=%d), In %s\n',i,t(i,1),SegmentR{k});
            fprintf('Error type: %s\n',varargout);
            R(:,:,k) = RR;  % rot matrix of previous time
        end
        RR = R(:,:,k);
        tform(1:3,1:3,k) = R(:,:,k);
        tform(1:3,4,k) = p(k,1:3);
        tform(4,:,k) = [0 0 0 1];
    end
    % tform(1:3,4,5) = p(5+1,1:3);             % ISB: Elbow Frame located on Wrist (commented for better visualization)
    % tform(1:3,4,6) = p(6,1:3)+d(7,1:3)/2;    % ISB: Wrist Frame located on Palm (commented for better visualization)
    
    if i==1     % % Visualize one frame
        for k=1:length(SegmentR)-1
            plot3 ([p(k,1) p(k+1,1)],[p(k,2) p(k+1,2)],[p(k,3) p(k+1,3)],'k')
            scatter3 (tform(1,4,k),tform(2,4,k),tform(3,4,k),"*")
            drawframe(tform(:,:,k),0.05)
            hold on
        end
    end
    % scatter3 (p(length(Segment)-1,1)+d(length(Segment),1)/2, p(length(Segment)-1,2)+d(length(Segment),2)/2, p(length(Segment)-1,3)+d(length(Segment),3)/2,'MarkerFaceColor',[0 .75 .75])
    pbaspect ([1 1 1])
    daspect ([1 1 1])
        
    % Kinematics: quaternions global (4:7), Angles local (14:17)
    for k=2:length(SegmentR)-1
        % skl.(SegmentR{k})(i,8:10) = 180/pi*(rotm2eul(R(:,:,k)));
        % Rrel = R(:,:,k-1)'R(:,:,k);
        % skl.(SegmentR{k})(i,11:13) = 180/pi*(rotm2eul(Rrel));  
        Rrel = R(:,:,k-1)'*R(:,:,k);
        skl.(SegmentR{k})(i,4:7) = rotm2quat (R(:,:,k));
        skl.(SegmentR{k})(i,14:17) = rotm2quat (Rrel);
    end 
end 

% % % % Left Arm % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
SegmentL = {'World','Skeleton','LSternum','LUArm','LFArm','LHand','LMiddle1'};

for i = 1: size(skl.Skeleton,1)
        
    for k= 2:length(SegmentL) 
        p(k,1:3) = skl.(SegmentL{k})(i,1:3);     % Joint positions
        d(k,1:3) = p(k,1:3) - p(k-1,1:3);        % Vector poining from proximal to current
    end
    
    % % Kinematics: Bones Frames based on ISB recommendation: Right arm mirrored
    % HIP: y poining to distal (up), x pointing fw, z pointing right
        kk=2;
        y(kk,1:3) = d(kk+1,1:3)/norm(d(kk+1,1:3));   
        hipAxis = markers.RASI - markers.LASI;
        x(kk,1:3) = -cross(y(kk,1:3),hipAxis(i,1:3)) / norm(cross(y(kk,1:3),hipAxis(i,1:3))); 
        z(kk,1:3) = cross(x(kk,1:3),y(kk,1:3));    
    % Sternum: z poining to distal (left), x pointing bw, y pointing up
        kk=3;
        z(kk,1:3) = d(kk+1,1:3)/norm(d(kk+1,1:3));
        strAxis = markers.C7 - markers.T10; % pointing up
        x(kk,1:3) = cross(strAxis(i,1:3),z(kk,1:3)) / norm(cross(strAxis(i,1:3),z(kk,1:3)));
        y(kk,1:3) = cross (z(kk,1:3),x(kk,1:3));
    % Shoulder(GH): y poining to -distal (up), x pointing bw, z pointing left
        kk=4;
        y(kk,1:3) = -d(kk+1,1:3)/norm(d(kk+1,1:3));
        elAxisX(i,1:3) = markers.LELB(i,1:3) - skl.LFArm(i,1:3); % elbow axis pointing lateral
        x(kk,1:3) = cross(y(kk,1:3),elAxisX(i,1:3)) / norm(cross(y(kk,1:3),elAxisX(i,1:3)));
        z(kk,1:3) = cross(x(kk,1:3),y(kk,1:3));
    % Elbow: y poining to -distal (up), x pointing fw, z pointing right
        kk=5;
        y(kk,1:3) = -d(kk+1,1:3)/norm(d(kk+1,1:3));
        % z(kk,1:3) = cross(d(kk,1:3),d(kk+1,1:3)) / norm(cross(d(kk,1:3),d(kk+1,1:3)));
        % x(kk,1:3) = cross(y(kk,1:3),z(kk,1:3));
        % % The above formula plip the axis in 180.
        x(kk,1:3) = cross(y(kk,1:3),elAxisX(i,1:3)) / norm(cross(y(kk,1:3),elAxisX(i,1:3)));
        z(kk,1:3) = cross (x(kk,1:3),y(kk,1:3));
    % Hand: y poining to -distal (away from fingers), x pointing inwards, z pointing to -pinky
        kk=6;
        wrAxis1 = markers.LWRA - markers.LWRB; % pointing lateral (medial: to thumb)
        y(kk,1:3) = -d(kk+1,1:3)/norm(d(kk+1,1:3));
        x(kk,1:3) = -cross(y(kk,1:3),wrAxis1(i,1:3)) / norm(cross(y(kk,1:3),wrAxis1(i,1:3)));
        z(kk,1:3) = cross (x(kk,1:3),y(kk,1:3));
    
    % Kinematics: Bones Frames
    for k=1:length(SegmentL)-1
        R(:,:,k) = [x(k,1:3);y(k,1:3);z(k,1:3)]';
        [out, varargout] = isrot(R(:,:,k)); 
        if ~isrot(R(:,:,k)) || anynan(R)
            baddata=baddata+1;
            fprintf('ROT matrix error: Frame%d (time=%d), In %s\n',i,t(i,1),SegmentL{k});
            fprintf('Error type: %s\n',varargout);
            R(:,:,k) = RR;
        end
        RR = R(:,:,k);
        tform(1:3,1:3,k) = R(:,:,k);
        tform(1:3,4,k) = p(k,1:3);
        tform(4,:,k) = [0 0 0 1];
    end
    
    if i==1     % % Visualize one frame
        for k=1:length(SegmentL)-1
            plot3 ([p(k,1) p(k+1,1)],[p(k,2) p(k+1,2)],[p(k,3) p(k+1,3)],'k')
            scatter3 (tform(1,4,k),tform(2,4,k),tform(3,4,k),"*")
            drawframe(tform(:,:,k),0.05)
            hold on
        end
    end  
    hold off
        
    % Kinematics: quaternions global (4:7), Angles local (14:17)
    for k=2:length(SegmentL)-1
        Rrel = (R(:,:,k-1)')*R(:,:,k);
        % Rrel = R(:,:,k)*(R(:,:,k-1)');
        skl.(SegmentL{k})(i,4:7) = rotm2quat (R(:,:,k));
        skl.(SegmentL{k})(i,14:17) = rotm2quat (Rrel);
        % [skl.(SegmentL{k})(i,11), skl.(SegmentL{k})(i,12), skl.(SegmentL{k})(i,13)] = quat2angle(quat);
        % skl.(SegmentL{k})(i,11:13) = 180/pi* skl.(SegmentL{k})(i,11:13);
        % if (SegmentL{k} == "LFArm") || (SegmentL{k} == "LHand")
        %     skl.(SegmentL{k})(i,11:13) = 180/pi*(rotm2eul(Rrel','zyx'));
        % else 
        %     skl.(SegmentL{k})(i,11:13) = 180/pi*(rotm2eul(Rrel','zyx'));
        % end
    end 
end 


% % % % Kinematics: quat to eul _ Angles global (8:10), Angles local (11:13)
Segment = {'LSternum','LUArm','LFArm','LHand','RSternum','RUArm','RFArm','RHand'};

for j=1:length(Segment)
    [skl.(Segment{j})(:,8), skl.(Segment{j})(:,9), skl.(Segment{j})(:,10)] = quat2angle(skl.(Segment{j})(:,4:7),"ZXY");
    [skl.(Segment{j})(:,11), skl.(Segment{j})(:,12), skl.(Segment{j})(:,13)] = quat2angle(skl.(Segment{j})(:,14:17),"yXY");
end

% % Modify eul sequence for each joint
% [skl.LSternum(:,11), skl.LSternum(:,12), skl.LSternum(:,13)] = quat2angle(skl.LSternum(:,14:17),"ZXY");
% [a(:,1), skl.LUArm(:,13), a(:,1)] = quat2angle(skl.LUArm(:,14:17),"xzy");
% [skl.LUArm(:,12), a(:,1), skl.LUArm(:,11)] = quat2angle(skl.LUArm(:,14:17),"yxy");
% [skl.LFArm(:,11), skl.LFArm(:,12), skl.LFArm(:,13)] = quat2angle(skl.LFArm(:,14:17),"zyz");
% [skl.LHand(:,11), skl.LHand(:,12), skl.LHand(:,13)] = quat2angle(skl.LHand(:,14:17),"ZXY");

% skl.LSternum (:,11:13) = 180/pi*rotm2eul(Rot_wrtProx(skl.Skeleton(:,14:17),skl.Sternum(:,14:17)),'zyz');
% skl.LUArm (:,11:13) = 180/pi*rotm2eul(Rot_wrtProx(skl.Sternum(:,14:17),skl.LUArm(:,14:17)),'zyz');
% skl.LFArm (:,11:13) = 180/pi*rotm2eul(Rot_wrtProx(skl.LUArm(:,14:17),skl.LFArm(:,14:17)),'zyz');
% skl.LHand (:,11:13) = 180/pi*rotm2eul(Rot_wrtProx(skl.LFArm(:,14:17),skl.LHand(:,14:17)),'zyz');
% skl.RSternum (:,11:13) = 180/pi*rotm2eul(Rot_wrtProx(skl.Skeleton(:,14:17),skl.Sternum(:,14:17)),'zyz');
% skl.RUArm (:,11:13) = 180/pi*rotm2eul(Rot_wrtProx(skl.Sternum(:,14:17),skl.RUArm(:,14:17)),'zyz');
% skl.RFArm (:,11:13) = 180/pi*rotm2eul(Rot_wrtProx(skl.LUArm(:,14:17),skl.RFArm(:,14:17)),'zyz');
% skl.RHand (:,11:13) = 180/pi*rotm2eul(Rot_wrtProx(skl.LFArm(:,14:17),skl.RHand(:,14:17)),'zyz');

for j=1:length(Segment)
    skl.(Segment{j})(:,8:13) = rad2deg (skl.(Segment{j})(:,8:13));
end
 
% % % Setting zero angles: starting position
% for j=1:length(Segment)
%     skl.(Segment{j})(:,11:13) = skl.(Segment{j})(:,11:13) - skl.(Segment{j})(1,11:13);
% end

% for k=2:length(Segment)-1
%     skl.(Segment{k})(:,8:10) =  checkRotations (skl.(Segment{k})(:,8:10));
%     skl.(Segment{k})(:,11:13) =  checkRotations (skl.(Segment{k})(:,11:13));        
% end 

% for k=1:length(Segment)
%     skl.(Segment{k})(:,11:13) = unwrap (skl.(Segment{k})(:,11:13));        
%     skl.(Segment{k})(:,11:13) = wrapTo180 (skl.(Segment{k})(:,11:13));        
% end 

for i=3:size(skl.Skeleton,1)
    for j=1:length(Segment)
        for k=8:13
            if (skl.(Segment{j})(i,k)-skl.(Segment{j})(i-1,k)) >= 160 %&& (arm.(Segment{j})(i,k)-arm.(Segment{j})(i-2,k)) >= 350 
                fprintf('PI-Flip: Frame%d (time=%d), In %s\n',i,t(i,1),Segment{j});
                skl.(Segment{j})(i,k) = skl.(Segment{j})(i,k)-180;
            elseif (skl.(Segment{j})(i,k)-skl.(Segment{j})(i-1,k)) <= -160 %&& (arm.(Segment{j})(i,k)-arm.(Segment{j})(i-2,k)) <= -350
                skl.(Segment{j})(i,k) = skl.(Segment{j})(i,k)+180;
            end 
        end
    end
end


baddata

sklAngles = skl;

end