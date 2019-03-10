function [w_x, w_y, E] = tps_model(X,Y,lambda)

nsamp = size(X,1);

P = [ones(nsamp,1) X];                             % size nsamp x 3
K = U(sqrt(dist2(X,X)));                           % size nsamp x nsamp
K(isnan(K)) = 0;
T = [ [K+lambda*eye(nsamp) P]; [P' zeros(3)]]; % size (nsamp+3) x (nsamp+3)

vx = [Y(:,1); zeros(3,1)]; % size (nsamp+3) x 1
vy = [Y(:,2); zeros(3,1)]; % size (nsamp+3) x 1

fx = T\vx;
fy = T\vy;

w_x = fx(1:nsamp,:);
w_y = fy(1:nsamp,:);

E = w_x'*K*w_x + w_y'*K*w_y;

w_x = fx;
w_y = fy;
end


function map = U(t)
map = t.^2 .* log(t.^2);
end