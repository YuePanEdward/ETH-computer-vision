%file: visualizeAllPoints.m
%author: Charlotte Moraldo
%date: October 2nd, 2018

function visualizeAllPoints(P)

%xz plane
for x=0:7
    for z=0:8 
        object_pt = [x*0.027; 0; z*0.027; 1];
        image_pt = P * object_pt;
        scale = image_pt(3);
        image_pt = image_pt / scale;
        plot(image_pt(1),image_pt(2),'Marker','+','MarkerEdgeColor','r',...
             'MarkerSize', 8, 'linewidth',2); hold on;
    end
end
%yz plane
for y=0:7
    for z=0:8 
        object_pt = [0; y*0.027; z*0.027; 1];
        image_pt = P * object_pt;
        scale = image_pt(3);
        image_pt = image_pt / scale;
        plot(image_pt(1),image_pt(2),'Marker','+','MarkerEdgeColor','g',...
             'MarkerSize', 8, 'linewidth',2); hold on;
    end
end

end