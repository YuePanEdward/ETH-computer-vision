function vPoints = grid_points(img,nPointsX,nPointsY,border)
    
    vPoints = [];
    [l,w] = size(img);
    
    size_x = floor((l-2*border-1)/(nPointsX-1));
    grid_x = (border+1):(size_x):(l-border);
    
    size_y = floor((w-2*border-1)/(nPointsY-1));
    grid_y = (border+1):(size_y):(w-border);
     
    for x=1:nPointsX
        for y=1:nPointsY
            vPoints = [vPoints; grid_x(x), grid_y(y)];
        end
    end
    
end
