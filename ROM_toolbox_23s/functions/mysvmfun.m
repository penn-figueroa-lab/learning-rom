function [objective,constraint] = mysvmfun(z,data)

low = min(data); up = max(data);
center = (low+up)/2;

% % X_Test: 10% of data points in the center region 
% % center & radius change based on data
c = [60 100 50; 20 40 20];
points_within_radius = [];
for j = 1:size(c,1)
    for i = 1:size(data, 1)
        distance = norm(data(i,:) - c(j,1:2));
        if distance <= c(j,3)
            points_within_radius = [points_within_radius; data(i,:)];
        end
    end
end 
if length(points_within_radius)>length(data) * 0.1
    num_points_to_select = floor(length(data) * 0.1);
else
    num_points_to_select = floor(length(points_within_radius));
end
random_indices = randperm(length(points_within_radius), num_points_to_select);
X_test = points_within_radius(random_indices, :);
data(random_indices, :) = [];

% % Add upper and lower limits as hard constraints 
hardConst = [low(1)-3 center(2) ; ...
             up(1)+3 center(2) ; ...
             center(1) low(2)-3 ; ...
             center(1) up(2)+3 ;];

SVMModel = fitcsvm(data,ones(length(data),1),'KernelFunction','rbf',...
    'Nu',z.nu,'KernelScale',z.sigma);
bias = SVMModel.Bias;
svInd = SVMModel.IsSupportVector;
nSV = sum(svInd); nSVpercent = nSV / length(data) * 100;

rangeD = range(data,1);
r_max = norm(rangeD/2);
rr = linspace(0, r_max, 10);
thth = linspace(0, 2*pi, 180);
[r, th] = meshgrid(rr,thth);
X1 = center(1) + r.*cos(th);
X2 = center(2) + r.*sin(th);

[~,score] = predict(SVMModel,[X1(:), X2(:)]);
scoreGrid = reshape(score,size(X1,1),size(X2,2));
boundary = contour(X1,X2,scoreGrid,[0,0],'LineWidth',2,EdgeColor='k');
area = polyarea(boundary(1,2:end)-center(1), boundary(2,2:end)-center(2));

objective = nSVpercent * area / (abs(bias))^3;

[~,testScore] = predict(SVMModel,[X_test(:,1),X_test(:,2)]);
testSign = sign(testScore);
overfitPoints = sum(testSign(:)==-1);

[~,hardCscore] = predict(SVMModel,[hardConst(:,1),hardConst(:,2)]);
        hardCSign = sign(hardCscore);
        hardCcheck = sum(hardCSign(:)==+1);
constraint = abs(overfitPoints)+hardCcheck;

end
