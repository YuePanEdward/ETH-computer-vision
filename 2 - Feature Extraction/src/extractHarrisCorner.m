%file: extractHarrisCorner.m
%author: Charlotte Moraldo
%date: October 9th, 2018

% extract harris corner
%
% Input:
%   img           - n x m gray scale image
%   thresh        - scalar value to threshold corner strength
%   
% Output:
%   corners       - 2 x k matrix storing the keypoint coordinates
%   H             - n x m gray scale image storing the corner strength
function [corners, K] = extractHarrisCorner(img, thresh)

%Blur image to get rid of noise
img_blur = imgaussfilt(img,0.5);

%Compute intensity gradients in x and y direction
[Ix,Iy] = gradient(img_blur);
[num1 num2] = size(img_blur);

%Surround Ix and Iy by 0 to facilitate computations
Ix_augm = zeros(num1+2, num2+2);
Ix_augm(2:(end-1),2:(end-1)) = Ix;
Iy_augm = zeros(num1+2, num2+2);
Iy_augm(2:(end-1),2:(end-1)) = Iy;

%Pre-compute Ix^2, Iy^2, and Ix*Iy
Ix_sq = Ix_augm.*Ix_augm;
Iy_sq = Iy_augm.*Iy_augm;
Ixy = Ix_augm.*Iy_augm;

%Compute Harris response
W_size = 3; %size of the neighbourhood window
H11 = movsum(movsum(Ix_sq,W_size,1), W_size,2);
H22 = movsum(movsum(Iy_sq,W_size,1), W_size,2);
H12 = movsum(movsum(Ixy,W_size,1), W_size,2);
K = (H11.*H22-H12.*H12)./(H11+H22); %compute det(H)/trace(H) elementwise
histogram(K);

%Apply Non-Maximum-Suppression
key = [];
for i=2:(num1+1)
    for j=2:(num2+1)
        K_ij = K(i,j);
        if K_ij > thresh %if K_ij above threshold, apply NMS
            W = K(i-1:i+1,j-1:j+1); %compute window matrix
            [max_num, max_idx]=max(W(:)); %find matrix maximum
            [idx,idy]=ind2sub(size(W),max_idx);%find coordinate (x,y) of 
                                               %the maximum
            if (idx==2) && (idy==2)
                key = [key; i-1 j-1]; %add coordinate to vector key if the
                                      %maximum is in the centre of window
            end
        end
    end
end

corners = key';

end