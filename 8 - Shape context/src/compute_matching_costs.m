function matchingCostMatrix = compute_matching_costs(objects,nsamp)

num = size(objects,2);

display_flag = false;

X = cell(num,1);
for i=1:num
    X{i} = objects(i).X;
end

matchingCostMatrix = zeros(num,num);

for i=1:num
    for j=1:num
        if i ~= j
            matchingCostMatrix(i,j) = shape_matching(X{i},X{j},display_flag,nsamp);
        else
            matchingCostMatrix(i,j) = inf('single');
        end
    end
    fprintf(['Shape matching of shape ',num2str(i),' done. \n']);
end

end