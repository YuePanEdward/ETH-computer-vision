function particles_w = observe(particles,frame,H,W,hist_bin,hist_target,sigma_observe)

num = length(particles);

particles_w = zeros(num,1);

xMin = particles(:,1) - W/2.*ones(num,1);
yMin = particles(:,2) - H/2.*ones(num,1);
xMax = particles(:,1) + W/2.*ones(num,1);
yMax = particles(:,2) + H/2.*ones(num,1);

% Compute color histograms
for i=1:num
    hist_i = color_histogram(xMin(i),yMin(i),xMax(i),yMax(i),frame,hist_bin);
    
    % Update
    chi = chi2_cost(hist_target,hist_i);

    particles_w(i) = 1/(sqrt(2*pi)*sigma_observe) * ...
                       exp(-chi^2/(2*sigma_observe^2));
end
particles_w = particles_w/sum(particles_w);

end