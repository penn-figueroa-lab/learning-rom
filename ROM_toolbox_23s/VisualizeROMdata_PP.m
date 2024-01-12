clc, clear, close all
addpath (genpath('.\'))

path = '.\Datasets\PosePrior Dataset\datasets\bvh\*\*.bvh';
dataDir = dir(path);
% [skel, channels, frameLength] = bvhReadFile(dataDir(1).name);
% xyz = bvh2xyz(skel, channels);
% armR = channels(:,[16:19,22:24]); 
% armL = channels(:,[31:34,37:39]); 
% channels = smoothAngleChannels(channels, skel);
% handle = skelVisualise(channels, skel);
% skelPlayData(skel, channels, frameLength)
% bvhPlayData(skel, channels, frameLength)

armR = [];
armL = [];
armR_smooth = [];
armL_smooth = [];
take_name = [];
take_ind = [];
ind_i = 0;

% S03104: i = [176:183,190:191] %[176:183,190:203,205:215,218:221] %222:232 

tic
for i = 167:171 %[176:183,190:203,205:215,218:221] %size({dataDir.name},2)
    [skel, channels, frameLength] = bvhReadFile(dataDir(i).name);
    armL_i = channels(:,13:24); 
    armR_i = channels(:,28:39); 
    armL = [armL; armL_i];
    armR = [armR; armR_i];
    channels_smooth = smoothAngleChannels(channels, skel);
    armL_i_smooth = channels_smooth(:,13:24); 
    armR_i_smooth = channels_smooth(:,28:39); 
    armL_smooth = [armL_smooth; armL_i_smooth];
    armR_smooth = [armR_smooth; armR_i_smooth];
    ind_i = ind_i + length(channels);
    take_ind = [take_ind, ind_i];
    take_name = [take_name, erase(string(dataDir(i).name),'.bvh')];
end
toc
fr = 1:length(armR);

%% Visualize - all 12 channels (Shoulder, UpperArm, ForeArm, Hand)
% % to remove inappropriate takes

figurepath = '.\figures\Other datasets\PosePrior_dataset\';
figtitle = {'PosePrior dataset - 03103: channels wrt fr', ...
    'RIGHT(black) ~~ LEFT(blue) ~~ dashed: smoothAngleChannel'};

RvFr1 = armR;
RvFr2 = armR_smooth;
LvFr1 = armL;
LvFr2 = armL_smooth;

figure('Position', get(0, 'Screensize'))
t = tiledlayout(2,3);
title (t, figtitle)
nexttile
plot (fr,RvFr1(:,1),'k',fr,RvFr2(:,1),'k--',fr,LvFr1(:,1),'b',fr,LvFr2(:,1),'b--');
hold on
xline (take_ind,'r-',take_name,'LabelHorizontalAlignment','left')
ylabel('Clavicle X (xyz)')
nexttile
plot (fr,RvFr1(:,2),'k',fr,RvFr2(:,2),'k--',fr,LvFr1(:,2),'b',fr,LvFr2(:,2),'b--');
hold on
xline (take_ind,'r-',take_name,'LabelHorizontalAlignment','left')
ylabel('Clavicle Y (xyz)')
nexttile
plot (fr,RvFr1(:,3),'k',fr,RvFr2(:,3),'k--',fr,LvFr1(:,3),'b',fr,LvFr2(:,3),'b--');
hold on
xline (take_ind,'r-',take_name,'LabelHorizontalAlignment','left')
ylabel('Clavicle Z (xyz)')
nexttile
plot (fr,RvFr1(:,4),'k',fr,RvFr2(:,4),'k--',fr,LvFr1(:,4),'b',fr,LvFr2(:,4),'b--');
hold on
xline (take_ind,'r-',take_name,'LabelHorizontalAlignment','left')
ylabel('Shoulder X (xyz)')
nexttile
plot (fr,RvFr1(:,5),'k',fr,RvFr2(:,5),'k--',fr,LvFr1(:,5),'b',fr,LvFr2(:,5),'b--');
hold on
xline (take_ind,'r-',take_name,'LabelHorizontalAlignment','left')
ylabel('Shoulder Y (xyz)')
nexttile
plot (fr,RvFr1(:,6),'k',fr,RvFr2(:,6),'k--',fr,LvFr1(:,6),'b',fr,LvFr2(:,6),'b--');
hold on
xline (take_ind,'r-',take_name,'LabelHorizontalAlignment','left')
ylabel('Shoulder Z (xyz)')
saveas(gcf,fullfile(figurepath,'03103_wrt_Frame_1.jpeg'));

figure('Position', get(0, 'Screensize'))
t = tiledlayout(2,3);
title (t, figtitle)
nexttile
plot (fr,RvFr1(:,7),'k',fr,RvFr2(:,7),'k--',fr,LvFr1(:,7),'b',fr,LvFr2(:,7),'b--');
hold on
xline (take_ind,'r-',take_name,'LabelHorizontalAlignment','left')
ylabel('Elbow Z (yzx)')
nexttile
plot (fr,RvFr1(:,8),'k',fr,RvFr2(:,8),'k--',fr,LvFr1(:,8),'b',fr,LvFr2(:,8),'b--');
hold on
xline (take_ind,'r-',take_name,'LabelHorizontalAlignment','left')
ylabel('Elbow X (yzx)')
nexttile
plot (fr,RvFr1(:,9),'k',fr,RvFr2(:,9),'k--',fr,LvFr1(:,9),'b',fr,LvFr2(:,9),'b--');
hold on
xline (take_ind,'r-',take_name,'LabelHorizontalAlignment','left')
ylabel('Elbow Y (yzx)')
nexttile
plot (fr,RvFr1(:,10),'k',fr,RvFr2(:,10),'k--',fr,LvFr1(:,10),'b',fr,LvFr2(:,10),'b--');
hold on
xline (take_ind,'r-',take_name,'LabelHorizontalAlignment','left')
ylabel('Wrist X (xyz)')
nexttile
plot (fr,RvFr1(:,11),'k',fr,RvFr2(:,11),'k--',fr,LvFr1(:,11),'b',fr,LvFr2(:,11),'b--');
hold on
xline (take_ind,'r-',take_name,'LabelHorizontalAlignment','left')
ylabel('Wrist Y (xyz)')
nexttile
plot (fr,RvFr1(:,12),'k',fr,RvFr2(:,12),'k--',fr,LvFr1(:,12),'b',fr,LvFr2(:,12),'b--');
hold on
xline (take_ind,'r-',take_name,'LabelHorizontalAlignment','left')
ylabel('Wrist Z (xyz)')
% saveas(gcf,fullfile(figurepath,'03103_wrt_Frame_2.jpeg'));

% %%
% k = 6;
% armR_cl = removerows(armR,'ind',take_ind(k-1)+1:take_ind(12));
% armL_cl = removerows(armL,'ind',take_ind(k-1)+1:take_ind(12));
% armR_cl_smooth = removerows(armR_smooth,'ind',take_ind(k-1)+1:take_ind(12));
% armL_cl_smooth = removerows(armL_smooth,'ind',take_ind(k-1)+1:take_ind(12));
% 
% %
% figurepath = '.\figures\Other datasets\PosePrior_dataset\';
% figtitle = {'PosePrior dataset - 03103 (file uar1.bvh removed): channels wrt fr', ...
%     'RIGHT(black) ~~ LEFT(blue) ~~ dashed: smoothAngleChannel'};
% 
% fr = 1:length(armR_cl);
% RvFr1 = armR_cl;
% RvFr2 = armR_cl_smooth;
% LvFr1 = armL_cl;
% LvFr2 = armL_cl_smooth;
% 
% figure('Position', get(0, 'Screensize'))
% t = tiledlayout(2,3);
% title (t, figtitle)
% nexttile
% plot (fr,RvFr1(:,1),'k',fr,RvFr2(:,1),'k--',fr,LvFr1(:,1),'b',fr,LvFr2(:,1),'b--');
% ylabel('Clavicle X (xyz)')
% nexttile
% plot (fr,RvFr1(:,2),'k',fr,RvFr2(:,2),'k--',fr,LvFr1(:,2),'b',fr,LvFr2(:,2),'b--');
% ylabel('Clavicle Y (xyz)')
% nexttile
% plot (fr,RvFr1(:,3),'k',fr,RvFr2(:,3),'k--',fr,LvFr1(:,3),'b',fr,LvFr2(:,3),'b--');
% ylabel('Clavicle Z (xyz)')
% nexttile
% plot (fr,RvFr1(:,4),'k',fr,RvFr2(:,4),'k--',fr,LvFr1(:,4),'b',fr,LvFr2(:,4),'b--');
% ylabel('Shoulder X (xyz)')
% nexttile
% plot (fr,RvFr1(:,5),'k',fr,RvFr2(:,5),'k--',fr,LvFr1(:,5),'b',fr,LvFr2(:,5),'b--');
% ylabel('Shoulder Y (xyz)')
% nexttile
% plot (fr,RvFr1(:,6),'k',fr,RvFr2(:,6),'k--',fr,LvFr1(:,6),'b',fr,LvFr2(:,6),'b--');
% ylabel('Shoulder Z (xyz)')
% saveas(gcf,fullfile(figurepath,'03103_wrt_Frame_edited_1.jpeg'));
% 
% figure('Position', get(0, 'Screensize'))
% t = tiledlayout(2,3);
% title (t, figtitle)
% nexttile
% plot (fr,RvFr1(:,7),'k',fr,RvFr2(:,7),'k--',fr,LvFr1(:,7),'b',fr,LvFr2(:,7),'b--');
% ylabel('Elbow Z (yzx)')
% nexttile
% plot (fr,RvFr1(:,8),'k',fr,RvFr2(:,8),'k--',fr,LvFr1(:,8),'b',fr,LvFr2(:,8),'b--');
% ylabel('Elbow X (yzx)')
% nexttile
% plot (fr,RvFr1(:,9),'k',fr,RvFr2(:,9),'k--',fr,LvFr1(:,9),'b',fr,LvFr2(:,9),'b--');
% ylabel('Elbow Y (yzx)')
% nexttile
% plot (fr,RvFr1(:,10),'k',fr,RvFr2(:,10),'k--',fr,LvFr1(:,10),'b',fr,LvFr2(:,10),'b--');
% ylabel('Wrist X (xyz)')
% nexttile
% plot (fr,RvFr1(:,11),'k',fr,RvFr2(:,11),'k--',fr,LvFr1(:,11),'b',fr,LvFr2(:,11),'b--');
% ylabel('Wrist Y (xyz)')
% nexttile
% plot (fr,RvFr1(:,12),'k',fr,RvFr2(:,12),'k--',fr,LvFr1(:,12),'b',fr,LvFr2(:,12),'b--');
% ylabel('Wrist Z (xyz)')
% saveas(gcf,fullfile(figurepath,'03103_wrt_Frame_edited_2.jpeg'));
% 


%% Visualize - 7DoF for both arms
% ShRot, ShAA, ShFE, ElFE, ElPS, WrFE, WrDev 
PP_armR = armR(:,[5,6,4,7,9,12,10]);
PP_armL = armL(:,[5,6,4,7,9,12,10]);
PP_armR(:,[1,3,5,6,7]) = -PP_armR(:,[1,3,5,6,7]);
PP_armR(:,2) = -PP_armR(:,2) - armR(:,3) + 90;
PP_armL(:,[3,4,5,7]) = -PP_armL(:,[3,4,5,7]);
PP_armL(:,2) = PP_armL(:,2) + armL(:,3) + 90;

% PP_armR = wrapTo180(PP_armR);
% PP_armL = wrapTo180(PP_armL);

test1 = PP_armR;
test2 = PP_armL;

figtitle = {'PosePrior dataset - 03103: channels wrt fr', ...
    'RIGHT(black) ~~ LEFT(blue)'};

figure('Position', get(0, 'Screensize'))
t = tiledlayout(3,3);
title (t, figtitle)
nexttile
plot (fr,test1(:,1),'k',fr,test2(:,1),'b');
ylabel('Shoulder X (xyz)')
nexttile
plot (fr,test1(:,2),'k',fr,test2(:,2),'b');
ylabel('Shoulder Y (xyz)')
nexttile
plot (fr,test1(:,3),'k',fr,test2(:,3),'b');
ylabel('Shoulder Z (xyz)')
nexttile
plot (fr,test1(:,4),'k',fr,test2(:,4),'b');
ylabel('Elbow Z (yzx)')
nexttile
plot (fr,test1(:,5),'k',fr,test2(:,5),'b');
ylabel('Elbow Y (yzx)')
nexttile
plot (fr,test1(:,6),'k',fr,test2(:,6),'b');
ylabel('Wrist X (xyz)')
nexttile
plot (fr,test1(:,7),'k',fr,test2(:,7),'b');
ylabel('Wrist Z (xyz)')



test1 = PP_armR;
test2 = PP_armL;

figure('Position', get(0, 'Screensize'))
t = tiledlayout(2,3);
title (t, 'PosePrior dataset - 03103: RIGHT(blue) ~~ LEFT(red)')
nexttile
scatter (test1(:,2),test1(:,3),'.','LineWidth',2);
hold on
scatter (test2(:,2),test2(:,3),'r.');
xlabel('Shoulder AA')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,1),test1(:,2),'.','LineWidth',2);
hold on
scatter (test2(:,1),test2(:,2),'r.');
xlabel('Shoulder Rot')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,1),test1(:,3),'.','LineWidth',2);
hold on
scatter (test2(:,1),test2(:,3),'r.');
xlabel('Shoulder Rot')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,4),test1(:,2),'.','LineWidth',2);
hold on
scatter (test2(:,4),test2(:,2),'r.');
xlabel('Elbow FE')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,4),test1(:,3),'.','LineWidth',2);
hold on
scatter (test2(:,4),test2(:,3),'r.');
xlabel('Elbow FE')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,4),test1(:,1),'.','LineWidth',2);
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


