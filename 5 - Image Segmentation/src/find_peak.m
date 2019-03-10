function peak = find_peak(X, xl, r)
    % Finds the mode of the density function for a given pixel xl
    % > X is the discrete samples of the density function and is a matrix
    %   with size L x n
    % > L is the total number of pixels in the image and n=3 for the L*a*b
    %   value

    L = size(X,1);
    curr_pixel = xl;
    thresh = 1; 
    shift_dist = thresh+1;

    while shift_dist > thresh
        curr_pixel_matrix = repmat(curr_pixel, [L, 1]);
        dist_point_space = sqrt(sum((X - curr_pixel_matrix).^2, 2));
        window = X(dist_point_space < r,:);
        new_pixel = mean(window,1);
        shift_dist = norm(curr_pixel-new_pixel);
        curr_pixel = new_pixel;
    end
    peak = new_pixel;

end

