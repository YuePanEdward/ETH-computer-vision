% Compute the essential matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences 3xn matrices
%
% Output
% 	Eh 			Essential matrix with the det F = 0 constraint and the constraint that the first two singular values are equal
% 	E 			Initial essential matrix obtained from the eight point algorithm
%

function [Eh, E] = essentialMatrix(x1s, x2s)

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
nE_vec = V(:,end);
nE = [nE_vec(1:3,1)' ; nE_vec(4:6,1)' ; nE_vec(7:9,1)'];

E = T2'*nE*T1;

[U,S,V] = svd(E);
S = diag([(S(1,1)+S(2,2))/2,(S(1,1)+S(2,2))/2,0]);
Eh = U*S*V';
end
