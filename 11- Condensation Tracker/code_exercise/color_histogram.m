function [ hist ] = color_histogram( xMin, yMin, xMax, yMax, frame, hist_bin )
xMin = round(max(1,xMin));
yMin = round(max(1,yMin));
xMax = round(min(xMax,size(frame,2)));
yMax = round(min(yMax,size(frame,1)));

%Get histValues for each channel
[yR, ~] = imhist(frame(yMin:yMax,xMin:xMax,1), hist_bin);
[yG, ~] = imhist(frame(yMin:yMax,xMin:xMax,2), hist_bin);
[yB, ~] = imhist(frame(yMin:yMax,xMin:xMax,3), hist_bin);

hist = [yR; yG; yB];
hist = hist/sum(hist);
end

