% Normalization of 2d-pts
% Inputs: 
%           xs = 2d points
% Outputs:
%           nxs = normalized points
%           T = 3x3 normalization matrix
%               (s.t. nx=T*x when x is in homogenous coords)

function [nxs, T] = normalizePoints2d(xs)

num = size(xs,2);

%Compute centroid
xs_cent_x = 0; xs_cent_y = 0;
for i=1:num
    xs_cent_x = xs_cent_x + xs(1,i); 
    xs_cent_y = xs_cent_y + xs(2,i);
end
xs_cent_x = xs_cent_x/num; 
xs_cent_y = xs_cent_y/num;
xs_centroid = [xs_cent_x ; xs_cent_y];

%Transform points to have centroid at origin
T1 = [1   0   -xs_cent_x ; 
      0   1   -xs_cent_y ; 
      0   0        1     ];
xs_origin = T1*xs; 

%Calculate current average Euclidian distance from origin
xs_sum = 0; 
for i=1:num
    xs_sum = xs_sum + sqrt(xs_origin(1,i)^2 + xs_origin(2,i)^2);
end
xs_dist = xs_sum/num; 

%Transform points to rectify Euclidian distance to sqrt(2) and sqrt(3)
T2 = sqrt(2)/xs_dist; 
xs_final = T2*xs_origin; 

%Create T and U transformation matrices
T = T1*T2;
T(3,3) = 1;

%Normalize the points according to the transformations
nxs = T*xs;

end
