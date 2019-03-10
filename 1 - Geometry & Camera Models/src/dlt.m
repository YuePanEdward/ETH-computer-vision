%file: dlt.m
%author: Charlotte Moraldo
%date: October 2nd, 2018

function [P] = dlt(xy, XYZ)
%computes DLT, xy and XYZ should be normalized before calling this function

[num1 num2] = size(xy);
A = [];
for i=1:num2
    A_11 = xy(3,i) * XYZ(:,i)';
    A_12 = zeros(1,4);
    A_13 = -xy(1,i) * XYZ(:,i)';
    A_21 = zeros(1,4);
    A_22 = -xy(3,i) * XYZ(:,i)';
    A_23 = xy(2,i) * XYZ(:,i)';
    A = [A; A_11 A_12 A_13; A_21 A_22 A_23];
end

%compute SVD and extract P
[U,S,V] = svd(A);
P_vec = V(:,end);
P = [P_vec(1:4,1)' ; P_vec(5:8,1)' ; P_vec(9:12,1)'];
end

