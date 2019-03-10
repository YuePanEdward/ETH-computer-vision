% =========================================================================
% Exercise 8
% =========================================================================

% Initialize VLFeat (http://www.vlfeat.org/)

%K Matrix for house images (approx.)
K = [  670.0000     0     393.000
         0       670.0000 275.000
         0          0        1];

thresh_fund = 0.0001;
thresh_proj = 0.05;     

%Load images
imgName1 = '../data/house.000.pgm';
imgName2 = '../data/house.004.pgm';

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);

%don't take features at the top of the image - only background
filter = fa(2,:) > 100;
fa = fa(:,find(filter));
da = da(:,find(filter));

[matches,~] = vl_ubcmatch(da, db);

%showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 20);
xa = makehomogeneous(fa(1:2, matches(1,:)));
xb = makehomogeneous(fb(1:2, matches(2,:)));


%% Compute essential matrix and projection matrices and triangulate matched points
%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
%and decompose the essential matrix and create the projection matrices

%extract feature matches, inliers, outliers and plot them
[F, inliers] = ransacfitfundmatrix(xa, xb, thresh_fund);
outliers = setdiff(1:size(matches,2),inliers);
xa_in = xa(:,inliers);
xb_in = xb(:,inliers);
xa_out = xa(:,outliers);
xb_out = xb(:,outliers);
showFeatureMatches(img1, xa_out(1:2,:), img2, xb_out(1:2,:), 21);
showFeatureMatches(img1, xa_in(1:2,:), img2, xb_in(1:2,:), 22);

%compute essential matrix
E = K'*F*K;

