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
% % % %  Choose the best bas
% 
% 
% 
% 
% ed on "visual assessment" for now:      % % % %
% % % %  file: SVMmodel_Subject#_(healthy/impaired)(L/R)_test       % % % %
% % % %  Save the best model in folder: .\models\SVM                % % % %
% % % %  Save the boundary in folder: .\figures\SVM boundaries      % % % %
% % % %                                                             % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

clc, clear, close all
addpath (genpath('.\'))

% % load all ROM arrays % %
load('.\data\solved_angles\2023-04-01\cleaned\ROM_Subject2_activeL.mat');
load('.\data\solved_angles\2023-04-01\cleaned\ROM_Subject2_activeR.mat');
Subject2_healthy = activeL;
Subject2_impaired = activeR;


mkdir('.\figures\SVM2d_gridSearch\Subject2_42\.fig\');
figfolder = '.\figures\SVM2d_gridSearch\Subject2_42\';
data = Subject2_healthy(:,[4,2]);


% % Grid search constraints
% % Add upper and lower limits as known-negative-class samples 
low = min(data); up = max(data);
center = (low+up)/2;


% med = median(data)
% r = [med-low; up-med]

k=1;
for i=1:length(center)
    hardConst(k,:) = center(:);
    hardConst(k+1,:) = center(:);
    hardConst(k:k+1,i) = [low(i)-10 ; up(i)+10];
    k=k+2;
end

nKnn = 20; %floor(5*log(length(data)));
Subject2_grid = [];

% % % % SVM: assess the effect of hyperparameters - grid search on nu&sigma
% % % % Draw the boundary of the SVM with chosen nu&sigma (using polar meshgrid)

tic

r_max = norm(range(data,1)/2);       % use this as the outer range for ray tracing

% Range of hyperparameters to search
sigma_range = linspace(30, 80, 6);  % range of sigma
nu_range = linspace(0.001, 0.01, 5); % range of nu 
% sigma_range = logspace(-2, -1, 2);  % range of sigma
% nu_range = linspace(0.9, 1, 2); % range of nu 

% Define and initialize the grids to store results
grid_SVMPerformance = zeros(numel(sigma_range), numel(nu_range));
grid_bias = zeros(numel(sigma_range), numel(nu_range));
grid_nSVpercent = zeros(numel(sigma_range), numel(nu_range));
grid_nFN = zeros(numel(sigma_range), numel(nu_range));
grid_area =  NaN(numel(sigma_range), numel(nu_range));
grid_insideSV = zeros(numel(sigma_range), numel(nu_range));
overfit = zeros(numel(sigma_range), numel(nu_range));

for ii = 1:numel(sigma_range)
    for jj = 1:numel(nu_range)
        sigma = sigma_range(ii);
        nu = nu_range(jj);
        fprintf('\n gridsearch: sigma= %5.2f  nu= %.4f \n', sigma, nu)
        SVMModel = fitcsvm (data, ones(length(data),1),'KernelFunction','RBF','Nu',nu,'KernelScale',sigma*sqrt(2));
        bias = SVMModel.Bias;
        grid_bias(ii,jj) = bias;
        svInd = SVMModel.IsSupportVector;
        nSV = sum(svInd); nSVpercent = nSV / length(data) * 100;
        grid_nSVpercent(ii,jj) = nSVpercent;
                
        % nSV check
        if nSVpercent > 40 
            grid_SVMPerformance(ii,jj) = 2;
            fprintf('\n -- High nSV: sigma = %.3f  nu = %.4f \n', sigma, nu)
            fprintf(' -- nSV_percent = %.2f \n', nSVpercent)
            continue;
        end

        % Underfitting check
        [~,hardCscore] = predict(SVMModel,[hardConst(:,1),hardConst(:,2)]);
        % hardCscore = hardCscore - SVMModel.Bias;
        hardCSign = sign(hardCscore);
        hardCcheck = sum(hardCSign(:)==+1);
        if hardCcheck > 0
            grid_SVMPerformance(ii,jj) = -1;
            fprintf('\n -- Underfitting: sigma = %.3f  nu = %.4f \n', sigma, nu)
            fprintf(' -- Hard constraints outside with positive score = %i  nSV = %.3f \n', hardCcheck, nSV)
            continue;
        end

        idx_insideSV = [];
        % Overfitting check
        for kk=1:nSV 
            % fprintf('Checking inside/edge SVs for SV = %i \n', kk)
            % Idx = knnsearch(data,SVMModel.SupportVectors(kk,:),'K',nKnn,'IncludeTies',true);
            Idx = rangesearch(data,SVMModel.SupportVectors(kk,:),10);
            SV_neighbors = data(Idx{1,1},:);
            knn_data = (SV_neighbors - SVMModel.SupportVectors(kk,:))/norm((SV_neighbors - SVMModel.SupportVectors(kk,:)));
            knn_SVMModel = fitcsvm (knn_data(2:end,:), [ones(length(knn_data)-1,1)],'KernelFunction','linear','Nu',0.001);
            [~,knn_SVMscore] = predict(knn_SVMModel,knn_data);
            knn_SVMscore = knn_SVMscore - knn_SVMModel.Bias;
            knn_outliers = sign(knn_SVMscore(:,1)); 
            isInsideSV = sum(knn_outliers(:)==-1);


            if isInsideSV > 20
                grid_insideSV(ii,jj) = grid_insideSV(ii,jj)+1;
                idx_insideSV = [idx_insideSV,kk];
            end
            if grid_insideSV(ii,jj) > 0.3*nSV %0.01*length(data)
                overfit(ii,jj) = 1;
                break;
            end  
        end
        if overfit(ii,jj) == 1 
            grid_SVMPerformance(ii,jj) = 1;
            fprintf('\n -- Overfitting: sigma = %.3f  nu = %.3f \n', sigma, nu)
            fprintf(' -- Inside SV found: %i, nSV = %.3f \n', grid_insideSV(ii,jj), nSV)
            continue;
        end

        % nFN check
        [~,SVMscore] = predict(SVMModel,[data(:,1),data(:,2)]);
        % SVMscore = SVMscore - SVMModel.Bias;
        outliers = sign(SVMscore); 
        grid_nFN(ii,jj) = sum(outliers(:)==-1);
        if grid_nFN(ii,jj) > 10 
            grid_SVMPerformance(ii,jj) = 3;
            fprintf('\n -- High FN: sigma = %.3f  nu = %.4f \n', sigma, nu)
            fprintf(' -- High outlier rate:  FN = %i \n', grid_nFN(ii,jj))
            continue;
        end


        % Draw the boundary: Ray tracing
        fprintf('\n ---- Drawing boundary: sigma = %.3f  nu = %.4f \n', sigma, nu)
        rr = linspace(0, r_max, 10);
        thth = linspace(0, 2*pi, 180);
        [r, th] = meshgrid(rr,thth);
        X1 = center(1) + r.*cos(th);
        X2 = center(2) + r.*sin(th);

        [~,score] = predict(SVMModel,[X1(:), X2(:)]);
        scoreGrid = reshape(score,size(X1,1),size(X2,2));

        figure('Position', get(0, 'Screensize'))
        plot(data(:,1),data(:,2),'b.')
        hold on
        plot(data(svInd,1),data(svInd,2),'r+','MarkerSize',10)
        % plot(X1,X2,'g.')
        contour(X1,X2,scoreGrid,'LineWidth',0.2)
        colorbar;
        boundary = contour(X1,X2,scoreGrid,[0,0],'LineWidth',2,EdgeColor='k');
        scatter(hardConst(:,1),hardConst(:,2),'k+','LineWidth',3)
        % scatter(SVMModel.SupportVectors(idx_insideSV,1),SVMModel.SupportVectors(idx_insideSV,2),'ro','LineWidth',3)
        axis equal
        
        grid_area(ii,jj) = polyarea(boundary(1,2:end)-center(1), boundary(2,2:end)-center(2));
        title({['Subject2: healthy arm']...
            ['area=', num2str(round(grid_area(ii,jj))),',   SV_%=', num2str(round(nSVpercent)),',    bias=', num2str(round(bias,1))]...
            ['\nu= ', num2str(round(nu,3)), '  kernelScale (\sigma)= ', num2str(round(sigma))]}, 'FontSize', 11)
        xlabel('Elbow Flexion')
        ylabel('Shoulder Abduction')
        legend('Observation','Support Vectors','boundary function','decision boundary')
        hold off
        saveas(gcf,fullfile(figfolder,(['sigma=', num2str(round(sigma)),' Nu=', num2str(round(nu,3)), '.jpeg'])));
        saveas(gcf,fullfile(figfolder,'.fig\',(['sigma=', num2str(round(sigma)),' Nu=', num2str(round(nu,4)), '.fig'])));
        close gcf

        Subject2_grid{ii,jj}.SVMModel = SVMModel;
        Subject2_grid{ii,jj}.sigma = sigma;
        Subject2_grid{ii,jj}.nu = nu;
        Subject2_grid{ii,jj}.bias = bias;
        Subject2_grid{ii,jj}.nsvPercent = nSVpercent;
        Subject2_grid{ii,jj}.grid_SVMPerformance = grid_SVMPerformance(ii,jj);
        Subject2_grid{ii,jj}.grid_nFN = grid_nFN(ii,jj);
        Subject2_grid{ii,jj}.grid_area = grid_area(ii,jj);
        Subject2_grid{ii,jj}.boundary = boundary;

    end
end

gridsearch_runtime = toc


% % % % % % % % Save gridsearch workspace % % % % % % % % % %
folderPath = '.\models';
folder_name = "svm_gridsearch_2d";
path = fullfile(folderPath, folder_name);
if ~exist(path, 'dir')
    mkdir(path);
end
name = "Subject2_healthy_gridsearch_42";
file = fullfile(path, name);
save (file, "Subject2_grid", "data", "hardConst", "grid_area", "grid_SVMPerformance", ...
    "grid_nFN", "grid_bias", "grid_nSVpercent", "nKnn"); 


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Results of the grid search for nu&sigma

% Nu_axis = {'0.001','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'};
% sigma_axis = {'0.001','0.003','0.01','0.032','0.1','0.32','1','3.2','10','31.6','100','316','1000'};
Nu_axis = {'0.001','0.0025','0.005','0.0075','0.010'};
sigma_axis = {'30','40','50','60','70','80'};
% Nu_axis = {'0.001','0.005','0.010','0.015','0.02','0.025','0.03'};
% sigma_axis = {'0.01','20','40','60','80','100'};
figure('Position', get(0, 'Screensize'))
h1 = heatmap(Nu_axis, sigma_axis, grid_area);
h1.Title = 'Area enclosed by decision boundary';
h1.YLabel = 'KernelScale';
h1.XLabel = 'Nu';
h1.CellLabelFormat = '%.2f';
saveas(gcf,fullfile(figfolder,'area.jpeg'));
saveas(gcf,fullfile(figfolder,'.fig\','area.fig'));
close gcf

figure('Position', get(0, 'Screensize'))
h2 = heatmap(Nu_axis, sigma_axis, grid_nSVpercent);
h2.Title = 'Subject2 Healthy: Number of Support vectors (percent)';
h2.YLabel = 'KernelScale';
h2.XLabel = 'Nu';
saveas(gcf,fullfile(figfolder,'nSV.jpeg'));
close gcf

figure('Position', get(0, 'Screensize'))
h3 = heatmap(Nu_axis, sigma_axis, abs(grid_bias));
h3.Title = 'Subject2 Healthy: |Bias|';
h3.YLabel = 'KernelScale';
h3.XLabel = 'Nu';
h3.CellLabelFormat = '%.2f';
saveas(gcf,fullfile(figfolder,'bias.jpeg'));
close gcf

figure('Position', get(0, 'Screensize'))
h4 = heatmap(Nu_axis, sigma_axis, grid_nFN);
h4.Title = 'Subject2 Healthy: False Negartive points';
h4.YLabel = 'KernelScale';
h4.XLabel = 'Nu';
saveas(gcf,fullfile(figfolder,'nFN.jpeg'));
close gcf

figure('Position', get(0, 'Screensize'))
h6 = heatmap(Nu_axis, sigma_axis,grid_SVMPerformance,'ColorbarVisible','off');
h6.Title = ('Subject2 Healthy: SVM performance (0=acceptable, 1=overfitting, -1=underfitting)');
h6.YLabel = 'KernelScale';
h6.XLabel = 'Nu';
saveas(gcf,fullfile(figfolder,'model.jpeg'));
saveas(gcf,fullfile(figfolder,'.fig\','model.fig'));


% % % %
figure('Position', get(0, 'Screensize'))
h7 = heatmap(Nu_axis, sigma_axis, grid_area./abs(grid_bias));
h7.Title = 'Objective function f_1= area/|bias|';
h7.YLabel = 'KernelScale';
h7.XLabel = 'Nu';
saveas(gcf,fullfile(figfolder,'func1.jpeg'));
close gcf

figure('Position', get(0, 'Screensize'))
h8 = heatmap(Nu_axis, sigma_axis, grid_area./abs(grid_bias)./abs(grid_bias));
h8.Title = 'Objective function f_2= area/(|bias|^2)';
h8.YLabel = 'KernelScale';
h8.XLabel = 'Nu';
saveas(gcf,fullfile(figfolder,'func2.jpeg'));
close gcf

figure('Position', get(0, 'Screensize'))
h9 = heatmap(Nu_axis, sigma_axis, grid_nSVpercent./abs(grid_bias));
h9.Title = 'Objective function f_3= SV_%/|bias|';
h9.YLabel = 'KernelScale';
h9.XLabel = 'Nu';
saveas(gcf,fullfile(figfolder,'func3.jpeg'));
close gcf

figure('Position', get(0, 'Screensize'))
h10 = heatmap(Nu_axis, sigma_axis, (grid_area).*(abs(grid_bias)));
h10.Title = 'Objective function f_4=  area. |bias|';
h10.YLabel = 'KernelScale';
h10.XLabel = 'Nu';
saveas(gcf,fullfile(figfolder,'func4.jpeg'));
close gcf
%%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
clc, clear, close all
addpath (genpath('.\'))

% % load all ROM arrays % %
load('.\data\solved_angles\2023-04-01\cleaned\ROM_Subject2_activeL.mat');
load('.\data\solved_angles\2023-04-01\cleaned\ROM_Subject2_activeR.mat');
Subject2_healthy = activeL;
Subject2_impaired = activeR;


mkdir('.\figures\SVM2d_gridSearch\Subject2_41\.fig\');
figfolder = '.\figures\SVM2d_gridSearch\Subject2_41\';
data = Subject2_healthy(:,[4,1]);


% % Grid search constraints
% % Add upper and lower limits as known-negative-class samples 
low = min(data); up = max(data);
center = (low+up)/2;



% med = median(data)
% r = [med-low; up-med]

k=1;
for i=1:length(center)
    hardConst(k,:) = center(:);
    hardConst(k+1,:) = center(:);
    hardConst(k:k+1,i) = [low(i)-5 ; up(i)+5];
    k=k+2;
end

nKnn = 20; %floor(5*log(length(data)));
Subject2_grid = [];

% % % % SVM: assess the effect of hyperparameters - grid search on nu&sigma
% % % % Draw the boundary of the SVM with chosen nu&sigma (using polar meshgrid)

tic

r_max = norm(range(data,1)/2);       % use this as the outer range for ray tracing

% Range of hyperparameters to search
sigma_range = linspace(30, 80, 6);  % range of sigma
nu_range = linspace(0.001, 0.01, 5); % range of nu 
% sigma_range = logspace(-2, -1, 2);  % range of sigma
% nu_range = linspace(0.9, 1, 2); % range of nu 

% Define and initialize the grids to store results
grid_SVMPerformance = zeros(numel(sigma_range), numel(nu_range));
grid_bias = zeros(numel(sigma_range), numel(nu_range));
grid_nSVpercent = zeros(numel(sigma_range), numel(nu_range));
grid_nFN = zeros(numel(sigma_range), numel(nu_range));
grid_area =  NaN(numel(sigma_range), numel(nu_range));
grid_insideSV = zeros(numel(sigma_range), numel(nu_range));
overfit = zeros(numel(sigma_range), numel(nu_range));

for ii = 1:numel(sigma_range)
    for jj = 1:numel(nu_range)
        sigma = sigma_range(ii);
        nu = nu_range(jj);
        fprintf('\n gridsearch: sigma= %5.2f  nu= %.4f \n', sigma, nu)
        SVMModel = fitcsvm (data, ones(length(data),1),'KernelFunction','RBF','Nu',nu,'KernelScale',sigma*sqrt(2));
        bias = SVMModel.Bias;
        grid_bias(ii,jj) = bias;
        svInd = SVMModel.IsSupportVector;
        nSV = sum(svInd); nSVpercent = nSV / length(data) * 100;
        grid_nSVpercent(ii,jj) = nSVpercent;
                
        % nSV check
        if nSVpercent > 40 
            grid_SVMPerformance(ii,jj) = 2;
            fprintf('\n -- High nSV: sigma = %.3f  nu = %.4f \n', sigma, nu)
            fprintf(' -- nSV_percent = %.2f \n', nSVpercent)
            continue;
        end

        % Underfitting check
        [~,hardCscore] = predict(SVMModel,[hardConst(:,1),hardConst(:,2)]);
        % hardCscore = hardCscore - SVMModel.Bias;
        hardCSign = sign(hardCscore);
        hardCcheck = sum(hardCSign(:)==+1);
        if hardCcheck > 0
            grid_SVMPerformance(ii,jj) = -1;
            fprintf('\n -- Underfitting: sigma = %.3f  nu = %.4f \n', sigma, nu)
            fprintf(' -- Hard constraints outside with positive score = %i  nSV = %.3f \n', hardCcheck, nSV)
            continue;
        end

        idx_insideSV = [];
        % Overfitting check
        for kk=1:nSV 
            % fprintf('Checking inside/edge SVs for SV = %i \n', kk)
            % Idx = knnsearch(data,SVMModel.SupportVectors(kk,:),'K',nKnn,'IncludeTies',true);
            Idx = rangesearch(data,SVMModel.SupportVectors(kk,:),5);
            SV_neighbors = data(Idx{1,1},:);
            knn_data = (SV_neighbors - SVMModel.SupportVectors(kk,:))/norm((SV_neighbors - SVMModel.SupportVectors(kk,:)));
            knn_SVMModel = fitcsvm (knn_data(2:end,:), [ones(length(knn_data)-1,1)],'KernelFunction','linear','Nu',0.001);
            [~,knn_SVMscore] = predict(knn_SVMModel,knn_data);
            knn_SVMscore = knn_SVMscore - knn_SVMModel.Bias;
            knn_outliers = sign(knn_SVMscore(:,1)); 
            isInsideSV = sum(knn_outliers(:)==-1);
            if isInsideSV > 15
                grid_insideSV(ii,jj) = grid_insideSV(ii,jj)+1;
                idx_insideSV = [idx_insideSV,kk];
            end
            if grid_insideSV(ii,jj) > 0.2*nSV %0.01*length(data)
                    overfit(ii,jj) = 1;
                    break;
            end  
        end
        if overfit(ii,jj) == 1 
            grid_SVMPerformance(ii,jj) = 1;
            fprintf('\n -- Overfitting: sigma = %.3f  nu = %.3f \n', sigma, nu)
            fprintf(' -- Inside SV found: %i, nSV = %.3f \n', grid_insideSV(ii,jj), nSV)
            continue;
        end

        % nFN check
        [~,SVMscore] = predict(SVMModel,[data(:,1),data(:,2)]);
        % SVMscore = SVMscore - SVMModel.Bias;
        outliers = sign(SVMscore); 
        grid_nFN(ii,jj) = sum(outliers(:)==-1);
        if grid_nFN(ii,jj) > 10 
            grid_SVMPerformance(ii,jj) = 3;
            fprintf('\n -- High FN: sigma = %.3f  nu = %.4f \n', sigma, nu)
            fprintf(' -- High outlier rate:  FN = %i \n', grid_nFN(ii,jj))
            continue;
        end


        % Draw the boundary: Ray tracing
        fprintf('\n ---- Drawing boundary: sigma = %.3f  nu = %.4f \n', sigma, nu)
        rr = linspace(0, r_max, 10);
        thth = linspace(0, 2*pi, 180);
        [r, th] = meshgrid(rr,thth);
        X1 = center(1) + r.*cos(th);
        X2 = center(2) + r.*sin(th);

        [~,score] = predict(SVMModel,[X1(:), X2(:)]);
        scoreGrid = reshape(score,size(X1,1),size(X2,2));

        figure('Position', get(0, 'Screensize'))
        plot(data(:,1),data(:,2),'b.')
        hold on
        plot(data(svInd,1),data(svInd,2),'r+','MarkerSize',10)
        % plot(X1,X2,'g.')
        contour(X1,X2,scoreGrid,'LineWidth',0.2)
        colorbar;
        boundary = contour(X1,X2,scoreGrid,[0,0],'LineWidth',2,EdgeColor='k');
        scatter(hardConst(:,1),hardConst(:,2),'k+','LineWidth',3)
        % scatter(SVMModel.SupportVectors(idx_insideSV,1),SVMModel.SupportVectors(idx_insideSV,2),'ro','LineWidth',3)
        axis equal
        
        grid_area(ii,jj) = polyarea(boundary(1,2:end)-center(1), boundary(2,2:end)-center(2));
        title({['Subject2: healthy arm']...
            ['area=', num2str(round(grid_area(ii,jj))),',   SV_%=', num2str(round(nSVpercent)),',    bias=', num2str(round(bias,1))]...
            ['\nu= ', num2str(round(nu,3)), '  kernelScale (\sigma)= ', num2str(round(sigma))]}, 'FontSize', 11)
        xlabel('Elbow Flexion')
        ylabel('Shoulder Rotation')
        legend('Observation','Support Vectors','boundary function','decision boundary')
        hold off
        saveas(gcf,fullfile(figfolder,(['sigma=', num2str(round(sigma)),' Nu=', num2str(round(nu,3)), '.jpeg'])));
        saveas(gcf,fullfile(figfolder,'.fig\',(['sigma=', num2str(round(sigma)),' Nu=', num2str(round(nu,4)), '.fig'])));
        close gcf

        Subject2_grid{ii,jj}.SVMModel = SVMModel;
        Subject2_grid{ii,jj}.sigma = sigma;
        Subject2_grid{ii,jj}.nu = nu;
        Subject2_grid{ii,jj}.bias = bias;
        Subject2_grid{ii,jj}.nsvPercent = nSVpercent;
        Subject2_grid{ii,jj}.grid_SVMPerformance = grid_SVMPerformance(ii,jj);
        Subject2_grid{ii,jj}.grid_nFN = grid_nFN(ii,jj);
        Subject2_grid{ii,jj}.grid_area = grid_area(ii,jj);
        Subject2_grid{ii,jj}.boundary = boundary;

    end
end

gridsearch_runtime = toc


% % % % % % % % Save gridsearch workspace % % % % % % % % % %
folderPath = '.\models';
folder_name = "svm_gridsearch_2d";
path = fullfile(folderPath, folder_name);
if ~exist(path, 'dir')
    mkdir(path);
end
name = "Subject2_healthy_gridsearch_41";
file = fullfile(path, name);
save (file, "Subject2_grid", "data", "hardConst", "grid_area", "grid_SVMPerformance", ...
    "grid_nFN", "grid_bias", "grid_nSVpercent", "nKnn"); 


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Results of the grid search for nu&sigma

% Nu_axis = {'0.001','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'};
% sigma_axis = {'0.001','0.003','0.01','0.032','0.1','0.32','1','3.2','10','31.6','100','316','1000'};
Nu_axis = {'0.001','0.0025','0.005','0.0075','0.010'};
sigma_axis = {'30','40','50','60','70','80'};
% Nu_axis = {'0.001','0.005','0.010','0.015','0.02','0.025','0.03'};
% sigma_axis = {'0.01','20','40','60','80','100'};
figure('Position', get(0, 'Screensize'))
h1 = heatmap(Nu_axis, sigma_axis, grid_area);
h1.Title = 'Area enclosed by decision boundary';
h1.YLabel = 'KernelScale';
h1.XLabel = 'Nu';
h1.CellLabelFormat = '%.2f';
saveas(gcf,fullfile(figfolder,'area.jpeg'));
saveas(gcf,fullfile(figfolder,'.fig\','area.fig'));
close gcf

figure('Position', get(0, 'Screensize'))
h2 = heatmap(Nu_axis, sigma_axis, grid_nSVpercent);
h2.Title = 'Subject2 Healthy: Number of Support vectors (percent)';
h2.YLabel = 'KernelScale';
h2.XLabel = 'Nu';
saveas(gcf,fullfile(figfolder,'nSV.jpeg'));
close gcf

figure('Position', get(0, 'Screensize'))
h3 = heatmap(Nu_axis, sigma_axis, abs(grid_bias));
h3.Title = 'Subject2 Healthy: |Bias|';
h3.YLabel = 'KernelScale';
h3.XLabel = 'Nu';
h3.CellLabelFormat = '%.2f';
saveas(gcf,fullfile(figfolder,'bias.jpeg'));
close gcf

figure('Position', get(0, 'Screensize'))
h4 = heatmap(Nu_axis, sigma_axis, grid_nFN);
h4.Title = 'Subject2 Healthy: False Negartive points';
h4.YLabel = 'KernelScale';
h4.XLabel = 'Nu';
saveas(gcf,fullfile(figfolder,'nFN.jpeg'));
close gcf

figure('Position', get(0, 'Screensize'))
h6 = heatmap(Nu_axis, sigma_axis,grid_SVMPerformance,'ColorbarVisible','off');
h6.Title = ('Subject2 Healthy: SVM performance (0=acceptable, 1=overfitting, -1=underfitting)');
h6.YLabel = 'KernelScale';
h6.XLabel = 'Nu';
saveas(gcf,fullfile(figfolder,'model.jpeg'));
saveas(gcf,fullfile(figfolder,'.fig\','model.fig'));


% % % %
figure('Position', get(0, 'Screensize'))
h7 = heatmap(Nu_axis, sigma_axis, grid_area./abs(grid_bias));
h7.Title = 'Objective function f_1= area/|bias|';
h7.YLabel = 'KernelScale';
h7.XLabel = 'Nu';
saveas(gcf,fullfile(figfolder,'func1.jpeg'));
close gcf

figure('Position', get(0, 'Screensize'))
h8 = heatmap(Nu_axis, sigma_axis, grid_area./abs(grid_bias)./abs(grid_bias));
h8.Title = 'Objective function f_2= area/(|bias|^2)';
h8.YLabel = 'KernelScale';
h8.XLabel = 'Nu';
saveas(gcf,fullfile(figfolder,'func2.jpeg'));
close gcf

figure('Position', get(0, 'Screensize'))
h9 = heatmap(Nu_axis, sigma_axis, grid_nSVpercent./abs(grid_bias));
h9.Title = 'Objective function f_3= SV_%/|bias|';
h9.YLabel = 'KernelScale';
h9.XLabel = 'Nu';
saveas(gcf,fullfile(figfolder,'func3.jpeg'));
close gcf

figure('Position', get(0, 'Screensize'))
h10 = heatmap(Nu_axis, sigma_axis, (grid_area).*(abs(grid_bias)));
h10.Title = 'Objective function f_4=  area. |bias|';
h10.YLabel = 'KernelScale';
h10.XLabel = 'Nu';
saveas(gcf,fullfile(figfolder,'func4.jpeg'));
close gcf


