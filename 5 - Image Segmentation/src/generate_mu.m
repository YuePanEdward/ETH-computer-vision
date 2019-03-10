% Generate initial values for mu
% K is the number of segments

function mu = generate_mu(delta_L, delta_a, delta_b, K)

mu = zeros(K,3);

%each of the mu(k) must be a 3x1 vector representing a point in the L*a*b space
%spread mu equally in the L*a*b space
for i = 1:K
    mu(i,:) = [i*delta_L, i*delta_a, i*delta_b] / (K+1);
end

end