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


% % Grid search constraint
data = subject1_healthy;

% % Add upper and lower limits as hard constraints 
low = min(data); up = max(data);
center = (low+up)/2;
% med = median(data)
% r = [med-low; up-med]

k=1;
for i=1:length(center)
    hardConst(k,:) = center(:);
    hardConst(k+1,:) = center(:);
    hardConst(k:k+1,i) = [low(i)-3 ; up(i)+3];
    k=k+2;
end

nKnn = 10; %floor(5*log(length(data)));

%
% i=1;
% points_within_radius = [];
% for i = 1:1000
%     test= randn
%     if data_pdfValues(i,1) > 1
%         points_within_radius = [points_within_radius; data(i,:)];
%     end
% end 
% if length(points_within_radius)>length(data) * 0.1
%     num_points_to_select = floor(length(data) * 0.1);
% else
%     num_points_to_select = floor(length(points_within_radius));
% end
% random_indices = randperm(length(points_within_radius), num_points_to_select);
% X_test = points_within_radius(random_indices, :);
% 
% figure;
% scatter(data(:,1), data(:,2), 'filled');
% hold on;
% contour(X, Y, pdfValues*length(data),[1,1],'LineWidth',2,EdgeColor='k');
% scatter(X_test(:,1), X_test(:,2), 'r.');
% scatter (hardConst(:,1),hardConst(:,2),'k+','LineWidth',3)
% daspect ([1 1 1])
% hold off;
% axis padded
% legend ('data set','test region','test data','test outliers','Location','best')
% title ('SVM: test data (subject3: healthy arm)')
% % saveas(gcf,fullfile('.\figures\test_data_region\subject3_healthy_test.jpeg'));
% 
% data(random_indices,:) = [];


% % % % SVM: assess the effect of hyperparameters - grid search on nu&sigma
% % % % Draw the boundary of the SVM with chosen nu&sigma (using polar meshgrid)
tic


% r_max = norm(range(data,1)/2);       % use this as the outer range for ray tracing

% Range of hyperparameters to search
sigma_range = logspace(-3, 3, 13);  % range of sigma
nu_range = linspace(0.001, 1, 11); % range of nu 
% sigma_range = logspace(-2, -1, 2);  % range of sigma
% nu_range = linspace(0.9, 1, 2); % range of nu 