%% Visualize - 7DoF for Right arm
% ShRot, ShAA, ShFE, ElFE, ElPS, WrFE, WrDev
test1 = PP_armL;
figtitle = 'PosePrior dataset 03103: right arm';

figure('Position', get(0, 'Screensize'))
t = tiledlayout(2,3);
title (t, figtitle)
nexttile
scatter (test1(:,2),test1(:,3),'.','LineWidth',2);
xlabel('Shoulder AA')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,1),test1(:,2),'.','LineWidth',2);
xlabel('Shoulder Rot')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,1),test1(:,3),'.','LineWidth',2);
xlabel('Shoulder Rot')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,4),test1(:,2),'.','LineWidth',2);
xlabel('Elbow FE')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,4),test1(:,3),'.','LineWidth',2);
xlabel('Elbow FE')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,4),test1(:,1),'.','LineWidth',2);
xlabel('Elbow FE')
ylabel('Shoulder Rot')

figure('Position', get(0, 'Screensize'))
t = tiledlayout(2,3);
title (t, figtitle)
nexttile
scatter (test1(:,6),test1(:,2),'o');
xlabel('Wrist FE')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,6),test1(:,3),'o');
xlabel('Wrist FE')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,6),test1(:,1),'o');
xlabel('Wrist FE')
ylabel('Shoulder Rot')
nexttile
scatter (test1(:,7),test1(:,2),'o');
xlabel('Wrist Dev')
ylabel('Shoulder AA')
nexttile
scatter (test1(:,7),test1(:,3),'o');
xlabel('Wrist Dev')
ylabel('Shoulder FE')
nexttile
scatter (test1(:,7),test1(:,1),'o');
xlabel('Wrist Dev')
ylabel('Shoulder Rot')

