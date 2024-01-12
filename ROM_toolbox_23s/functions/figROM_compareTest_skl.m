function figRoM (skl1, skl2, RL)

% % % %  7DoF Joint Angles of two tests on the same graph  % % % %
% % % %  Input skl of two tests, RL: right or left arm     % % % %


switch RL
    case 'l'
        figure
        t = tiledlayout(3,3);
        title (t, 'Joint angles wrt EACHOTHER - Shoulder & Elbow')
        nexttile
        scatter (skl1.LUArm(:,12),skl1.LUArm(:,13),'.');
        hold on
        scatter (skl2.LUArm(:,12),skl2.LUArm(:,13),'r.');
        xlabel('Shoulder AA')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl1.LUArm(:,11),skl1.LUArm(:,12),'.');
        hold on
        scatter (skl2.LUArm(:,11),skl2.LUArm(:,12),'r.');
        xlabel('Shoulder Rot')
        ylabel('Shoulder AA')
        nexttile
        scatter (skl1.LUArm(:,11),skl1.LUArm(:,13),'.');
        hold on
        scatter (skl2.LUArm(:,11),skl2.LUArm(:,13),'r.');
        xlabel('Shoulder Rot')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl1.LFArm(:,11),skl1.LUArm(:,12),'.');
        hold on
        scatter (skl2.LFArm(:,11),skl2.LUArm(:,12),'r.');
        xlabel('Elbow FE')
        ylabel('Shoulder AA')
        nexttile
        scatter (skl1.LFArm(:,11),skl1.LUArm(:,13),'.');
        hold on
        scatter (skl2.LFArm(:,11),skl2.LUArm(:,13),'r.');
        xlabel('Elbow FE')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl1.LFArm(:,11),skl1.LUArm(:,11),'.');
        hold on
        scatter (skl2.LFArm(:,11),skl2.LUArm(:,11),'r.');
        xlabel('Elbow FE')
        ylabel('Shoulder Rot')
        nexttile
        scatter (skl1.LFArm(:,13),skl1.LUArm(:,12),'.');
        hold on
        scatter (skl2.LFArm(:,13),skl2.LUArm(:,12),'r.');
        xlabel('Elbow PS')
        ylabel('Shoulder AA')
        nexttile
        scatter (skl1.LFArm(:,13),skl1.LUArm(:,13),'.');
        hold on
        scatter (skl2.LFArm(:,13),skl2.LUArm(:,13),'r.');
        xlabel('Elbow PS')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl1.LFArm(:,13),skl1.LUArm(:,11),'.');
        hold on
        scatter (skl2.LFArm(:,13),skl2.LUArm(:,11),'r.');
        xlabel('Elbow PS')
        ylabel('Shoulder Rot')
        
        figure
        t = tiledlayout(2,3);
        title (t, 'Joint angles wrt EACHOTHER - Shoulder & Wrist')
        nexttile
        scatter (skl1.LHand(:,12),skl1.LUArm(:,12),'.');
        hold on
        scatter (skl2.LHand(:,12),skl2.LUArm(:,12),'r.');
        xlabel('Wrist FE')
        ylabel('Shoulder AA')
        nexttile
        scatter (skl1.LHand(:,12),skl1.LUArm(:,13),'.');
        hold on
        scatter (skl2.LHand(:,12),skl2.LUArm(:,13),'r.');
        xlabel('Wrist FE')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl1.LHand(:,12),skl1.LUArm(:,11),'.');
        hold on
        scatter (skl2.LHand(:,12),skl2.LUArm(:,11),'r.');
        xlabel('Wrist FE')
        ylabel('Shoulder Rot')
        nexttile
        scatter (skl1.LHand(:,11),skl1.LUArm(:,12),'.');
        hold on
        scatter (skl2.LHand(:,11),skl2.LUArm(:,12),'r.');
        xlabel('Wrist Dev')
        ylabel('Shoulder AA')
        nexttile
        scatter (skl1.LHand(:,11),skl1.LUArm(:,13),'.');
        hold on
        scatter (skl2.LHand(:,11),skl2.LUArm(:,13),'r.');
        xlabel('Wrist Dev')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl1.LHand(:,11),skl1.LUArm(:,11),'.');
        hold on
        scatter (skl2.LHand(:,11),skl2.LUArm(:,11),'r.');
        xlabel('Wrist Dev')
        ylabel('Shoulder Rot')
        
        figure
        t = tiledlayout(2,3);
        title (t, 'Joint angles wrt EACHOTHER - Elbow & Wrist')
        nexttile
        scatter (skl1.LFArm(:,11),skl1.LFArm(:,13),'.');
        hold on
        scatter (skl2.LFArm(:,11),skl2.LFArm(:,13),'r.');
        xlabel('Elbow FE')
        ylabel('Elbow SP')
        nexttile
        scatter (skl1.LFArm(:,11),skl1.LHand(:,12),'.');
        hold on
        scatter (skl2.LFArm(:,11),skl2.LHand(:,12),'r.');
        xlabel('Elbow FE')
        ylabel('Wrist FE')
        nexttile
        scatter (skl1.LFArm(:,11),skl1.LHand(:,11),'.');
        hold on
        scatter (skl2.LFArm(:,11),skl2.LHand(:,11),'r.');
        xlabel('Elbow FE')
        ylabel('Wrist Dev')
        nexttile
        scatter (skl1.LFArm(:,13),skl1.LHand(:,12),'.');
        hold on
        scatter (skl2.LFArm(:,13),skl2.LHand(:,12),'r.');
        xlabel('Elbow PS')
        ylabel('Wrist FE')
        nexttile
        scatter (skl1.LFArm(:,13),skl1.LHand(:,11),'.');
        hold on
        scatter (skl2.LFArm(:,13),skl2.LHand(:,11),'r.');
        xlabel('Elbow PS')
        ylabel('Wrist Dev')
        nexttile
        scatter (skl1.LHand(:,12),skl1.LHand(:,11),'.');
        hold on
        scatter (skl2.LHand(:,12),skl2.LHand(:,11),'r.');
        xlabel('Wrist FE')
        ylabel('Wrist Dev')

    case 'r'
        figure
        t = tiledlayout(3,3);
        title (t, 'Joint angles wrt EACHOTHER - Shoulder & Elbow')
        nexttile
        scatter (skl1.RUArm(:,12),skl1.RUArm(:,13),'.');
        hold on
        scatter (skl2.RUArm(:,12),skl2.RUArm(:,13),'r.');
        xlabel('Shoulder AA')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl1.RUArm(:,11),skl1.RUArm(:,12),'.');
        hold on
        scatter (skl2.RUArm(:,11),skl2.RUArm(:,12),'r.');
        xlabel('Shoulder Rot')
        ylabel('Shoulder AA')
        nexttile
        scatter (skl1.RUArm(:,11),skl1.RUArm(:,13),'.');
        hold on
        scatter (skl2.RUArm(:,11),skl2.RUArm(:,13),'r.');
        xlabel('Shoulder Rot')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl1.RFArm(:,11),skl1.RUArm(:,12),'.');
        hold on
        scatter (skl2.RFArm(:,11),skl2.RUArm(:,12),'r.');
        xlabel('Elbow FE')
        ylabel('Shoulder AA')
        nexttile
        scatter (skl1.RFArm(:,11),skl1.RUArm(:,13),'.');
        hold on
        scatter (skl2.RFArm(:,11),skl2.RUArm(:,13),'r.');
        xlabel('Elbow FE')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl1.RFArm(:,11),skl1.RUArm(:,11),'.');
        hold on
        scatter (skl2.RFArm(:,11),skl2.RUArm(:,11),'r.');
        xlabel('Elbow FE')
        ylabel('Shoulder Rot')
        nexttile
        scatter (skl1.RFArm(:,13),skl1.RUArm(:,12),'.');
        hold on
        scatter (skl2.RFArm(:,13),skl2.RUArm(:,12),'r.');
        xlabel('Elbow PS')
        ylabel('Shoulder AA')
        nexttile
        scatter (skl1.RFArm(:,13),skl1.RUArm(:,13),'.');
        hold on
        scatter (skl2.RFArm(:,13),skl2.RUArm(:,13),'r.');
        xlabel('Elbow PS')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl1.RFArm(:,13),skl1.RUArm(:,11),'.');
        hold on
        scatter (skl2.RFArm(:,13),skl2.RUArm(:,11),'r.');
        xlabel('Elbow PS')
        ylabel('Shoulder Rot')
        
        figure
        t = tiledlayout(2,3);
        title (t, 'Joint angles wrt EACHOTHER - Shoulder & Wrist')
        nexttile
        scatter (skl1.RHand(:,12),skl1.RUArm(:,12),'.');
        hold on
        scatter (skl2.RHand(:,12),skl2.RUArm(:,12),'r.');
        xlabel('Wrist FE')
        ylabel('Shoulder AA')
        nexttile
        scatter (skl1.RHand(:,12),skl1.RUArm(:,13),'.');
        hold on
        scatter (skl2.RHand(:,12),skl2.RUArm(:,13),'r.');
        xlabel('Wrist FE')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl1.RHand(:,12),skl1.RUArm(:,11),'.');
        hold on
        scatter (skl2.RHand(:,12),skl2.RUArm(:,11),'r.');
        xlabel('Wrist FE')
        ylabel('Shoulder Rot')
        nexttile
        scatter (skl1.RHand(:,11),skl1.RUArm(:,12),'.');
        hold on
        scatter (skl2.RHand(:,11),skl2.RUArm(:,12),'r.');
        xlabel('Wrist Dev')
        ylabel('Shoulder AA')
        nexttile
        scatter (skl1.RHand(:,11),skl1.RUArm(:,13),'.');
        hold on
        scatter (skl2.RHand(:,11),skl2.RUArm(:,13),'r.');
        xlabel('Wrist Dev')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl1.RHand(:,11),skl1.RUArm(:,11),'.');
        hold on
        scatter (skl2.RHand(:,11),skl2.RUArm(:,11),'r.');
        xlabel('Wrist Dev')
        ylabel('Shoulder Rot')
        
        figure
        t = tiledlayout(2,3);
        title (t, 'Joint angles wrt EACHOTHER - Elbow & Wrist')
        nexttile
        scatter (skl1.RFArm(:,11),skl1.RFArm(:,13),'.');
        hold on
        scatter (skl2.RFArm(:,11),skl2.RFArm(:,13),'r.');
        xlabel('Elbow FE')
        ylabel('Elbow SP')
        nexttile
        scatter (skl1.RFArm(:,11),skl1.RHand(:,12),'.');
        hold on
        scatter (skl2.RFArm(:,11),skl2.RHand(:,12),'r.');
        xlabel('Elbow FE')
        ylabel('Wrist FE')
        nexttile
        scatter (skl1.RFArm(:,11),skl1.RHand(:,11),'.');
        hold on
        scatter (skl2.RFArm(:,11),skl2.RHand(:,11),'r.');
        xlabel('Elbow FE')
        ylabel('Wrist Dev')
        nexttile
        scatter (skl1.RFArm(:,13),skl1.RHand(:,12),'.');
        hold on
        scatter (skl2.RFArm(:,13),skl2.RHand(:,12),'r.');
        xlabel('Elbow PS')
        ylabel('Wrist FE')
        nexttile
        scatter (skl1.RFArm(:,13),skl1.RHand(:,11),'.');
        hold on
        scatter (skl2.RFArm(:,13),skl2.RHand(:,11),'r.');
        xlabel('Elbow PS')
        ylabel('Wrist Dev')
        nexttile
        scatter (skl1.RHand(:,12),skl1.RHand(:,11),'.');
        hold on
        scatter (skl2.RHand(:,12),skl2.RHand(:,11),'r.');
        xlabel('Wrist FE')
        ylabel('Wrist Dev')

    otherwise
        disp('Err: Right/Left not specified')
end

end