% Define and initialize the grids to store results
grid_SVMPerformance = zeros(numel(sigma_range), numel(nu_range));
grid_bias = zeros(numel(sigma_range), numel(nu_range));
grid_nSVpercent = zeros(numel(sigma_range), numel(nu_range));
grid_nFN = zeros(numel(sigma_range), numel(nu_range));
grid_area =  NaN(numel(sigma_range), numel(nu_range));
grid_overfitFactor = zeros(numel(sigma_range), numel(nu_range));

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
        grid_nSVpercent(ii,jj) = nSVpercent;

        % Overfitting check
        for kk=1:nSV 
            fprintf('Checking inside/edge SVs for SV = %i \n', kk)
            Idx = knnsearch(data,SVMModel.SupportVectors(kk,:),'K',nKnn,'IncludeTies',true);
            SV_neighbors = data(Idx{1,1},:);
            knn_data = (SV_neighbors - SVMModel.SupportVectors(kk,:))/norm((SV_neighbors - SVMModel.SupportVectors(kk,:)));
            knn_SVMModel = fitcsvm (knn_data(2:end,:), ones(length(knn_data)-1,1),'KernelFunction','linear','Nu',0.001);
            [~,knn_SVMscore] = predict(knn_SVMModel,[knn_data(:,1),knn_data(:,2),knn_data(:,3),knn_data(:,4),knn_data(:,5),knn_data(:,6),knn_data(:,7)]);
            knn_outliers = sign(knn_SVMscore); 
            isInsideSV = sum(knn_outliers(:)==-1);
            if isInsideSV > 2 
                grid_overfitFactor(ii,jj) = 1;
                break;
            end  
        end
        if grid_overfitFactor(ii,jj) == 1 
            grid_SVMPerformance(ii,jj) = 1;
            fprintf('\n --- Inefficient SVM \n --- Parameters: sigma = %.3f  nu = %.3f \n', sigma, nu)
            fprintf(' --- Inside SV found \n')
            continue;
        end

       [~,SVMscore] = predict(SVMModel,[data(:,1),data(:,2),data(:,3),data(:,4),data(:,5),data(:,6),data(:,7)]);
        outliers = sign(SVMscore); 
        grid_nFN(ii,jj) = sum(outliers(:)==-1);
        if grid_nFN(ii,jj) > 5 
            grid_SVMPerformance(ii,jj) = 2;
            fprintf('\n --- Inefficient SVM \n --- Parameters: sigma = %.3f  nu = %.3f \n', sigma, nu)
            fprintf(' --- High outlier rate:  FN = %i \n', grid_nFN(ii,jj))
            continue;
        end

        % Underfitting check
        [~,hardCscore] = predict(SVMModel,[hardConst(:,1),hardConst(:,2),hardConst(:,3),hardConst(:,4),hardConst(:,5),hardConst(:,6),hardConst(:,7)]);
        hardCSign = sign(hardCscore);
        hardCcheck = sum(hardCSign(:)==+1);
        if hardCcheck > 0
            grid_SVMPerformance(ii,jj) = -1;
            fprintf('\n --- Inefficient SVM \n --- Parameters: sigma = %.3f  nu = %.3f \n', sigma, nu)
            fprintf(' --- Hard constraints outside with positive score = %i  nSV = %.3f \n', hardCcheck, nSV)
            continue;
        end

        % % Draw the boundary: Ray tracing
        % rr = linspace(0, r_max, 10);
        % thth = linspace(0, 2*pi, 180);
        % [r, th] = meshgrid(rr,thth);
        % X1 = center(1) + r.*cos(th);
        % X2 = center(2) + r.*sin(th);
        % 
        % [~,score] = predict(SVMModel,[X1(:), X2(:)]);
        % scoreGrid = reshape(score,size(X1,1),size(X2,2));
        % 
        % figure
        % plot(data(:,1),data(:,2),'b.')
        % hold on
        % plot(data(svInd,1),data(svInd,2),'r+','MarkerSize',8)
        % % plot(X1,X2,'g.')
        % contour(X1,X2,scoreGrid,'LineWidth',0.2)
        % colorbar;
        % boundary = contour(X1,X2,scoreGrid,[0,0],'LineWidth',2,EdgeColor='k');
        % grid_area  (ii,jj) = polyarea(boundary(1,2:end)-center(1), boundary(2,2:end)-center(2));
        % 
        % title({['Subjec3: impaired arm']...
        %     ['area=', num2str(round(grid_area(ii,jj))),',   SV_%=', num2str(round(nSVpercent)),',    bias=', num2str(round(bias,1))]...
        %     ['\nu= ', num2str(round(nu,3)), '  kernelScale (\sigma)= ', num2str(round(sigma))]}, 'FontSize', 11)
        % xlabel('Elbow FE')
        % ylabel('Shoulder FE')
        % legend('Observation','Support Vectors','boundary function','decision boundary','Location','best')
        % hold off
        % saveas(gcf,fullfile('.\figures\SVM2d_gridSearch\',(['sigma=', num2str(round(sigma)),' Nu=', num2str(round(nu,3)), '.jpeg'])));
        % close gcf
    end
end

gridsearch_runtime = toc

%% Results of the grid search for nu&sigma

Nu_axis = {'0.001','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'};
sigma_axis = {'0.001','0.003','0.01','0.032','0.1','0.32','1','3.2','10','31.6','100','316','1000'};
% Nu_axis = {'0.001','0.005','0.010','0.015','0.02','0.025','0.03'};
% sigma_axis = {'0.01','20','40','60','80','100'};
% h1 = heatmap(Nu_axis, sigma_axis, grid_area);
% h1.Title = 'Area enclosed by decision boundary';
% h1.YLabel = 'KernelScale';
% h1.XLabel = 'Nu';
% h1.CellLabelFormat = '%.2f';
% saveas(gcf,fullfile('.\figures\SVM7d_gridSearch\','area.jpeg'));

figure('Position', get(0, 'Screensize'))
h2 = heatmap(Nu_axis, sigma_axis, grid_nSVpercent);
h2.Title = 'Subj1 Healthy: Number of Support vectors (percent)';
h2.YLabel = 'KernelScale';
h2.XLabel = 'Nu';
saveas(gcf,fullfile('.\figures\SVM7d_gridSearch\','nSV.jpeg'));

figure('Position', get(0, 'Screensize'))
h3 = heatmap(Nu_axis, sigma_axis, abs(grid_bias));
h3.Title = 'Subj1 Healthy: |Bias|';
h3.YLabel = 'KernelScale';
h3.XLabel = 'Nu';
h3.CellLabelFormat = '%.2f';
saveas(gcf,fullfile('.\figures\SVM7d_gridSearch\','bias.jpeg'));

figure('Position', get(0, 'Screensize'))
h4 = heatmap(Nu_axis, sigma_axis, grid_nFN);
h4.Title = 'Subj1 Healthy: False Negartive points';
h4.YLabel = 'KernelScale';
h4.XLabel = 'Nu';
saveas(gcf,fullfile('.\figures\SVM7d_gridSearch\','nFN.jpeg'));

figure('Position', get(0, 'Screensize'))
h6 = heatmap(Nu_axis, sigma_axis,grid_SVMPerformance,'ColorbarVisible','off');
h6.Title = ('Subj1 Healthy: SVM performance (2=nFN, 1=overfit, -1=underfit)');
h6.YLabel = 'KernelScale';
h6.XLabel = 'Nu';
saveas(gcf,fullfile('.\figures\SVM7d_gridSearch\','model.jpeg'));

%%
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
h10 = heatmap(Nu_axis, sigma_axis, grid_nSVpercent.*grid_area.*abs(grid_bias).*abs(grid_bias));
h10.Title = 'Objective function=  nSV_%. area. |bias|^2';
h10.YLabel = 'KernelScale';
h10.XLabel = 'Nu';
saveas(gcf,fullfile('.\figures\SVM2d_gridSearch\','func5.jpeg'));

