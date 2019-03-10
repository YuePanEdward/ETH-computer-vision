%file: visualizeClickedPoints.m
%author: Charlotte Moraldo
%date: October 2nd, 2018

function visualizeClickedPoints(P,xy,XYZ)

IMG_NAME = 'images/image002.jpg';
[ind num] = size(xy);
XYZ = [XYZ; ones(1,num)];

img = imread(IMG_NAME);
imshow(img); hold on;

for i=1:num
    plot(xy(1,i),xy(2,i),'Marker','o','MarkerEdgeColor','c','MarkerSize',...
        15, 'linewidth',2); hold on;
    xy_projected = P * XYZ(:,i);
    scale = xy_projected(3);
    xy_projected = xy_projected / scale;
    plot(xy_projected(1),xy_projected(2),'Marker','o','MarkerEdgeColor',...
        'b', 'MarkerSize', 15, 'linewidth',2); hold on;
end

visualizeAllPoints(P);

end