% draw epipolar lines and epipoles in img 1 
figure(1);
figure(1), clf, imshow(img1, []); hold on, plot(xa_in(1,:), xa_in(2,:), '*r');
for k = 1:size(xa_in,2)
    drawEpipolarLines(F'*xb_in(:,k), img1); hold on;
end

% draw epipolar lines and epipoles in img 2
figure(2);
figure(2), clf, imshow(img2, []); hold on, plot(xb_in(1,:), xb_in(2,:), '*r');
for k = 1:size(xb_in,2)
    drawEpipolarLines(F*xa_in(:,k), img2); hold on;
end

%compute projetion matrices
xa_calibrated = K \ xa_in;
xb_calibrated = K \ xb_in;
Ps{1} = eye(4);
Ps{2} = decomposeE(E, xa_calibrated, xb_calibrated);

%triangulate the inlier matches with the computed projection matrix
[X2, ~] = linearTriangulation(Ps{1}, xa_calibrated, Ps{2}, xb_calibrated);


%% Add view 3
imgName3 = '../data/house.001.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);

%match against the features from image 1 that where triangulated
fa_in = fa(:,matches(1,inliers));
da_in = da(:,matches(1,inliers));

[matches3,~] = vl_ubcmatch(da_in, dc);
xa_in3 = makehomogeneous(fa_in(1:2, matches3(1,:)));
xc = makehomogeneous(fc(1:2, matches3(2,:)));
xc_calibrated = K \ xc;

%run 6-point ransac
[Ps{3}, inliers3] = ransacfitprojmatrix(xc_calibrated, X2(:,matches3(1,:)), thresh_proj);
outliers3 = setdiff(1:size(matches3,2),inliers3);
if (det(Ps{3}(1:3,1:3)) < 0 )
    Ps{3}(1:3,1:3) = -Ps{3}(1:3,1:3);
    Ps{3}(1:3, 4) = -Ps{3}(1:3, 4);
end

% Plot inliers and outliers
% showFeatureMatches(img1,xa_in3(1:2,inliers3),img3,xc(1:2,inliers3),3)
% showFeatureMatches(img1,xa_in3(1:2,outliers3),img3,xc(1:2,outliers3),4)
showInliersOutliers(img1,xa_in3(1:2,inliers3),xa_in3(1:2,outliers3),...
                    img3,xc(1:2,inliers3),xc(1:2,outliers3),3)

%triangulate the inlier matches with the computed projection matrix
xc_in_calibrated3 = K\xa_in3;
[X3, ~] = linearTriangulation(Ps{1}, xc_in_calibrated3(:,inliers3), ...
                              Ps{3}, xc_calibrated(:,inliers3));

%% Add view 4
imgName4 = '../data/house.002.pgm';
img4 = single(imread(imgName4));
[fd, dd] = vl_sift(img4);

[matches4,~] = vl_ubcmatch(da_in, dd);
xa_in4 = makehomogeneous(fa_in(1:2, matches4(1,:)));
xd = makehomogeneous(fd(1:2, matches4(2,:)));
xd_calibrated = K \ xd;

%run 6-point ransac
[Ps{4}, inliers4] = ransacfitprojmatrix(xd_calibrated, X2(:,matches4(1,:)), thresh_proj);
outliers4 = setdiff(1:size(matches4,2),inliers4);
if (det(Ps{4}(1:3,1:3)) < 0 )
    Ps{4}(1:3,1:3) = -Ps{4}(1:3,1:3);
    Ps{4}(1:3, 4) = -Ps{4}(1:3, 4);
end

% Plot inliers
% showFeatureMatches(img1,xa_in4(1:2,inliers4),img4,xd(1:2,inliers4),5)
% showFeatureMatches(img1,xa_in4(1:2,outliers4),img4,xd(1:2,outliers4),6)
showInliersOutliers(img1,xa_in4(1:2,inliers4),xa_in4(1:2,outliers4),...
                    img4,xd(1:2,inliers4),xd(1:2,outliers4),4)

%triangulate the inlier matches with the computed projection matrix
xd_in_calibrated4 = K\xa_in4;
[X4, ~] = linearTriangulation(Ps{1}, xd_in_calibrated4(:,inliers4), ...
                              Ps{4}, xd_calibrated(:,inliers4));

%% Add view 5
imgName5 = '../data/house.003.pgm';
img5 = single(imread(imgName5));
[fe, de] = vl_sift(img5);

[matches5,~] = vl_ubcmatch(da_in, de);
xa_in5 = makehomogeneous(fa_in(1:2, matches5(1,:)));
xe = makehomogeneous(fe(1:2, matches5(2,:)));
xe_calibrated = K \ xe;

%run 6-point ransac
[Ps{5}, inliers5] = ransacfitprojmatrix(xe_calibrated, X2(:,matches5(1,:)), thresh_proj);
outliers5 = setdiff(1:size(matches5,2),inliers5);
if (det(Ps{5}(1:3,1:3)) < 0 )
    Ps{5}(1:3,1:3) = -Ps{5}(1:3,1:3);
    Ps{5}(1:3, 4) = -Ps{5}(1:3, 4);
end

% Plot inliers
% showFeatureMatches(img1,xa_in5(1:2,inliers5),img5,xe(1:2,inliers5),7)
% showFeatureMatches(img1,xa_in5(1:2,outliers5),img5,xe(1:2,outliers5),8)
showInliersOutliers(img1,xa_in5(1:2,inliers5),xa_in5(1:2,outliers5),...
                    img5,xe(1:2,inliers5),xe(1:2,outliers5),5)

%triangulate the inlier matches with the computed projection matrix
xe_in_calibrated5 = K \ xa_in5;
[X5, ~] = linearTriangulation(Ps{1}, xe_in_calibrated5(:,inliers5), ...
                              Ps{5}, xe_calibrated(:,inliers5));


%% Plot stuff
fig=20; 
figure(fig)

%use plot3 to plot the triangulated 3D points
plot3(X2(1,:),X2(2,:),X2(3,:),'r.'); hold on;
plot3(X3(1,:),X3(2,:),X3(3,:),'g.'); hold on;
plot3(X4(1,:),X4(2,:),X4(3,:),'b.'); hold on;
plot3(X5(1,:),X5(2,:),X5(3,:),'y.'); hold on;

%draw cameras
drawCameras(Ps, fig)
