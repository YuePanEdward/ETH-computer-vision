function diffs = diffsGC(img1, img2, dispRange)
% get data costs for graph cut

range = dispRange(end)-dispRange(1);
b_size = 10;
diffs = zeros(size(img1,1),size(img1,2),range);

%create filter
b_filter = fspecial('average',b_size);

for d=1:(range+1)
    %Shift image by d and compute image difference
    offset = -1+ceil(range/2);
    shifted_img = (img1 - shiftImage(img2,d-offset)).^2; 
    %Convolve with box filter
    diffs(:,:,d) = conv2(shifted_img,b_filter,'same');
end

end