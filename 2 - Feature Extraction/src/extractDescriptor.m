%file: extractDescriptor.m
%author: Charlotte Moraldo
%date: October 9th, 2018

% extract descriptor
%
% Input:
%   keyPoints     - detected keypoints in a 2 x n matrix holding the key
%                   point coordinates
%   img           - the gray scale image
%   
% Output:
%   descr         - w x n matrix, stores for each keypoint a
%                   descriptor. m is the size of the image patch,
%                   represented as vector
function descr = extractDescriptor(corners, img)  

descr = [];

%Envelop img by 0 to facilitate computations in case a key point is on
%the outer lines
[num1 num2] = size(img);
img_augm = zeros(num1+8, num2+8);
img_augm(5:(end-4),5:(end-4)) = img;

%extract a 9x9 descriptor matrix for each pixel
for m=1:size(corners,2)
    ij = corners(:,m);
    i = ij(1); j = ij(2);
    extract = img_augm(i-4:i+4,j-4:j+4)';
    descr = [descr, extract(:)]; %store descriptor matrix as a vector
end
end