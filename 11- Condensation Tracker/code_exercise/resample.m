function [ particles_new, particles_w_new ] = resample(particles, particles_w)
% resample the particles based on their weights

low_variance = true; %otherwise resample wheel
[num,len] = size(particles);

if low_variance
    i = 1;
    r = rand()*num^-1;
    c = particles_w(1);
    particles_new = zeros(num,len);
    particles_w_new = zeros(num,1);
    for m = 1:num
        u = r + (m-1)*num^-1;
        while u > c
            i = i + 1;
            if i > num
               i = 1; 
            end
            c = c + particles_w(i);
        end
    particles_new(m,:) = particles(i,:);
    particles_w_new(m) = particles_w(i);
    end 
else
    index = randi(num);
    beta = 0;
    max_weight = max(particles_w);
    particles_new = zeros(size(particles));
    particles_w_new = zeros(size(particles_w));
    for i = 1:num
        beta = beta + rand()*2*max_weight;
        while beta > particles_w(index)
            beta = beta - particles_w(index);
            index = index+1;
            if index > num
                index = 1;
            end
        end
    particles_new(i,:) = particles(index,:);
    particles_w_new(i) = particles_w(index);
    end 
end
    particles_w_new = particles_w_new/sum(particles_w_new);
end