%file: decompose.m
%author: Charlotte Moraldo
%date: October 2nd, 2018

function [ K, R, C ] = decompose(P)
%decompose P into K, R and t

M = P(1:3,1:3);
[R_inv, K_inv] = qr(inv(M));
R = inv(R_inv);
K = inv(K_inv);
scale = K(3,3);

%scale K and R such that K(3,3) = 1 and that K*R remains equal
K = K/scale;
R = R*scale;

%C is equal to the right-null vector of P
[U_P,S_P,V_P] = svd(P);
C = V_P(:,end);
C = C/C(end);

end