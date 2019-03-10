function [k, b] = ransacLine(data, iter, threshold)
% data: a 2xn dataset with #n data points
% iter: the number of iterations
% threshold: the threshold of the distances between points and the fitting line

num_pts = size(data,2); % Total number of points
best_inliers = 0;       % Best fitting line with largest number of inliers
k=0; b=0;               % Parameters for best fitting line

for i=1:iter
    % Randomly select 2 points
    rand_index = randperm(num_pts,2);
    pt1 = data(:,rand_index(1));
    pt2 = data(:,rand_index(2));
    
    %Fit line to the 2 points
    line_coef = polyfit([pt1(1) pt2(1)],[pt1(2) pt2(2)],1);
    k_fit = line_coef(1);
    b_fit = line_coef(2);
    
    % Compute the distances between all points with the fitting line    
    distances = abs(k_fit*data(1,:)+b_fit-data(2,:));
    
    % Compute the inliers with distances smaller than the threshold
    inliers = find(distances < threshold);
    
    % Update the number of inliers and fitting model if better model is found
    if (numel(inliers) > best_inliers)
       best_inliers = numel(inliers);
       line_coef = polyfit(data(1,inliers), data(2,inliers), 1);
       k = line_coef(1);
       b = line_coef(2);
    end
    
end


end
