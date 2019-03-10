%file: normalization.m
%author: Charlotte Moraldo
%date: October 2nd, 2018

function [xyn, XYZn, T, U] = normalization(xy, XYZ)

[num1, num2] = size(xy);
xy = [xy ; ones(1,num2)];
XYZ = [XYZ ; ones(1,num2)];

%Compute centroid
xy_cent_x = 0; xy_cent_y = 0;
XYZ_cent_x = 0; XYZ_cent_y = 0; XYZ_cent_z = 0;
for i=1:num2
    xy_cent_x = xy_cent_x + xy(1,i); 
    xy_cent_y = xy_cent_y + xy(2,i);
    XYZ_cent_x = XYZ_cent_x + XYZ(1,i);
    XYZ_cent_y = XYZ_cent_y + XYZ(2,i);
    XYZ_cent_z = XYZ_cent_z + XYZ(3,i);
end
xy_cent_x = xy_cent_x/num2; 
xy_cent_y = xy_cent_y/num2;
XYZ_cent_x = XYZ_cent_x/num2; 
XYZ_cent_y = XYZ_cent_y/num2; 
XYZ_cent_z = XYZ_cent_z/num2;
xy_centroid = [xy_cent_x ; xy_cent_y];
XYZ_centroid = [XYZ_cent_x ; XYZ_cent_y ; XYZ_cent_z];

%Transform points to have centroid at origin
T1 = [1   0   -xy_cent_x ; 
      0   1   -xy_cent_y ; 
      0   0        1     ];
  
U1 = [1   0   0   -XYZ_cent_x ; 
      0   1   0   -XYZ_cent_y ; 
      0   0   1   -XYZ_cent_z ; 
      0   0   0       1];

xy_origin = T1*xy; 
XYZ_origin = U1*XYZ;

%Calculate current average Euclidian distance from origin
xy_sum = 0; XYZ_sum = 0;
for i=1:num2
    xy_sum = xy_sum + sqrt(xy_origin(1,i)^2 + xy_origin(2,i)^2);
    XYZ_sum = XYZ_sum + sqrt(XYZ_origin(1,i)^2 + XYZ_origin(2,i)^2 ... 
              + XYZ_origin(3,i)^2);
end
xy_dist = xy_sum/num2; 
XYZ_dist = XYZ_sum/num2;

%Transform points to rectify Euclidian distance to sqrt(2) and sqrt(3)
T2 = sqrt(2)/xy_dist; 
U2 = sqrt(3)/XYZ_dist;
xy_final = T2*xy_origin; 
XYZ_final = U2*XYZ_origin;

%Create T and U transformation matrices
T = T1*T2;
T(3,3) = 1;
U = U1*U2;
U(4,4) = 1;

%Normalize the points according to the transformations
xyn = T*xy;
XYZn = U*XYZ;


end