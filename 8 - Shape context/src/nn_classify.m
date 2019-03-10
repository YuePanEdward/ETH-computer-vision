function testClass = nn_classify(matchingCostVector,trainClasses,k)

[cost,idx] = sort(matchingCostVector);

cost(k+1:end) = [];
idx(k+1:end) = [];

class = [0 0 0];

for i=idx
    if strcmpi(trainClasses{i},'Heart')
        class(1) = class(1)+1;
    elseif strcmpi(trainClasses{i},'Fork')
        class(2) = class(2)+1;
    elseif strcmpi(trainClasses{i},'Watch')
        class(3) = class(3)+1;
    end
end

[bestClass,i] = max(class);

if i==1
   testClass = 'Heart';
elseif i==2
   testClass = 'Fork';
elseif i==3
   testClass = 'Watch';
end

end