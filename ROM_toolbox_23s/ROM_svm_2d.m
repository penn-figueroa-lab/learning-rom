% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % %  ----------------                                           % % % % 
% % % %  https://github.com/penn-figueroa-lab/learning-rom          % % % % 
% % % %  Shafagh Keyvanian: shkey@seas.upenn.edu                    % % % %
% % % %  ----------------                                           % % % %                                                             % % % %
% % % %                                                             % % % %
% % % %  Convert joints angles array to optimized decision boundary % % % %
% % % %                                                             % % % %
% % % %  Input: each arm as 7DoF chain and returns relative angles  % % % %
% % % %   7DoF order : ShRot, ShAA, ShFE, ElFE, ElPS, WrFE, WrDev   % % % %
% % % %                                                             % % % %
% % % %                      -------------------                    % % % % 
% % % %                       PCA dim reduction                     % % % %
% % % %                      -------------------                    % % % %
% % % %  PCA on 7d - Project to lower dim (using "R2023a" pca)      % % % %
% % % %                                                             % % % %
% % % %                        ----------------                     % % % % 
% % % %                       Decision Boundary                     % % % % 
% % % %                        ----------------                     % % % % 
% % % %  One-class SVM on 2d (pca or raw)  (using fitcsmv)          % % % %
% % % %  KernelFunction = RBF, Hyperparameters: Nu & KernelScale    % % % %
% % % %  Grid search for Nu and KernelScale - output:area,bias,nSV  % % % %
% % % %  Calculate the area enclosed by the decision boundary       % % % % 
% % % %  Calculate the arbitrary functions for each SVMmodel        % % % % 
% % % %  Save grid search results in: \figures\SVM2d_gridSearch     % % % %
% % % %                                                             % % % %
% % % %  Choose the best based on "visual assessment" for now:      % % % %
% % % %  file: SVMmodel_Subject#_(healthy/impaired)(L/R)_test       % % % %
% % % %  Save the best model in folder: .\models\SVM                % % % %
% % % %  Save the boundary in folder: .\figures\SVM boundaries      % % % %
% % % %                                                             % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

