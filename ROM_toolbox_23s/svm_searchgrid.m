% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % %                                                             % % % %
% % % %  Convert joints angles array to optimized decision boundary % % % %
% % % %                                                             % % % %
% % % %  Input: each arm as 7DoF chain and returns relative angles  % % % %
% % % %   7DoF order : ShRot, ShAA, ShFE, ElFE, ElPS, WrFE, WrDev   % % % %
% % % %                                                             % % % %
% % % %                        ----------------                     % % % % 
% % % %                       Decision Boundary                     % % % % 
% % % %                        ----------------                     % % % % 
% % % %  One-class SVM on 2d (using fitcsmv)                        % % % %
% % % %  KernelFunction = RBF, Hyperparameters: Nu & KernelScale    % % % %
% % % %  Grid search for Nu and KernelScale - output:area,bias,nSV  % % % %
% % % %  Calculate the area enclosed by the decision boundary       % % % % 
% % % %  Calculate  arbitrary functions for each SVMmodel           % % % % 
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
load (romFiles(1).name)
load (romFiles(2).name)
subject0_healthy = activeL;
subject0_impaired = activeR;
load (romFiles(3).name)
load (romFiles(4).name)
subject1_healthy = activeL;
subject1_impaired = activeR;
load (romFiles(5).name)
load (romFiles(6).name)
subject2_healthy = activeL;
subject2_impaired = activeR;
load (romFiles(7).name)
load (romFiles(8).name)
subject3_healthy = activeL;
subject3_impaired = activeR;

% %% Visualize the test region:
% 
% data = subject0_impaired(:,[4 3]);
% gmModel = fitgmdist(data,1);
% data_pdfValues = pdf(gmModel, data)*length(data);
% indices = find(data_pdfValues > 1);
% 
% % Gaussian visualization
% x = linspace(min(data(:,1)), max(data(:,1)), 100);
% y = linspace(min(data(:,2)), max(data(:,2)), 100);
% [X, Y] = meshgrid(x, y);
% xy = [X(:) Y(:)];
% pdfValues = reshape(pdf(gmModel, xy), size(X));
% 
% figure;
% scatter(data(:,1), data(:,2), 'filled');
% hold on;
% scatter(data(indices,1), data(indices,2), 'r');
% contour(X, Y, pdfValues, 'LineWidth',1);
% hold off;
% legend ('data set','test data region','pdf isolines','Location','best')
% title ('region to pick test data (subject0: impaired arm)')
% saveas(gcf,fullfile('.\figures\test_data_region\subject0_impaired.jpeg'));


%% % Grid search constraint
data = subject3_healthy(:,[4 3]);

% % Add upper and lower limits as hard constraints 
low = min(data); up = max(data);
center = (low+up)/2;
hardConst = [low(1)-3 center(2) ; ...
             up(1)+3 center(2) ; ...
             center(1) low(2)-3 ; ...
             center(1) up(2)+3 ;];

% % X_Test: 10% of data points in the center region 
gmModel = fitgmdist(data,1);

% Gaussian visualization
x = linspace(min(data(:,1)), max(data(:,1)), 100);
y = linspace(min(data(:,2)), max(data(:,2)), 100);
[X, Y] = meshgrid(x, y);
xy = [X(:) Y(:)];
pdfValues = reshape(pdf(gmModel, xy), size(X));

data_pdfValues = pdf(gmModel, data)*length(data);
points_within_radius = [];
for i = 1:size(data, 1)
    if data_pdfValues(i,1) > 1
        points_within_radius = [points_within_radius; data(i,:)];
    end
end 
if length(points_within_radius)>length(data) * 0.1
    num_points_to_select = floor(length(data) * 0.1);
else
    num_points_to_select = floor(length(points_within_radius));
end
random_indices = randperm(length(points_within_radius), num_points_to_select);
X_test = points_within_radius(random_indices, :);

