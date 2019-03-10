% Compute the fundamental matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences
%
% Output
% 	Fh 			Fundamental matrix with the det F = 0 constraint
% 	F 			Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatrix(x1s, x2s)
[nxs1, T1] = normalizePoints2d(x1s);
[nxs2, T2] = normalizePoints2d(x2s);

x1 = nxs1(1,:);
x2 = nxs2(1,:);
y1 = nxs1(2,:);
y2 = nxs2(2,:);

M = [x1 .* x2           ;
     x2 .* y1           ;
     x2                 ;
     y2 .* x1           ;
     y1 .* y2           ;
     y2                 ;
     x1                 ;
     y1                 ;
     ones(1,size(nxs1,2))]';
 
[~,~,V] = svd(M);
nF_vec = V(:,end);
nF = [nF_vec(1:3,1)' ; nF_vec(4:6,1)' ; nF_vec(7:9,1)'];

F = T2'*nF*T1;

[U,S,V] = svd(F);
S(3,3) = 0;
Fh = U*S*V';

end