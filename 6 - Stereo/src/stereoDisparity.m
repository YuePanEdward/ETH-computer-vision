function disp = stereoDisparity(img1, img2, dispRange)

% dispRange: range of possible disparity values
% --> not all values need to be checked

img1 = double(img1);
img2 = double(img2);

b_size = 20;
start = dispRange(1);

%create filter
b_filter = fspecial('average',b_size);

for d = dispRange  
    %Shift image by d and compute image difference
    img_diff = (img1 - shiftImage(img2,d)).^2;
    
    %Convolve with box filter
    curr_diff = conv2(img_diff,b_filter,'same');
    
    %Remember best disparity for each pixel
    if d==start
        best_diff = curr_diff;
        disparity = d*ones(size(curr_diff));
    else
        mask = curr_diff < best_diff;
        invmask = curr_diff >= best_diff;
        disparity = disparity.*invmask + d.*mask;
        best_diff = best_diff.*invmask + curr_diff.*mask;
    end
end
disp = disparity;
end