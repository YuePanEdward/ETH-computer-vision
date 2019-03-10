function P = expectation(mu,var,alpha,X)

K = length(alpha);
N = size(X,1);
P = zeros(N,K);

for n = 1:N
    for k = 1:K
        val = -0.5*(X(n,:)-mu(k,:))*pinv(var(:,:,k))*(X(n,:)-mu(k,:))';
        P(n,k) = alpha(k)/((2*pi)^(3/2)*(det(var(:,:,k)))^(1/2))*...
                 exp(val);
    end
    P(n,:) = P(n,:)/sum(P(n,:));
end
end