figure;
scatter(data(:,1), data(:,2), 'filled');
hold on;
contour(X, Y, pdfValues*length(data),[1,1],'LineWidth',2,EdgeColor='k');
scatter(X_test(:,1), X_test(:,2), 'r.');
scatter (hardConst(:,1),hardConst(:,2),'k+','LineWidth',3)
daspect ([1 1 1])
hold off;
axis padded
legend ('data set','test region','test data','test outliers','Location','best')
title ('SVM: test data (subject3: healthy arm)')
% saveas(gcf,fullfile('.\figures\test_data_region\subject3_healthy_test.jpeg'));

data(random_indices,:) = [];

%% % % % SVM: assess the effect of hyperparameters - grid search on nu&sigma
% % % % Draw the boundary of the SVM with chosen nu&sigma (using polar meshgrid)
tic

r_max = norm(range(data,1)/2);       % use this as the outer range for ray tracing

% Range of hyperparameters to search
sigma_range = linspace(0.01, 100, 6);  % range of regularization parameter
nu_range = linspace(0.001, 0.03, 7); % range of nu parameter

% Define and initialize the grids to store results
modelPerformance = zeros(numel(sigma_range), numel(nu_range));
grid_bias = zeros(numel(sigma_range), numel(nu_range));
grid_supportVector = zeros(numel(sigma_range), numel(nu_range));
grid_overfitPoints = zeros(numel(sigma_range), numel(nu_range));
grid_outlierRate = zeros(numel(sigma_range), numel(nu_range));
area =  NaN(numel(sigma_range), numel(nu_range));
func1 = NaN(numel(sigma_range), numel(nu_range));
func2 = NaN(numel(sigma_range), numel(nu_range));
func3 = NaN(numel(sigma_range), numel(nu_range));

