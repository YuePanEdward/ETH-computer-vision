%file: runGoldStandardRadial.m
%author: Charlotte Moraldo
%date: October 2nd, 2018

function [K, R, t, k, error] = runGoldStandardRadial(xy, XYZ, rad)

%normalize data points
[xy_normalized,XYZ_normalized,T,U] = normalization(xy,XYZ);

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%minimize geometric error
pn = [Pn(1,:) Pn(2,:) Pn(3,:)];
for i=1:20
    [pn] = fminsearch(@fminGoldStandardRadial, pn, [], xy_normalized, XYZ_normalized, i/5);
end
P_opt_rad = [pn(1:4);pn(5:8);pn(9:12)];

%denormalize and factorize camera matrix in to K, R and t
P = inv(T) * P_opt_rad * U;
[K, R, C] = decompose(P);
t = -R*C(1:3);

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
error_radial = 0;
errorMat = xy_projected - xy;
for i=1:num2
    error_radial = error_radial + norm(errorMat(1:2,i));
end
error_radial = error_radial/num2 %average of the errors

end