function figAngRel (skl,RL,test)

% % % %  Arm 7DoF Angles of joints wrt eachother  % % % %
% % % %  Input skl, time, RL: right or left arm   % % % %
% % % %  test = actind / actfree / pas            % % % %

switch test
    case 'actind'
        text = 'ACTIVE: Individual ';
    case 'actfree'
        text = 'ACTIVE: Free form';
    case 'pas'
        text = 'PASSIVE: Individual';
    case 'active'
        text = 'ACTIVE';
    case 'passive'
        text = 'PASSIVE';
    case 'reach'
        text = 'REACH';
    otherwise
        disp('Err: Test not specified')
end

switch RL
    case 'l'
        figure
        t2 = tiledlayout(3,3);
        title (t2,text, 'Joint angles wrt EACHOTHER - Shoulder & Elbow')
        nexttile
        scatter (skl.LUArm(:,12),skl.LUArm(:,13),'.');
        xlabel('Shoulder AA')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl.LUArm(:,11),skl.LUArm(:,12),'.');
        xlabel('Shoulder Rot')
        ylabel('Shoulder AA')
        nexttile
        scatter (skl.LUArm(:,11),skl.LUArm(:,13),'.');
        xlabel('Shoulder Rot')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl.LFArm(:,11),skl.LUArm(:,12),'.');
        xlabel('Elbow FE')
        ylabel('Shoulder AA')
        nexttile
        scatter (skl.LFArm(:,11),skl.LUArm(:,13),'.');
        xlabel('Elbow FE')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl.LFArm(:,11),skl.LUArm(:,11),'.');
        xlabel('Elbow FE')
        ylabel('Shoulder Rot')
        nexttile
        scatter (skl.LFArm(:,13),skl.LUArm(:,12),'.');
        xlabel('Elbow PS')
        ylabel('Shoulder AA')
        nexttile
        scatter (skl.LFArm(:,13),skl.LUArm(:,13),'.');
        xlabel('Elbow PS')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl.LFArm(:,13),skl.LUArm(:,11),'.');
        xlabel('Elbow PS')
        ylabel('Shoulder Rot')
        
        figure
        t2 = tiledlayout(2,3);
        title (t2,text, 'Joint angles wrt EACHOTHER - Shoulder & Wrist')
        nexttile
        scatter (skl.LHand(:,12),skl.LUArm(:,12),'.');
        xlabel('Wrist FE')
        ylabel('Shoulder AA')
        nexttile
        scatter (skl.LHand(:,12),skl.LUArm(:,13),'.');
        xlabel('Wrist FE')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl.LHand(:,12),skl.LUArm(:,11),'.');
        xlabel('Wrist FE')
        ylabel('Shoulder Rot')
        nexttile
        scatter (skl.LHand(:,11),skl.LUArm(:,12),'.');
        xlabel('Wrist Dev')
        ylabel('Shoulder AA')
        nexttile
        scatter (skl.LHand(:,11),skl.LUArm(:,13),'.');
        xlabel('Wrist Dev')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl.LHand(:,11),skl.LUArm(:,11),'.');
        xlabel('Wrist Dev')
        ylabel('Shoulder Rot')
        
        figure
        t2 = tiledlayout(2,3);
        title (t2,text, 'Joint angles wrt EACHOTHER - Elbow & Wrist')
        nexttile
        scatter (skl.LFArm(:,11),skl.LFArm(:,13),'.');
        xlabel('Elbow FE')
        ylabel('Elbow SP')
        nexttile
        scatter (skl.LFArm(:,11),skl.LHand(:,12),'.');
        xlabel('Elbow FE')
        ylabel('Wrist FE')
        nexttile
        scatter (skl.LFArm(:,11),skl.LHand(:,11),'.');
        xlabel('Elbow FE')
        ylabel('Wrist Dev')
        nexttile
        scatter (skl.LFArm(:,13),skl.LHand(:,12),'.');
        xlabel('Elbow PS')
        ylabel('Wrist FE')
        nexttile
        scatter (skl.LFArm(:,13),skl.LHand(:,11),'.');
        xlabel('Elbow PS')
        ylabel('Wrist Dev')
        nexttile
        scatter (skl.LHand(:,12),skl.LHand(:,11),'.');
        xlabel('Wrist FE')
        ylabel('Wrist Dev')

    case 'r'
        figure
        t2 = tiledlayout(3,3);
        title (t2,text, 'Joint angles wrt EACHOTHER - Shoulder & Elbow')
        nexttile
        scatter (skl.RUArm(:,12),skl.RUArm(:,13),'.');
        xlabel('Shoulder AA')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl.RUArm(:,11),skl.RUArm(:,12),'.');
        xlabel('Shoulder Rot')
        ylabel('Shoulder AA')
        nexttile
        scatter (skl.RUArm(:,11),skl.RUArm(:,13),'.');
        xlabel('Shoulder Rot')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl.RFArm(:,11),skl.RUArm(:,12),'.');
        xlabel('Elbow FE')
        ylabel('Shoulder AA')
        nexttile
        scatter (skl.RFArm(:,11),skl.RUArm(:,13),'.');
        xlabel('Elbow FE')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl.RFArm(:,11),skl.RUArm(:,11),'.');
        xlabel('Elbow FE')
        ylabel('Shoulder Rot')
        pbaspect ([1 1 1])
        daspect ([1 1 1])
        nexttile
        scatter (skl.RFArm(:,13),skl.RUArm(:,12),'.');
        xlabel('Elbow PS')
        ylabel('Shoulder AA')
        nexttile
        scatter (skl.RFArm(:,13),skl.RUArm(:,13),'.');
        xlabel('Elbow PS')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl.RFArm(:,13),skl.RUArm(:,11),'.');
        xlabel('Elbow PS')
        ylabel('Shoulder Rot')
        
        figure
        t2 = tiledlayout(2,3);
        title (t2,text, 'Joint angles wrt EACHOTHER - Shoulder & Wrist')
        nexttile
        scatter (skl.RHand(:,12),skl.RUArm(:,12),'.');
        xlabel('Wrist FE')
        ylabel('Shoulder AA')
        nexttile
        scatter (skl.RHand(:,12),skl.RUArm(:,13),'.');
        xlabel('Wrist FE')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl.RHand(:,12),skl.RUArm(:,11),'.');
        xlabel('Wrist FE')
        ylabel('Shoulder Rot')
        nexttile
        scatter (skl.RHand(:,11),skl.RUArm(:,12),'.');
        xlabel('Wrist Dev')
        ylabel('Shoulder AA')
        nexttile
        scatter (skl.RHand(:,11),skl.RUArm(:,13),'.');
        xlabel('Wrist Dev')
        ylabel('Shoulder FE')
        nexttile
        scatter (skl.RHand(:,11),skl.RUArm(:,11),'.');
        xlabel('Wrist Dev')
        ylabel('Shoulder Rot')
        
        figure
        t2 = tiledlayout(2,3);
        title (t2,text, 'Joint angles wrt EACHOTHER - Elbow & Wrist')
        nexttile
        scatter (skl.RFArm(:,11),skl.RFArm(:,13),'.');
        xlabel('Elbow FE')
        ylabel('Elbow SP')
        nexttile
        scatter (skl.RFArm(:,11),skl.RHand(:,12),'.');
        xlabel('Elbow FE')
        ylabel('Wrist FE')
        nexttile
        scatter (skl.RFArm(:,11),skl.RHand(:,11),'.');
        xlabel('Elbow FE')
        ylabel('Wrist Dev')
        nexttile
        scatter (skl.RFArm(:,13),skl.RHand(:,12),'.');
        xlabel('Elbow PS')
        ylabel('Wrist FE')
        nexttile
        scatter (skl.RFArm(:,13),skl.RHand(:,11),'.');
        xlabel('Elbow PS')
        ylabel('Wrist Dev')
        nexttile
        scatter (skl.RHand(:,12),skl.RHand(:,11),'.');
        xlabel('Wrist FE')
        ylabel('Wrist Dev')

    otherwise
        disp('Err: Right/Left not specified')
end

end