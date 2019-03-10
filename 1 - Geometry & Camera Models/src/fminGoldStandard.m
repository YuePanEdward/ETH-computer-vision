%file: fminGoldStandard.m
%author: Charlotte Moraldo
%date: October 2nd, 2018

function f = fminGoldStandard(p, xy, XYZ, w)

%reassemble P
P = [p(1:4);p(5:8);p(9:12)];

%compute reprojected points
[num1 num2] = size(xy);
xy_projected = P*XYZ;
for i=1:num2
    scale = xy_projected(3,i);
    xy_projected(:,i) = xy_projected(:,i)/scale;
end

%compute squared geometric error
f = 0;
errorMat = xy_projected - xy;
for i=1:num2
    f = f + norm(errorMat(1:2,i))^2;
end

end