clc, clear, close all
addpath (genpath('.\'))

% % load all ROM arrays % %
date    = '2023-04-01';
romFiles = dir(fullfile('.\data\solved_angles\',date,'cleaned\','*.mat'));
for k = 1:numel(romFiles)
    load (romFiles(k).name)
end


%% % % visualize the ROM to choose the data
test1 = ROM_Subject0_healthyR_Active;
test2 = ROM_Subject0_impairedR_Active;
figtitle = 'Subject: Healthy Arm (blue) vs. Impaired Arm (red)';
figRoM_compareTests (test1, test2, figtitle)

data1 = test1;
data2 = test2;

%% edit data based on Motive miscalculations

% % remove bad data based on Motive
% data1(data1(:,4) < -10,:) = [];
ind2 = find(data2(:,4) < -10);
data2(12180:13073,:) = [];

% % % remove outliers if needed:
% [data1,TFrm1] = rmoutliers(data1,"movmedian",4);
% [data2,TFrm2] = rmoutliers(data2,"movmedian",4);
% ind1 = find(TFrm1 == 1);
% ind2 = find(TFrm2 == 1);

% % remove duplicates if needed:
[data1, dataCleanedPerc1] = cleanData (data1);
[data2, dataCleanedPerc2] = cleanData (data2);  

% % visualize the ROM after edit
figtitle = 'Subject0 Healthy Arm (blue) vs. Impaired Arm (red)';
% figRoM_compareTests (data1, data2, figtitle)

% % Create circles for X_test
% 
% figure
% scatter (data1(:,4),data1(:,3),'.')
% c1 = [60 100 50; 35 25 25];
% for i=1:size(c1,1)
%     rectangle('Position',[c1(i,1)-c1(i,3) c1(i,2)-c1(i,3) 2*c1(i,3) 2*c1(i,3)],...
%         'Curvature',[1 1],'EdgeColor','r', 'LineWidth',3);
% end
% daspect ([1 1 1])
% 
% figure
% scatter (data2(:,4),data2(:,3),'.')
% c2 = [50 100 20];
% for i=1:size(c2,1)
%     rectangle('Position',[c2(i,1)-c2(i,3) c2(i,2)-c2(i,3) 2*c2(i,3) 2*c2(i,3)],...
%         'Curvature',[1 1],'EdgeColor','r', 'LineWidth',3);
% end
% daspect ([1 1 1])

%% Grid search to find the range for nu and sigma

% Choose the dimensions:
Xh = data1(:,[4 3]);

% Add upper and lower limits as hard constraints 
low = min(Xh); up = max(Xh);
center = (low+up)/2;
hardConst = [low(1)-3 center(2) ; ...
             up(1)+3 center(2) ; ...
             center(1) low(2)-3 ; ...
             center(1) up(2)+3 ;];

% % X_Test: 10% of data points in the center region 
% % center & radius change based on data

c1 = [60 100 50; 20 40 20];
points_within_radius = [];
for j = 1:size(c1,1)
    for i = 1:size(Xh, 1)
        distance = norm(Xh(i,:) - c1(j,1:2));
        if distance <= c1(j,3)
            points_within_radius = [points_within_radius; Xh(i,:)];
        end
    end
end 
if length(points_within_radius)>length(Xh) * 0.1
    num_points_to_select = floor(length(Xh) * 0.1);
else
    num_points_to_select = floor(length(points_within_radius));
end
random_indices = randperm(length(points_within_radius), num_points_to_select);
X_test = points_within_radius(random_indices, :);
Xh(random_indices, :) = [];

figure
scatter (data1(:,4),data1(:,3),'.')
hold on
for i=1:size(c1,1)
    rectangle('Position',[c1(i,1)-c1(i,3) c1(i,2)-c1(i,3) 2*c1(i,3) 2*c1(i,3)],...
        'Curvature',[1 1],'EdgeColor','r', 'LineWidth',3);
end
scatter (X_test(:,1),X_test(:,2),'r.')
scatter (hardConst(:,1),hardConst(:,2),'k+','LineWidth',3)
daspect ([1 1 1])
hold off

%% % % % SVM: assess the effect hyperparameters - grid search on nu&sigma
% % % % Draw the boundary of the SVM with chosen nu&sigma (using polar meshgrid)
tic

r_max = norm(range(Xh,1)/2);       % use this as the outer range for ray tracing

% Range of hyperparameters to search
sigma_range = linspace(20, 100, 5);  % range of regularization parameter
nu_range = linspace(0.001, 0.05, 6); % range of nu parameter

% Define and initialize the grids to store results
grid_bias = zeros(numel(sigma_range), numel(nu_range));
grid_supportVector = zeros(numel(sigma_range), numel(nu_range));
grid_overfitPoints = zeros(numel(sigma_range), numel(nu_range));
grid_boundaryVol = NaN(numel(sigma_range), numel(nu_range));
% grid_outlierRate = zeros(numel(sigma_range), numel(nu_range));
func1 = NaN(numel(sigma_range), numel(nu_range));
func2 = NaN(numel(sigma_range), numel(nu_range));
func3 = NaN(numel(sigma_range), numel(nu_range));

% nu=0.1; sigma=10;

for ii = 1:numel(sigma_range)
    for jj = 1:numel(nu_range)
        sigma = sigma_range(ii);
        nu = nu_range(jj);
        fprintf('\n Running SVM for  sigma = %5.3f   nu = %5.3f \n', sigma, nu)
        SVMModel = fitcsvm (Xh, ones(length(Xh),1),'KernelFunction','RBF','Nu',nu,'KernelScale',sigma);
        bias = SVMModel.Bias;
        grid_bias(ii,jj) = bias;
        svInd = SVMModel.IsSupportVector;
        nSV = sum(svInd); nSVpercent = nSV / length(Xh) * 100;
        grid_supportVector(ii,jj) = nSVpercent;

        [~,hardCscore] = predict(SVMModel,[hardConst(:,1),hardConst(:,2)]);
        hardCSign = sign(hardCscore);
        hardCcheck = sum(hardCSign(:)==+1);
         
        if hardCcheck > 0 
            fprintf('\n --- Inefficient SVM \n --- Parameters: sigma = %.3f  nu = %.3f \n', sigma, nu)
            fprintf(' --- Hard constraints outside with positive score = %i  nSV = %.3f \n', hardCcheck, nSV)
            continue;
        end

        [~,testScore] = predict(SVMModel,[X_test(:,1),X_test(:,2)]);
        testSign = sign(testScore);

        overfitPoints = sum(testSign(:)==-1);
        grid_overfitPoints(ii,jj) = overfitPoints;
         
        if abs(overfitPoints) > 0 %|| nSV > 0.9*length(X)
            fprintf('\n --- Inefficient SVM \n --- Parameters: sigma = %.3f  nu = %.3f \n', sigma, nu)
            fprintf(' --- Points inside with negative score = %i  nSV = %.3f \n', overfitPoints, nSV)
            continue;
        end

        % [~,SVMscore] = predict(SVMModel,[Xh(:,1),Xh(:,2)]);
        % outliers = sign(SVMscore); 
        % outlierRate = sum(outliers(:)==-1)/length(Xh);
        % grid_outlierRate(ii,jj) = outlierRate;
        % 
        % if outlierRate > 0.1 %|| nSV > 0.9*length(Xh)
        %     fprintf('\n --- Inefficient SVM \n --- Parameters: sigma = %.3f  nu = %.3f \n', sigma, nu)
        %     fprintf(' --- High outlier rate = %.3f  nSV = %.3f \n', outlierRate, nSV)
        %     continue;
        % end

        % Draw the boundary: Ray tracing
        rr = linspace(0, r_max, 10);
        thth = linspace(0, 2*pi, 180);
        [r, th] = meshgrid(rr,thth);
        X1 = center(1) + r.*cos(th);
        X2 = center(2) + r.*sin(th);
        
        [~,score] = predict(SVMModel,[X1(:), X2(:)]);
        scoreGrid = reshape(score,size(X1,1),size(X2,2));
        
        figure
        plot(Xh(:,1),Xh(:,2),'b.')
        hold on
        plot(Xh(svInd,1),Xh(svInd,2),'r+','MarkerSize',8)
        % plot(X1,X2,'g.')
        contour(X1,X2,scoreGrid,'LineWidth',0.2)
        colorbar;
        boundary = contour(X1,X2,scoreGrid,[0,0],'LineWidth',2,EdgeColor='k');
        if bias ==0
            bias = 10^-4; end
        area  (ii,jj) = polyarea(boundary(1,2:end)-center(1), boundary(2,2:end)-center(2));
        func1 (ii,jj) = area(ii,jj) / abs(bias);
        func2 (ii,jj) = area(ii,jj) / (bias^2);
        func3 (ii,jj) = nSVpercent / abs(bias);
        title({['f_1= area/|bias|= ', num2str(round(func1(ii,jj),1)),',   f_2= area/(|bias|^2)= ', num2str(round(func2(ii,jj),1)),...
            ',   f_3= SV_%/|bias|= ', num2str(round(func3(ii,jj),2))] ...
            ['area=', num2str(round(area(ii,jj))),',   SV_%=', num2str(round(nSVpercent)),',    bias=', num2str(round(bias,1))]...
            ['\nu= ', num2str(round(nu,2)), '  kernelScale (\sigma)= ', num2str(round(sigma))]}, 'FontSize', 10)
        xlabel('Elbow FE')
        ylabel('Shoulder FE')
        legend('Observation','Support Vectors', 'decision boundary','Location','southeast')
        hold off
        saveas(gcf,fullfile('.\figures\SVM2d_gridSearch\',(['sigma=', num2str(round(sigma)),' Nu=', num2str(round(nu,2)), '.jpeg'])));
        close gcf
        
        % area(ii,jj) = polyarea(boundary(1,2:end)-center(1), boundary(2,2:end)-center(2));
        grid_boundaryVol(ii,jj) = area(ii,jj);
        
    end
end

toc

% %
% figure
% title('One-class SVM on PCA Data')
% plot(X(:,1),X(:,2),'b.')
% hold on
% % plot(X(svInd,1),X(svInd,2),'r+','MarkerSize',12)
% plot(boundary(:,1),boundary(:,2),'k.')
% xlabel('PC1')
% ylabel('PC2')
% % legend('Observation','Support Vector','boundary')
% hold off


%% Results of the grid search for nu&sigma
figure
Nu_axis = {'0.001','0.01','0.02','0.03','0.04','0.05'};
sigma_axis = {'20','40','60','80','100'};
h1 = heatmap(Nu_axis, sigma_axis, grid_boundaryVol);
h1.Title = 'Area enclosed by decision boundary';
h1.YLabel = 'KernelScale';
h1.XLabel = 'Nu';
h1.CellLabelFormat = '%.2f';
saveas(gcf,fullfile('.\figures\SVM2d_gridSearch\','area.jpeg'));

figure
h2 = heatmap(Nu_axis, sigma_axis, grid_supportVector);
h2.Title = 'Number of Support vectors (percent)';
h2.YLabel = 'KernelScale';
h2.XLabel = 'Nu';
saveas(gcf,fullfile('.\figures\SVM2d_gridSearch\','nSV.jpeg'));

h7 = heatmap(Nu_axis, sigma_axis, grid_bias);
h7.Title = 'Bias';
h7.YLabel = 'KernelScale';
h7.XLabel = 'Nu';
h7.CellLabelFormat = '%.2f';
saveas(gcf,fullfile('.\figures\SVM2d_gridSearch\','bias.jpeg'));

figure
h3 = heatmap(Nu_axis, sigma_axis, grid_overfitPoints);
h3.Title = 'Overfit Rate';
h3.YLabel = 'KernelScale';
h3.XLabel = 'Nu';
saveas(gcf,fullfile('.\figures\SVM2d_gridSearch\','overfitRate.jpeg'));

% figure
% h4 = heatmap(Nu_axis, sigma_axis, func1);
% h4.Title = 'Objective function 1';
% h4.YLabel = 'KernelScale';
% h4.XLabel = 'Nu';
% saveas(gcf,fullfile('.\figures\SVM2d_gridSearch\','func1.jpeg'));
% 
% figure
% h5 = heatmap(Nu_axis, sigma_axis, func2);
% h5.Title = 'Objective function 2';
% h5.YLabel = 'KernelScale';
% h5.XLabel = 'Nu';
% saveas(gcf,fullfile('.\figures\SVM2d_gridSearch\','func2.jpeg'));
% 
% figure
% h6 = heatmap(Nu_axis, sigma_axis, func3);
% h6.Title = 'Objective function 3';
% h6.YLabel = 'KernelScale';
% h6.XLabel = 'Nu';
% saveas(gcf,fullfile('.\figures\SVM2d_gridSearch\','func3.jpeg'));

figure
h6 = heatmap(Nu_axis, sigma_axis, func2.*func3);
h6.Title = 'Objective function=  (nSV_%. area) / (|bias|^3)';
h6.YLabel = 'KernelScale';
h6.XLabel = 'Nu';
saveas(gcf,fullfile('.\figures\SVM2d_gridSearch\','func4.jpeg'));


%% Decision boundary for Impaired arm:

Xi = data2(:,[4 3]);

range2 = range (Xi,1);
r_max2 = norm(range2/2);       % use this as the outer range for ray tracing

nu = 0.001; sigma = 56.234;
SVMModel2 = fitcsvm (Xi, ones(length(Xi),1),'KernelFunction','RBF','Nu',nu,'KernelScale',sigma);
bias2 = SVMModel2.Bias;
svInd2 = SVMModel2.IsSupportVector;
nSV2 = sum(svInd2); nSVpercent2 = nSV2 / length(Xi) * 100;

% Draw the boundary: Ray tracing
rr = linspace(0, r_max2, 10);
thth = linspace(0, 2*pi, 180);
[r, th] = meshgrid(rr,thth);
X1 = center(1) + r.*cos(th);
X2 = center(2) + r.*sin(th);

[~,score2] = predict(SVMModel2,[X1(:), X2(:)]);
scoreGrid2 = reshape(score2,size(X1,1),size(X2,2));

figure
plot(Xi(:,1),Xi(:,2),'b.')
hold on
plot(Xi(svInd2,1),Xi(svInd2,2),'r+','MarkerSize',8)
% plot(X1,X2,'g.')
contour(X1,X2,scoreGrid,'LineWidth',0.2)
colorbar;
boundary = contour(X1,X2,scoreGrid,[0,0],'LineWidth',2,EdgeColor='k');

title({['\nu= ', num2str(round(nu,2)), '  kernelScale (\sigma)= ', num2str(round(sigma))]...
    ['SV_%=', num2str(round(nSVpercent2)),',    bias=', num2str(round(bias2,1))]}, 'FontSize', 10)
xlabel('Elbow FE')
ylabel('Shoulder FE')
legend('Observation','Support Vectors', 'decision boundary','Location','southeast')
hold off

