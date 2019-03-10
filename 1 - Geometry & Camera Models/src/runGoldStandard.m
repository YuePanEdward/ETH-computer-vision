%file: runGoldStandard.m
%author: Charlotte Moraldo
%date: October 2nd, 2018

function [K, R, t, error] = runGoldStandard(xy, XYZ)

%normalize data points
[xy_normalized,XYZ_normalized,T,U] = normalization(xy,XYZ);

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%denormalize P to visualize hand-clicked points and their reprojection
P_denormalized = inv(T) * P_normalized * U;
visualizeClickedPoints(P_denormalized,xy,XYZ);

%minimize geometric error
pn = [P_normalized(1,:) P_normalized(2,:) P_normalized(3,:)];
for i=1:20
    [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized, i/5);
end
P_opt = [pn(1:4);pn(5:8);pn(9:12)]
P_normalized

%denormalize and factorize camera matrix in to K, R and t
P = inv(T) * P_opt * U
[K, R, C] = decompose(P)
t = -R*C(1:3)

%visualize reprojected points
figure;
visualizeClickedPoints(P,xy,XYZ);

%compute reprojection error
[num1 num2] = size(xy);
XYZ = [XYZ ; ones(1,num2)];
xy = [xy ; ones(1,num2)];
%compute reprojected points
xy_projected = P*XYZ;
for i=1:num2
    scale = xy_projected(3,i);
    xy_projected(:,i) = xy_projected(:,i)/scale;
end
%now compute error
error = 0;
errorMat = xy_projected - xy;
for i=1:num2
    error = error + norm(errorMat(1:2,i));
end
error = error/num2 %average of the errors

end