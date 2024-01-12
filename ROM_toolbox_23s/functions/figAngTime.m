function figAngTime (skl,t,RL,test)

% % % %  Arm 7DoF Angles of joints wrt TIME       % % % %
% % % %  Input skl, time, RL: right or left arm   % % % %
% % % %  test = actind / actfree / pas / reach    % % % %

switch test
    case 'actind'
        text = 'ACTIVE: Individual ';
    case 'actfree'
        text = 'ACTIVE: Free form';
    case 'act'
        text = 'ACTIVE:';
    case 'pas'
        text = 'PASSIVE: Individual';
    case 'reach'
        text = 'REACH';
    otherwise
        disp('Err: Test not specified')
end

switch RL
    case 'l'
        figure
        tile = tiledlayout(3,3);
        title(tile, text)
        nexttile
        plot (t(:,1),skl.LUArm(:,11)); 
        xlabel('time (s)')
        title('Shoulder Ext+/int- Rotation (rot of UA long. ax)')
        nexttile
        plot (t(:,1),skl.LUArm(:,12)); 
        xlabel('time (s)')
        title('Shoulder Abduction+/Adduction- (Lateral motion)')
        nexttile
        plot (t(:,1),skl.LUArm(:,13)); 
        xlabel('time (s)')
        title('Shoulder Extension+/Flexion- (Forward motion)')
        nexttile
        plot (t(:,1),skl.LFArm(:,11)); 
        xlabel('time (s)')
        title('Elbow Extension+/Flexion-')
        nexttile
        plot (t(:,1),skl.LFArm(:,12)); 
        xlabel('time (s)')
        title('Elbow Deviation (must =zero)')
        nexttile
        plot (t(:,1),skl.LFArm(:,13)); 
        xlabel('time (s)')
        title('Elbow Supination+/Pronation- (rot of UF long. ax)')
        nexttile
        plot (t(:,1),skl.LHand(:,11)); 
        xlabel('time (s)')
        title('Wrist Ulnar+/Radial- Deviation')
        nexttile
        plot (t(:,1),skl.LHand(:,12)); 
        xlabel('time (s)')
        title('Wrist Extension+/Flexion-')
        nexttile
        plot (t(:,1),skl.LHand(:,13)); 
        xlabel('time (s)')
        title('Wrist Supination+/Pronation- (= ElbowSP but less accurate)')

    case 'r'
        figure
        tile = tiledlayout(3,3);
        title(tile, text)
        nexttile
        plot (t(:,1),skl.RUArm(:,11)); 
        xlabel('time (s)')
        title('Shoulder Ext+/int- Rotation (rot of UA long. ax)')
        nexttile
        plot (t(:,1),skl.RUArm(:,12)); 
        xlabel('time (s)')
        title('Shoulder Abduction+/Adduction- (Lateral motion)')
        nexttile
        plot (t(:,1),skl.RUArm(:,13)); 
        xlabel('time (s)')
        title('Shoulder Extension+/Flexion- (Forward motion)')
        nexttile
        plot (t(:,1),skl.RFArm(:,11)); 
        xlabel('time (s)')
        title('Elbow Extension+/Flexion-')
        nexttile
        plot (t(:,1),skl.RFArm(:,12)); 
        xlabel('time (s)')
        title('Elbow Deviation (must =zero)')
        nexttile
        plot (t(:,1),skl.RFArm(:,13)); 
        xlabel('time (s)')
        title('Elbow Supination+/Pronation- (rot of UF long. ax)')
        nexttile
        plot (t(:,1),skl.RHand(:,11)); 
        xlabel('time (s)')
        title('Wrist Ulnar+/Radial- Deviation')
        nexttile
        plot (t(:,1),skl.RHand(:,12)); 
        xlabel('time (s)')
        title('Wrist Extension+/Flexion-')
        nexttile
        plot (t(:,1),skl.RHand(:,13)); 
        xlabel('time (s)')
        title('Wrist Supination+/Pronation- (= ElbowSP but less accurate)')

    otherwise
        disp('Err: Right/Left not specified')

end