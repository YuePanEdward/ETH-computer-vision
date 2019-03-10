function C = chi2cost(s1,s2)

num1 = numel(s1);
num2 = numel(s2);

C = zeros(num1,num2);

for i=1:num1
    for j=1:num2
       cost = 1/2 .* (s1{i}-s2{j}).^2./(s1{i}+s2{j});
       cost(isnan(cost)) = 0;
       C(i,j) = sum(cost,'all');
    end
end

end