figure('Position', get(0, 'Screensize'))
t = tiledlayout(2,3);
title (t, figtitle)
nexttile
scatter (test1(:,4),test1(:,5),'o');
xlabel('Elbow FE')
ylabel('Elbow SP')
nexttile
scatter (test1(:,4),test1(:,6),'o');
xlabel('Elbow FE')
ylabel('Wrist FE')
nexttile
scatter (test1(:,4),test1(:,7),'o');
xlabel('Elbow FE')
ylabel('Wrist Dev')
nexttile
scatter (test1(:,5),test1(:,6),'o');
xlabel('Elbow PS')
ylabel('Wrist FE')
nexttile
scatter (test1(:,5),test1(:,7),'o');
xlabel('Elbow PS')
ylabel('Wrist Dev')
nexttile
scatter (test1(:,6),test1(:,7),'o');
xlabel('Wrist FE')
ylabel('Wrist Dev')

% %% Save RoM data
% folderPath = '.\data\CMU';
% folder_name = 'subjects';
% path = fullfile(folderPath, folder_name);
% if ~exist(path, 'dir')
%     mkdir(path);
% end
% save(fullfile(path, 'cmu05_armR.mat'),'cmu05_armR');
% save(fullfile(path, 'cmu05_armL.mat'),'cmu05_armL');


%%


% for i =1:size({dataDir.name},2)
%     [skeleton{i},~] = loadbvh(dataDir(i).name);
%     Njoints = numel(skeleton{);
%     if ~isempty(regexpi(dataDir(i).name, '\.asf')) %&& ~isDir(dataDir(i).name)
%         asfname = strcat(path, dataDir(i).name);
%     end
%     if ~isempty(regexpi(dataDir(i).name, '\.bvh')) %&& ~isDir(dataDir(i).name)
%         amcname = strcat(path, dataDir(i).name);
%         paraF = getMOCParaF('mocap');
%         wsDOF = mocDOF(amcname, asfname, paraF);
%         % wsFeat = mocFeat(wsDOF, paraF);
%         armR = [armR; wsDOF.DOF(53:59,:)'];
%         armL = [armL; wsDOF.DOF(41:47,:)'];
%     end
% end

% %% Save RoM data
% folderPath = '.\data\PP';
% folder_name = 'subjects';
% path = fullfile(folderPath, folder_name);
% if ~exist(path, 'dir')
%     mkdir(path);
% end
% save(fullfile(path, 's05R.mat'),'armR');
% save(fullfile(path, 's05L.mat'),'armL');