for ii = 1:numel(sigma_range)
    for jj = 1:numel(nu_range)
        sigma = sigma_range(ii);
        nu = nu_range(jj);
        fprintf('\n Running SVM for  sigma = %5.3f   nu = %5.3f \n', sigma, nu)
        SVMModel = fitcsvm (data, ones(length(data),1),'KernelFunction','RBF','Nu',nu,'KernelScale',sigma);
        bias = SVMModel.Bias;
        grid_bias(ii,jj) = bias;
        svInd = SVMModel.IsSupportVector;
        nSV = sum(svInd); nSVpercent = nSV / length(data) * 100;
        grid_supportVector(ii,jj) = nSVpercent;

        [~,SVMscore] = predict(SVMModel,[data(:,1),data(:,2)]);
        outliers = sign(SVMscore); 
        FN(ii,jj) = sum(outliers(:)==-1);
        grid_outlierRate(ii,jj) = FN(ii,jj)/length(data);
        if FN > 20 %|| nSV > 0.9*length(data)
            modelPerformance(ii,jj) = 2;
            fprintf('\n --- Inefficient SVM \n --- Parameters: sigma = %.3f  nu = %.3f \n', sigma, nu)
            fprintf(' --- High outlier rate:  FN = %i \n', FN(ii,jj))
            continue;
        end

        [~,hardCscore] = predict(SVMModel,[hardConst(:,1),hardConst(:,2)]);
        hardCSign = sign(hardCscore);
        hardCcheck = sum(hardCSign(:)==+1);
        if hardCcheck > 0
            modelPerformance(ii,jj) = -1;
            fprintf('\n --- Inefficient SVM \n --- Parameters: sigma = %.3f  nu = %.3f \n', sigma, nu)
            fprintf(' --- Hard constraints outside with positive score = %i  nSV = %.3f \n', hardCcheck, nSV)
            continue;
        end

        [~,testScore] = predict(SVMModel,[X_test(:,1),X_test(:,2)]);
        testSign = sign(testScore);
        overfitPoints = sum(testSign(:)==-1);
        grid_overfitPoints(ii,jj) = overfitPoints;
        if abs(overfitPoints) > 0 %|| nSV > 0.9*length(X)
            modelPerformance(ii,jj) = 1;
            fprintf('\n --- Inefficient SVM \n --- Parameters: sigma = %.3f  nu = %.3f \n', sigma, nu)
            fprintf(' --- Points inside with negative score = %i  nSV = %.3f \n', overfitPoints, nSV)
            continue;
        end

        % Draw the boundary: Ray tracing
        rr = linspace(0, r_max, 10);
        thth = linspace(0, 2*pi, 180);
        [r, th] = meshgrid(rr,thth);
        X1 = center(1) + r.*cos(th);
        X2 = center(2) + r.*sin(th);
        
        [~,score] = predict(SVMModel,[X1(:), X2(:)]);
        scoreGrid = reshape(score,size(X1,1),size(X2,2));
        
        figure
        plot(data(:,1),data(:,2),'b.')
        hold on
        plot(data(svInd,1),data(svInd,2),'r+','MarkerSize',8)
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
        title({['Subjec3: impaired arm']...
            ['area=', num2str(round(area(ii,jj))),',   SV_%=', num2str(round(nSVpercent)),',    bias=', num2str(round(bias,1))]...
            ['\nu= ', num2str(round(nu,3)), '  kernelScale (\sigma)= ', num2str(round(sigma))]}, 'FontSize', 11)
        xlabel('Elbow FE')
        ylabel('Shoulder FE')
        legend('Observation','Support Vectors','boundary function','decision boundary','Location','best')
        hold off
        saveas(gcf,fullfile('.\figures\SVM2d_gridSearch\',(['sigma=', num2str(round(sigma)),' Nu=', num2str(round(nu,3)), '.jpeg'])));
        close gcf
    end
end

gridsearch_runtime = toc

% Results of the grid search for nu&sigma

figure
Nu_axis = {'0.001','0.005','0.010','0.015','0.02','0.025','0.03'};
sigma_axis = {'0.01','20','40','60','80','100'};
h1 = heatmap(Nu_axis, sigma_axis, area);
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

figure
h3 = heatmap(Nu_axis, sigma_axis, abs(grid_bias));
h3.Title = '|Bias|';
h3.YLabel = 'KernelScale';
h3.XLabel = 'Nu';
h3.CellLabelFormat = '%.2f';
saveas(gcf,fullfile('.\figures\SVM2d_gridSearch\','bias.jpeg'));

figure
h4 = heatmap(Nu_axis, sigma_axis, grid_overfitPoints);
h4.Title = 'Overfit: False Negartive points';
h4.YLabel = 'KernelScale';
h4.XLabel = 'Nu';
saveas(gcf,fullfile('.\figures\SVM2d_gridSearch\','overfitRate.jpeg'));

figure
h6 = heatmap(Nu_axis, sigma_axis,modelPerformance);
h6.Title = ('SVM performance (+1=overfit and -1=underfit)');
h6.YLabel = 'KernelScale';
h6.XLabel = 'Nu';
saveas(gcf,fullfile('.\figures\SVM2d_gridSearch\','model.jpeg'));

figure
h7 = heatmap(Nu_axis, sigma_axis, func1);
h7.Title = 'Objective function f_1= area/|bias|';
h7.YLabel = 'KernelScale';
h7.XLabel = 'Nu';
saveas(gcf,fullfile('.\figures\SVM2d_gridSearch\','func1.jpeg'));

figure
h8 = heatmap(Nu_axis, sigma_axis, func2);
h8.Title = 'Objective function f_2= area/(|bias|^2)';
h8.YLabel = 'KernelScale';
h8.XLabel = 'Nu';
saveas(gcf,fullfile('.\figures\SVM2d_gridSearch\','func2.jpeg'));

figure
h9 = heatmap(Nu_axis, sigma_axis, func3);
h9.Title = 'Objective function f_3= SV_%/|bias|';
h9.YLabel = 'KernelScale';
h9.XLabel = 'Nu';
saveas(gcf,fullfile('.\figures\SVM2d_gridSearch\','func3.jpeg'));

figure
h10 = heatmap(Nu_axis, sigma_axis, grid_supportVector.*area.*abs(grid_bias).*abs(grid_bias));
h10.Title = 'Objective function=  nSV_%. area. |bias|^2';
h10.YLabel = 'KernelScale';
h10.XLabel = 'Nu';
saveas(gcf,fullfile('.\figures\SVM2d_gridSearch\','func5.jpeg'));

