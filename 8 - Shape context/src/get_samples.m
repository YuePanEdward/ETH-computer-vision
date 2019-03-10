function X_nsamp = get_samples(X,nsamp)

x = X(:,1);
y = X(:,2);

N=length(x);
Nstart=min(nsamp,N);

ind0=randperm(N);
ind0=ind0(1:Nstart);

X_nsamp(:,1)=x(ind0);
X_nsamp(:,2)=y(ind0);

end