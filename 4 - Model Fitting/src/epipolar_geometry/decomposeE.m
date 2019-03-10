% Decompose the essential matrix
% Return P = [R|t] which relates the two views
% You will need the point correspondences to find the correct solution for P
function P = decomposeE(E, x1, x2)

[U,~,V] = svd(E);
t = U(:,end);
t = t/norm(t);
W = [0 -1  0; 
     1  0  0; 
     0  0  1];

R1 = U * W * V';
R2 = U * W' * V';

R1 = R1/det(R1);
R2 = R2/det(R2);

P0 = [eye(3) zeros(3,1)];
P1 = [R1, t];
P2 = [R1, -t];
P3 = [R2, t];
P4 = [R2, -t];
P_all = {P1,P2,P3,P4};

good_P = 0;
for i = 1:4
    %3d point Xs in main coordinate frame:
    [Xs,~] = linearTriangulation(P0,x1,P_all{i},x2); 
    %3d point Xs in frame of camera P:
    PXs = P_all{i}*Xs;
    
    if min(Xs(3,:)) > 0 && min(PXs(3,:)) > 0;
       good_P = good_P + 1;
       if good_P == 1
           P = P_all{i};
       elseif good_P > 1
           error('Several P work');
       elseif good_P == 0
           error('No P found');
       end
    end
end  

end