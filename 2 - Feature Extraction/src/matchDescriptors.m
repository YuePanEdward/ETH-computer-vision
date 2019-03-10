%file: matchDescriptors.m
%author: Charlotte Moraldo
%date: October 9th, 2018

% match descriptors
%
% Input:
%   descr1        - k x n descriptor of first image
%   descr2        - k x m descriptor of second image
%   thresh        - scalar value to threshold the matches
%   
% Output:
%   matches       - 2 x w matrix storing the indices of the matching
%                   descriptors

function matches = matchDescriptors(descr1, descr2, thresh)
matches = [];
for i = 1:size(descr1,2)
    for j = 1:size(descr2,2)
        ssd1 = 0;
        diff = (descr1(:,i) - descr2(:,j)).^2 ;
        ssd1 = sum(diff); %compute ssd
        if j==1
            ssd_min = ssd1;
            j_min = j;
        elseif ssd1 < ssd_min
            ssd2 = ssd_min; %store 2nd best ssd
            ssd_min = ssd1; %new best ssd stored in ssd_min
            j_min = j;
        end
    end
    if ssd_min <= thresh
        ratio = ssd_min/ssd2; %ratio between best and second best ssd
        t = 0.6; %threshold for tuning the ratio
        if abs(ratio-1) >= t
            matches = [matches [i;j_min]]; %match only if ratio good
        end
    end
end
end