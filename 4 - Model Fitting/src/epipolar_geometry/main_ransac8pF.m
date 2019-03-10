% =========================================================================
% Exercise 4.5: Feature extraction and matching
% =========================================================================
clear
addpath helpers
addpath toolbox

%Load images
% imgName1 = ''; % Try with some different pairs
% imgName2 = '';
imgName1 = 'images/rect1.JPG';
imgName2 = 'images/rect2.JPG';

img1 = single(rgb2gray(imread(imgName1)));
img2 = single(rgb2gray(imread(imgName2)));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);
[matches, scores] = vl_ubcmatch(da, db);

corner1 = fa(1:2, matches(1,:));
corner2 = fb(1:2, matches(2,:));

x1s = [corner1; ones(1,size(matches,2))];
x2s = [corner2; ones(1,size(matches,2))];

%Show both images
showFeatureMatches(img1, corner1, img2, corner2, 1);

%Show only one image
figure(3); imshow(img1, []);    
hold on, plot(corner1(1,:), corner1(2,:), '+r');
hold on, plot(corner2(1,:), corner2(2,:), '+r');    
hold on, plot([corner1(1,:); corner2(1,:)], [corner1(2,:); corner2(2,:)], 'b'); 

%%
% =========================================================================
% Exercise 4.6: 8-point RANSAC
% =========================================================================

threshold = 5;

[inliers1, inliers2, outliers1, outliers2, M, F] = ransac8pF(x1s, x2s, threshold);

showFeatureMatches(img1, inliers1(1:2,:), img2, inliers2(1:2,:), 4);
showFeatureMatches(img1, outliers1(1:2,:), img2, outliers2(1:2,:), 5);

figure(6); imshow(img1, []);    
hold on, plot(inliers1(1,:), inliers1(2,:), '+r');
hold on, plot(inliers2(1,:), inliers2(2,:), '+r');    
hold on, plot([inliers1(1,:); inliers2(1,:)], [inliers1(2,:); inliers2(2,:)], 'b'); 

% =========================================================================