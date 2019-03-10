% Generate initial values for the K
% covariance matrices

function cov = generate_cov(delta_L, delta_a, delta_b, K)

cov = zeros(3,3,K);
for i=1:K
    cov(:,:,i) = diag([delta_L, delta_a, delta_b]);
end

end