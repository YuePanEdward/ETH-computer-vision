function [in1, in2, out1, out2, m, F] = ransac8pF(x1, x2, threshold)

%Initialization
N = 8;
err = 0;
m = 0;
m_max = 1000;
bestInliers = 0;

num = size(x1,2);
x1(3,:) = ones(1,num);
x2(3,:) = ones(1,num);
in1 = []; in2 = [];
out1 = []; out2 = [];

% %Adaptative RANSAC parameters
% p = 0.99;
% n = m_max;

for m = 1:m_max %standard ransac
%while (m < n) %adaptive ransac
    index = randperm(num,N);
    x1s = x1(:,index);
    x2s = x2(:,index);
    [~,F_try] = fundamentalMatrix(x1s,x2s);
    
    inliers = [];
    outliers = [];
    
    for i=1:num   
        point1 = x1(:,i);
        point2 = x2(:,i);
        err = distPointLine(point2,F_try*point1) + ...
              distPointLine(point1,F_try'*point2);       
        if err < threshold
            inliers = [inliers i];
        else
            outliers = [outliers i];
        end
    end
    
    if numel(inliers) > bestInliers
       in1 = x1(1:2,inliers);
       in2 = x2(1:2,inliers);
       out1 = x1(1:2,outliers);
       out2 = x2(1:2,outliers);
       bestInliers = numel(inliers);
       
%        % adaptive ransac
%        ratio = bestInliers/num;
%        num_samples = N;
%        confidence = p;
%        n = round(log(1-confidence)/log(1-ratio^num_samples));
    end
%     % adaptive ransac
%     m = m+1;
end

[~,F] = fundamentalMatrix([in1;ones(1,bestInliers)],[in2;ones(1,bestInliers)]);

end