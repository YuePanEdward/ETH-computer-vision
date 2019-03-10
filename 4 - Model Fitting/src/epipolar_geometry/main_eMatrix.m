% =========================================================================
% Exercise 4.3: Essential matrix
% =========================================================================
clear
addpath helpers
addpath images

clickPoints = false;
% dataset = 0;   % Your pictures
% dataset = 1; % ladybug
dataset = 2; % rect
% dataset = 3; % pumpkin

% image names
if(dataset==0)
    imgName1 = '';
    imgName2 = '';

    % Your camera calibration
    K = [];

elseif(dataset==1)
	imgName1 = 'images/ladybug1.jpg';
	imgName2 = 'images/ladybug2.jpg';

	K = [130.5024      0  500.0005
	      0  130.5024  372.3164
	      0         0    1.0000];
elseif(dataset==2)
	imgName1 = 'images/rect1.jpg';
	imgName2 = 'images/rect2.jpg';

	K = [  	1653.5  0    	0982.7;
			0    	1655.3 	0725.4;
			0.0		0.0		1.0 ];
elseif(dataset==3)
	imgName1 = 'images/pumpkin1.jpg';
	imgName2 = 'images/pumpkin2.jpg';

    K = [1197, 0,      466.19;
        0,     1199.1, 314.13;
        0,     0,      1];
end

% read in images
img1 = im2double(imread(imgName1));
img2 = im2double(imread(imgName2));

[pathstr1, name1] = fileparts(imgName1);
[pathstr2, name2] = fileparts(imgName2);

cacheFile = [pathstr1 filesep 'matches_' name1 '_vs_' name2 '.mat'];

% get point correspondences
if (clickPoints)
    [x1s, x2s] = getClickedPoints(img1, img2);
	save(cacheFile, 'x1s', 'x2s', '-mat');
else
	load('-mat', cacheFile, 'x1s', 'x2s');
end


%% YOUR CODE HERE

% image coordinates
nnx1s = inv(K) * x1s;
nnx2s = inv(K) * x2s;

% estimate fundamental matrix
[Eh, E] = essentialMatrix(nnx1s, nnx2s);

% compute the corresponding epipolar lines from F=K_inv'*E*K_inv
F = inv(K') * Eh * inv(K);

[U,S,V] = svd(F);
S(3,3) = 0;
Fh = U*S*V';

% show clicked points
figure(1),hold off, imshow(img1, []); hold on, plot(x1s(1,:), x1s(2,:), '*r');
figure(2),hold off, imshow(img2, []); hold on, plot(x2s(1,:), x2s(2,:), '*r');

% draw epipolar lines and epipoles in img 1 
figure(1)
epipole = V(:,end);
epipole_n = epipole/(epipole(3)); hold on;
plot(epipole_n(1),epipole_n(2),'og','markersize',10);
for k = 1:size(x1s,2)
    drawEpipolarLines(F'*x2s(:,k), img1);
end

% draw epipolar lines and epipoles in img 2
figure(2)
epipole = U(:,end);
epipole_n = epipole/(epipole(3));
plot(epipole_n(1),epipole_n(2),'og','markersize',10); hold on;
for k = 1:size(x2s,2)
    drawEpipolarLines(F*x1s(:,k), img2);
end


%%
% =========================================================================
% Exercise 4.4: Camera matrix
% =========================================================================
% use essential matrix estimate to extract a camera pair
P1 = [eye(3) [0;0;0]];
P2 = decomposeE(Eh, nnx1s, nnx2s);

% triangulate 3D points and plot together with cameras
[Xs,~] = linearTriangulation(P1,nnx1s,P2,nnx2s);
figure(3);
plot3(Xs(1,:),Xs(2,:),Xs(3,:),'x'); hold on;
showCameras({[P1;0,0,0,1],[P2;0,0,0,1]},3); 

