function coords = generatePointCloudFromDisps(disps,PL,PR)
% for each pixel (x,y) find the corresponding 3D point
coords = zeros([size(disps) 3]);
for y=1:size(disps,1)
    for x=1:size(disps,2)
        p1 = [x y];
        p2 = [x - disps(y, x) y];
        coords(y,x,1:3) = linTriang(p1,p2,PL,PR);
    end
end
