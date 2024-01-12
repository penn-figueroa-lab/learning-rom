function figRoM_compareTests (test1, test2, figtitle)

% % % %  7DoF Joint Angles of two tests on the same graph  % % % %
% % % %  Inputs: ROM of two tests, and figure title        % % % %

figure
t = tiledlayout(3,3);
title (t, figtitle)
nexttile
scatter (test1(:,2),test1(:,3),'.');
hold on
scatter (test2(:,2),test2(:,3),'r.','SizeData',8);
xlabel('Shoulder AA')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,1),test1(:,2),'.');
hold on
scatter (test2(:,1),test2(:,2),'r.','SizeData',8);
xlabel('Shoulder Rot')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,1),test1(:,3),'.');
hold on
scatter (test2(:,1),test2(:,3),'r.','SizeData',8);
xlabel('Shoulder Rot')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,4),test1(:,2),'.');
hold on
scatter (test2(:,4),test2(:,2),'r.','SizeData',8);
xlabel('Elbow FE')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,4),test1(:,3),'.');
hold on
scatter (test2(:,4),test2(:,3),'r.','SizeData',8);
xlabel('Elbow FE')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,4),test1(:,1),'.');
hold on
scatter (test2(:,4),test2(:,1),'r.','SizeData',8);
xlabel('Elbow FE')
ylabel('Shoulder Rot')
nexttile
scatter (test1(:,5),test1(:,2),'.');
hold on
scatter (test2(:,5),test2(:,2),'r.','SizeData',8);
xlabel('Elbow PS')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,5),test1(:,3),'.');
hold on
scatter (test2(:,5),test2(:,3),'r.','SizeData',8);
xlabel('Elbow PS')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,5),test1(:,1),'.');
hold on
scatter (test2(:,5),test2(:,1),'r.','SizeData',8);
xlabel('Elbow PS')
ylabel('Shoulder Rot')

figure
t = tiledlayout(2,3);
title (t, figtitle)
nexttile
scatter (test1(:,6),test1(:,2),'.');
hold on
scatter (test2(:,6),test2(:,2),'r.','SizeData',8);
xlabel('Wrist FE')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,6),test1(:,3),'.');
hold on
scatter (test2(:,6),test2(:,3),'r.','SizeData',8);
xlabel('Wrist FE')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,6),test1(:,1),'.');
hold on
scatter (test2(:,6),test2(:,1),'r.','SizeData',8);
xlabel('Wrist FE')
ylabel('Shoulder Rot')
nexttile
scatter (test1(:,7),test1(:,2),'.');
hold on
scatter (test2(:,7),test2(:,2),'r.','SizeData',8);
xlabel('Wrist Dev')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,7),test1(:,3),'.');
hold on
scatter (test2(:,7),test2(:,3),'r.','SizeData',8);
xlabel('Wrist Dev')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,7),test1(:,1),'.');
hold on
scatter (test2(:,7),test2(:,1),'r.','SizeData',8);
xlabel('Wrist Dev')
ylabel('Shoulder Rot')

figure
t = tiledlayout(2,3);
title (t, figtitle)
nexttile
scatter (test1(:,4),test1(:,5),'.');
hold on
scatter (test2(:,4),test2(:,5),'r.','SizeData',8);
xlabel('Elbow FE')
ylabel('Elbow SP')
nexttile
scatter (test1(:,4),test1(:,6),'.');
hold on
scatter (test2(:,4),test2(:,6),'r.','SizeData',8);
xlabel('Elbow FE')
ylabel('Wrist FE')
nexttile
scatter (test1(:,4),test1(:,7),'.');
hold on
scatter (test2(:,4),test2(:,7),'r.','SizeData',8);
xlabel('Elbow FE')
ylabel('Wrist Dev')
nexttile
scatter (test1(:,5),test1(:,6),'.');
hold on
scatter (test2(:,5),test2(:,6),'r.','SizeData',8);
xlabel('Elbow PS')
ylabel('Wrist FE')
nexttile
scatter (test1(:,5),test1(:,7),'.');
hold on
scatter (test2(:,5),test2(:,7),'r.','SizeData',8);
xlabel('Elbow PS')
ylabel('Wrist Dev')
nexttile
scatter (test1(:,6),test1(:,7),'.');
hold on
scatter (test2(:,6),test2(:,7),'r.','SizeData',8);
xlabel('Wrist FE')
ylabel('Wrist Dev')

end