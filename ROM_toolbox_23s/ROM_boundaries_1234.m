% % % %  ----------------                                           % % % % 
% % % %  https://github.com/penn-figueroa-lab/learning-rom          % % % % 
% % % %  Shafagh Keyvanian: shkey@seas.upenn.edu                    % % % %
% % % %  ----------------                                           % % % %                                                             % % % %
% % % % Draw the RoM boundaries with optimized nu&sigma (polar meshgrid)

clc, clear, close all
addpath (genpath('.\'))

% % load all ROM arrays % %
load('.\data\solved_angles\2023-04-01\cleaned\ROM_Subject3_activeL.mat');
load('.\data\solved_angles\2023-04-01\cleaned\ROM_Subject3_activeR.mat');
Subject3_healthy = activeL;
Subject3_impaired = activeR;

mkdir('.\figures\SVM2d_1234\Subject3\.fig\');
figfolder = '.\figures\SVM2d_1234\Subject3\';


% title({['Subject3: RoM boundaries for q_1,q_2: \nu= ', num2str(round(nu12,3)), ' \sigma= ', num2str(round(sigma12))]...
%     ['area_h=', num2str(round(area_h12,1)),', area_i=', num2str(round(area_i12,1)),]}, 'FontSize', 16)

%% % % % Q12
fprintf('\n ---- Drawing boundary: Q12 \n')

nu12=0.005; sigma12=40;
data_h12 = Subject3_healthy(:,[1,2]);
data_i12 = Subject3_impaired(:,[1,2]);
SVMModel_h12 = fitcsvm (data_h12, ones(length(data_h12),1),'KernelFunction','RBF','Nu',nu12,'KernelScale',sigma12*sqrt(2));
SVMModel_i12 = fitcsvm (data_i12, ones(length(data_i12),1),'KernelFunction','RBF','Nu',nu12,'KernelScale',sigma12*sqrt(2));
       
% Draw the boundary: Ray tracing
r_max = norm(range(data_h12,1)/2);
center_h = (min(data_h12)+max(data_h12))/2;
rr = linspace(0, r_max, 15);
thth = linspace(0, 2*pi, 360);
[r, th] = meshgrid(rr,thth);
X1 = center_h(1) + r.*cos(th);
X2 = center_h(2) + r.*sin(th);

[~,score_h12] = predict(SVMModel_h12,[X1(:), X2(:)]);
scoreGrid_h12 = reshape(score_h12,size(X1,1),size(X2,2));
[~,score_i12] = predict(SVMModel_i12,[X1(:), X2(:)]);
scoreGrid_i12 = reshape(score_i12,size(X1,1),size(X2,2));

figure('Position', [40,60,700,650])
boundary_h12 = contour(X1,X2,scoreGrid_h12,[0,0],'LineWidth',5, EdgeColor='b');
hold on
boundary_i12 = contour(X1,X2,scoreGrid_i12,[0,0],'LineWidth',5, EdgeColor='r');
scatter(data_h12(:,1),data_h12(:,2),'filled','b','MarkerFaceAlpha',0.3,'SizeData',5)
scatter(data_i12(:,1),data_i12(:,2),'filled','r','MarkerFaceAlpha',0.3,'SizeData',5)
axis ('equal','tight')

area_h12 = polyarea(boundary_h12(1,2:end), boundary_h12(2,2:end));
area_i12 = polyarea(boundary_i12(1,2:end), boundary_i12(2,2:end));
II12 = area_i12/area_h12;
xlabel('Shoulder Rotation','FontSize',28)
ylabel('Shoulder Abduction','FontSize',28)
saveas(gcf,fullfile(figfolder,(['Q12', '.jpeg'])));
saveas(gcf,fullfile(figfolder,'.fig\',(['Q12', '.fig'])));
close gcf

%% % % % Q13
fprintf('\n ---- Drawing boundary: Q13 \n')

nu13=0.008; sigma13=40;
data_h13 = Subject3_healthy(:,[1,3]);
data_i13 = Subject3_impaired(:,[1,3]);
SVMModel_h13 = fitcsvm (data_h13, ones(length(data_h13),1),'KernelFunction','RBF','Nu',nu13,'KernelScale',sigma13*sqrt(2));
SVMModel_i13 = fitcsvm (data_i13, ones(length(data_i13),1),'KernelFunction','RBF','Nu',nu13,'KernelScale',sigma13*sqrt(2));
       
% Draw the boundary: Ray tracing
r_max = norm(range(data_h13,1)/2);
center_h = (min(data_h13)+max(data_h13))/2;
rr = linspace(0, r_max, 15);
thth = linspace(0, 2*pi, 360);
[r, th] = meshgrid(rr,thth);
X1 = center_h(1) + r.*cos(th);
X2 = center_h(2) + r.*sin(th);

[~,score_h13] = predict(SVMModel_h13,[X1(:), X2(:)]);
scoreGrid_h13 = reshape(score_h13,size(X1,1),size(X2,2));
[~,score_i13] = predict(SVMModel_i13,[X1(:), X2(:)]);
scoreGrid_i13 = reshape(score_i13,size(X1,1),size(X2,2));

figure('Position', [40,60,700,650])
boundary_h13 = contour(X1,X2,scoreGrid_h13,[0,0],'LineWidth',5, EdgeColor='b');
hold on
boundary_i13 = contour(X1,X2,scoreGrid_i13,[0,0],'LineWidth',5, EdgeColor='r');
scatter(data_h13(:,1),data_h13(:,2),'filled','b','MarkerFaceAlpha',0.3,'SizeData',5)
scatter(data_i13(:,1),data_i13(:,2),'filled','r','MarkerFaceAlpha',0.3,'SizeData',5)
axis ('equal','tight')

area_h13 = polyarea(boundary_h13(1,2:end), boundary_h13(2,2:end));
area_i13 = polyarea(boundary_i13(1,2:end), boundary_i13(2,2:end));
II13 = area_i13/area_h13;
xlabel('Shoulder Rotation','FontSize',28)
ylabel('Shoulder Flexion','FontSize',28)
saveas(gcf,fullfile(figfolder,(['Q13', '.jpeg'])));
saveas(gcf,fullfile(figfolder,'.fig\',(['Q13', '.fig'])));
close gcf

%% % % % Q23
fprintf('\n ---- Drawing boundary: Q23 \n')

nu23=0.008; sigma23=40;
data_h23 = Subject3_healthy(:,[2,3]);
data_i23 = Subject3_impaired(:,[2,3]);
SVMModel_h23 = fitcsvm (data_h23, ones(length(data_h23),1),'KernelFunction','RBF','Nu',nu23,'KernelScale',sigma23*sqrt(2));
SVMModel_i23 = fitcsvm (data_i23, ones(length(data_i23),1),'KernelFunction','RBF','Nu',nu23,'KernelScale',sigma23*sqrt(2));
       
% Draw the boundary: Ray tracing
r_max = norm(range(data_h23,1)/2);
center_h = (min(data_h23)+max(data_h23))/2;
rr = linspace(0, r_max, 15);
thth = linspace(0, 2*pi, 360);
[r, th] = meshgrid(rr,thth);
X1 = center_h(1) + r.*cos(th);
X2 = center_h(2) + r.*sin(th);

[~,score_h23] = predict(SVMModel_h23,[X1(:), X2(:)]);
scoreGrid_h23 = reshape(score_h23,size(X1,1),size(X2,2));
[~,score_i23] = predict(SVMModel_i23,[X1(:), X2(:)]);
scoreGrid_i23 = reshape(score_i23,size(X1,1),size(X2,2));

figure('Position', [40,60,700,650])
boundary_h23 = contour(X1,X2,scoreGrid_h23,[0,0],'LineWidth',5, EdgeColor='b');
hold on
boundary_i23 = contour(X1,X2,scoreGrid_i23,[0,0],'LineWidth',5, EdgeColor='r');
scatter(data_h23(:,1),data_h23(:,2),'filled','b','MarkerFaceAlpha',0.3,'SizeData',5)
scatter(data_i23(:,1),data_i23(:,2),'filled','r','MarkerFaceAlpha',0.3,'SizeData',5)
axis ('equal','tight')

area_h23 = polyarea(boundary_h23(1,2:end), boundary_h23(2,2:end));
area_i23 = polyarea(boundary_i23(1,2:end), boundary_i23(2,2:end));
II23 = area_i23/area_h23;
xlabel('Shoulder Abduction','FontSize',28)
ylabel('Shoulder Flexion','FontSize',28)
saveas(gcf,fullfile(figfolder,(['Q23', '.jpeg'])));
saveas(gcf,fullfile(figfolder,'.fig\',(['Q23', '.fig'])));
close gcf

%% % % % Q41
fprintf('\n ---- Drawing boundary: Q41 \n')

nu41=0.008; sigma41=40;
data_h41 = Subject3_healthy(:,[4,1]);
data_i41 = Subject3_impaired(:,[4,1]);
SVMModel_h41 = fitcsvm (data_h41, ones(length(data_h41),1),'KernelFunction','RBF','Nu',nu41,'KernelScale',sigma41*sqrt(2));
SVMModel_i41 = fitcsvm (data_i41, ones(length(data_i41),1),'KernelFunction','RBF','Nu',nu41,'KernelScale',sigma41*sqrt(2));
       
% Draw the boundary: Ray tracing
r_max = norm(range(data_h41,1)/2);
center_h = (min(data_h41)+max(data_h41))/2;
rr = linspace(0, r_max, 15);
thth = linspace(0, 2*pi, 360);
[r, th] = meshgrid(rr,thth);
X1 = center_h(1) + r.*cos(th);
X2 = center_h(2) + r.*sin(th);

[~,score_h41] = predict(SVMModel_h41,[X1(:), X2(:)]);
scoreGrid_h41 = reshape(score_h41,size(X1,1),size(X2,2));
[~,score_i41] = predict(SVMModel_i41,[X1(:), X2(:)]);
scoreGrid_i41 = reshape(score_i41,size(X1,1),size(X2,2));

figure('Position', [40,60,700,650])
boundary_h41 = contour(X1,X2,scoreGrid_h41,[0,0],'LineWidth',5, EdgeColor='b');
hold on
boundary_i41 = contour(X1,X2,scoreGrid_i41,[0,0],'LineWidth',5, EdgeColor='r');
scatter(data_h41(:,1),data_h41(:,2),'filled','b','MarkerFaceAlpha',0.3,'SizeData',5)
scatter(data_i41(:,1),data_i41(:,2),'filled','r','MarkerFaceAlpha',0.3,'SizeData',5)
axis ('equal','tight')

area_h41 = polyarea(boundary_h41(1,2:end), boundary_h41(2,2:end));
area_i41 = polyarea(boundary_i41(1,2:end), boundary_i41(2,2:end));
II41 = area_i41/area_h41;
xlabel('Elbow Flexion','FontSize',28)
ylabel('Shoulder Rotation','FontSize',28)
saveas(gcf,fullfile(figfolder,(['Q41', '.jpeg'])));
saveas(gcf,fullfile(figfolder,'.fig\',(['Q41', '.fig'])));
close gcf

%% % % % Q42
fprintf('\n ---- Drawing boundary: Q42 \n')

nu42=0.008; sigma42=40;
data_h42 = Subject3_healthy(:,[4,2]);
data_i42 = Subject3_impaired(:,[4,2]);
SVMModel_h42 = fitcsvm (data_h42, ones(length(data_h42),1),'KernelFunction','RBF','Nu',nu42,'KernelScale',sigma42*sqrt(2));
SVMModel_i42 = fitcsvm (data_i42, ones(length(data_i42),1),'KernelFunction','RBF','Nu',nu42,'KernelScale',sigma42*sqrt(2));
       
% Draw the boundary: Ray tracing
r_max = norm(range(data_h42,1)/2);
center_h = (min(data_h42)+max(data_h42))/2;
rr = linspace(0, r_max, 15);
thth = linspace(0, 2*pi, 360);
[r, th] = meshgrid(rr,thth);
X1 = center_h(1) + r.*cos(th);
X2 = center_h(2) + r.*sin(th);

[~,score_h42] = predict(SVMModel_h42,[X1(:), X2(:)]);
scoreGrid_h42 = reshape(score_h42,size(X1,1),size(X2,2));
[~,score_i42] = predict(SVMModel_i42,[X1(:), X2(:)]);
scoreGrid_i42 = reshape(score_i42,size(X1,1),size(X2,2));

figure('Position', [40,60,700,650])
boundary_h42 = contour(X1,X2,scoreGrid_h42,[0,0],'LineWidth',5, EdgeColor='b');
hold on
boundary_i42 = contour(X1,X2,scoreGrid_i42,[0,0],'LineWidth',5, EdgeColor='r');
scatter(data_h42(:,1),data_h42(:,2),'filled','b','MarkerFaceAlpha',0.3,'SizeData',5)
scatter(data_i42(:,1),data_i42(:,2),'filled','r','MarkerFaceAlpha',0.3,'SizeData',5)
axis ('equal','tight')

area_h42 = polyarea(boundary_h42(1,2:end), boundary_h42(2,2:end));
area_i42 = polyarea(boundary_i42(1,2:end), boundary_i42(2,2:end));
II42 = area_i42/area_h42;
xlabel('Elbow Flexion','FontSize',28)
ylabel('Shoulder Abduction','FontSize',28)
saveas(gcf,fullfile(figfolder,(['Q42', '.jpeg'])));
saveas(gcf,fullfile(figfolder,'.fig\',(['Q42', '.fig'])));
close gcf

%% % % % Q43
fprintf('\n ---- Drawing boundary: Q43 \n')

nu43=0.008; sigma43=40;
data_h43 = Subject3_healthy(:,[4,3]);
data_i43 = Subject3_impaired(:,[4,3]);
SVMModel_h43 = fitcsvm (data_h43, ones(length(data_h43),1),'KernelFunction','RBF','Nu',nu43,'KernelScale',sigma43*sqrt(2));
SVMModel_i43 = fitcsvm (data_i43, ones(length(data_i43),1),'KernelFunction','RBF','Nu',nu43,'KernelScale',sigma43*sqrt(2));
       
% Draw the boundary: Ray tracing
r_max = norm(range(data_h43,1)/2);
center_h = (min(data_h43)+max(data_h43))/2;
rr = linspace(0, r_max, 15);
thth = linspace(0, 2*pi, 360);
[r, th] = meshgrid(rr,thth);
X1 = center_h(1) + r.*cos(th);
X2 = center_h(2) + r.*sin(th);

[~,score_h43] = predict(SVMModel_h43,[X1(:), X2(:)]);
scoreGrid_h43 = reshape(score_h43,size(X1,1),size(X2,2));
[~,score_i43] = predict(SVMModel_i43,[X1(:), X2(:)]);
scoreGrid_i43 = reshape(score_i43,size(X1,1),size(X2,2));

figure('Position', [40,60,700,650])
boundary_h43 = contour(X1,X2,scoreGrid_h43,[0,0],'LineWidth',5, EdgeColor='b');
hold on
boundary_i43 = contour(X1,X2,scoreGrid_i43,[0,0],'LineWidth',5, EdgeColor='r');
scatter(data_h43(:,1),data_h43(:,2),'filled','b','MarkerFaceAlpha',0.3,'SizeData',5)
scatter(data_i43(:,1),data_i43(:,2),'filled','r','MarkerFaceAlpha',0.3,'SizeData',5)
axis ('equal','tight')

area_h43 = polyarea(boundary_h43(1,2:end), boundary_h43(2,2:end));
area_i43 = polyarea(boundary_i43(1,2:end), boundary_i43(2,2:end));
II43 = area_i43/area_h43;
xlabel('Elbow Flexion','FontSize',28)
ylabel('Shoulder Abduction','FontSize',28)
% legend('healthy RoM boundary','impaired RoM boundary','healthy arm data','impaired arm data','Location','southeastoutside')
saveas(gcf,fullfile(figfolder,(['Q43', '.jpeg'])));
saveas(gcf,fullfile(figfolder,'.fig\',(['Q43', '.fig'])));
close gcf

%% Impairment Index

Area_h = area_h12 + area_h13 + area_h23 + area_h41 + area_h42 + area_h43;
Area_i = area_i12 + area_i13 + area_i23 + area_i41 + area_i42 + area_i43;
II = Area_i / Area_h;

% % % % % % % % Save workspace % % % % % % % % % %
folderPath = '.\models';
folder_name = "svm2d_Q1234";
path = fullfile(folderPath, folder_name);
if ~exist(path, 'dir')
    mkdir(path);
end
name = "Subject3_II";
file = fullfile(path, name);
save (file) 
