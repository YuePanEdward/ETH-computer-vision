function [map peak] = meanshiftSeg(img)

%Create density function X
img = double(img);
L = size(img,1)*size(img,2);
X = [reshape(img(:,:,1),L,1),...
    reshape(img(:,:,2),L,1),...
    reshape(img(:,:,3),L,1)];

%Shift window to mean until convergence
peak = []; curr_peak = [];
map = zeros(size(img(:,:,1)));
radius = 7;

for i=1:L
    %Find peak
    curr_peak = find_peak(X, X(i,:), radius);
    %Create peak matrix
    if i==1
        peak = [peak; curr_peak];
        map(i) = size(peak,1);
    else
        %Check distance from current peak to all other peaks
        curr_peak_matrix = repmat(curr_peak, size(peak,1), 1);
        dist_peak = sqrt(sum((peak - curr_peak_matrix).^2, 2));
        
        %Add current peak to matrix if distance < r/2
        idx = find(dist_peak < radius/2);
        if isempty(idx)
            peak = [peak; curr_peak];
            map(i) = size(peak,1);
        else
            min_dist = dist_peak(idx(1));
            min_id = 1;
            for j=1:size(idx,1)
                new_dist = dist_peak(idx(j));
                if new_dist < min_dist
                    min_dist = new_dist;
                    min_id = j;
                end
            end
            map(i) = idx(min_id);
        end
    end
end
end