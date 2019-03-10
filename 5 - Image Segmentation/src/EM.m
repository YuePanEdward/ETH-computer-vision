function [map cluster] = EM(img)

%% Initialization
%Create density function X
img = double(img);
L = size(img,1)*size(img,2);
X = [reshape(img(:,:,1),L,1),...
    reshape(img(:,:,2),L,1),...
    reshape(img(:,:,3),L,1)];

%Number of segments
K = 3;

%Boundaries of the L*a*b space
delta_L = max(X(:,1)) - min(X(:,1));
delta_a = max(X(:,2)) - min(X(:,1));
delta_b = max(X(:,3)) - min(X(:,3));


%% Generate mus and covariances
%alpha
alpha_curr = 1/K * ones(1,K);

% use function generate_mu to initialize mus
mu_curr = generate_mu(delta_L, delta_a, delta_b, K);

% use function generate_cov to initialize covariances
cov_curr = generate_cov(delta_L, delta_a, delta_b, K);
 

%% Iterate between maximization and expectation
thresh = 0.7;
crit = thresh+1;
iter = 1;

while crit > thresh
    % use function expectation
    P = expectation(mu_curr,cov_curr,alpha_curr,X);
    
    % use function maximization
    [mu_new, cov_new, alpha_new] = maximization(P, X);
    
    % stop criterion 
    crit = norm(mu_new(:)-mu_curr(:));
    
    % update variables
    mu_curr = mu_new;
    cov_curr = cov_new;
    alpha_curr = alpha_new;
    
    text = ['Done with iteration ',num2str(iter),'.\n'];
    fprintf(text);
    crit
    iter = iter + 1;
end

[~,index] = max(P,[],2);
map = reshape(index,size(img(:,:,1)));
cluster = mu_curr';

mu_curr
cov_curr
alpha_curr

end