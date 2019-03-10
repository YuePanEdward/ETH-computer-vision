function meanStateAPriori = estimate(particles, particles_w)

meanStateAPriori = sum((particles_w*ones(1,size(particles,2))) .* particles);

end