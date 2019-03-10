function particles = propagate(particles_old,sizeFrame,params)

num = params.num_particles;
len = size(particles_old,2);
particles = zeros(num,len);

% Define dynamic matrix A and noise w
if params.model == 0
    A = eye(2,2);
    w = [params.sigma_position params.sigma_position];
else
    A = [1 0 1 0;...
         0 1 0 1;...
         0 0 1 0;...
         0 0 0 1];
    w = [params.sigma_position params.sigma_position params.sigma_velocity params.sigma_velocity];
end

for i=1:num
    W = w.*randn(1,len);
    particles(i,:) = particles_old(i,:)*A' + W;
end

particles(:,1) = min(particles(:,1),sizeFrame(2));
particles(:,1) = max(particles(:,1),1);
particles(:,2) = min(particles(:,2),sizeFrame(1));
particles(:,2) = max(particles(:,2),1);

end