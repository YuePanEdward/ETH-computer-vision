function [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight)

    nBins = 8;
    nEdges = nBins + 1;
    nCells = 4;
    w = cellWidth; % set cell dimensions
    h = cellHeight;

    descriptors = zeros(size(vPoints,1),nBins*4*4); % one histogram for each of the 16 cells
    patches = zeros(size(vPoints,1),4*w*4*h); % image patches stored in rows    
    
    [grad_x,grad_y]=gradient(img);    
    theta = atan2(grad_y,grad_x);
    r = sqrt(grad_y.^2 + grad_x.^2);
    
    edges = linspace(-pi,pi,nEdges);
    
    for i = 1:size(vPoints,1) % for all local feature points
        % Compute local patch
        first_cell = vPoints(i,:) - [nCells/2*w, nCells/2*h];
        local_patch = img(first_cell(1):(first_cell(1)+nCells*w-1),...
                          first_cell(2):(first_cell(2)+nCells*h-1));
        patches(i,:) = local_patch(:);
        
        % Compute histogram for each cell
        hist = zeros(nCells*nCells,8);
        idxCell = 1;
        for x=1:nCells
            for y=1:nCells                
                dx = first_cell(1) + (x-1)*w;
                dy = first_cell(2) + (y-1)*h;
                cell_theta = theta(dx:dx+w-1, dy:dy+h-1);
                hist(idxCell,:) = histcounts(cell_theta,edges);
                idxCell = idxCell + 1;
            end
        end
        
        % Concatenate 16x8 histogram into 1x128
        descriptors(i,:) = reshape(hist',[],1);
        
    end % for all local feature points
    
end
