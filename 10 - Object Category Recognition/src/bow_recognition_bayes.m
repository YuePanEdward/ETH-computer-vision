function label = bow_recognition_bayes( histogram, vBoWPos, vBoWNeg)

[muPos sigmaPos] = computeMeanStd(vBoWPos);
[muNeg sigmaNeg] = computeMeanStd(vBoWNeg);

% Calculating the probability of appearance each word in observed histogram
% according to normal distribution in each of the positive and negative bag of words

% Testing parts i-ii-iii:
% Compute joint likelihoods P(hist|car) and P(hist|!car)
N = size(vBoWPos,2);
prob_hist_car = 0;
prob_hist_nocar = 0;

for i=1:N
    if (sigmaPos(i) < 0.5)
        sigmaPos(i) = 0.5;
    end
    pPos = log(normpdf(histogram(i),muPos(i),sigmaPos(i)));
    if ~isnan(pPos)
        prob_hist_car = prob_hist_car + pPos;
    end
    
    if (sigmaNeg(i) < 0.5)
        sigmaNeg(i) = 0.5;
    end
    pNeg = log(normpdf(histogram(i),muNeg(i),sigmaNeg(i)));
    if ~isnan(pNeg)
        prob_hist_nocar = prob_hist_nocar + pNeg;
    end
      
end
prob_hist_car = exp(prob_hist_car);
prob_hist_nocar = exp(prob_hist_nocar);

% Testing part iv:
% Evaluate posterior probabilities P(car|hist) and P(!car|hist)
prob_car = 0.5; 
prob_nocar = 0.5;
prob_car_hist = prob_car*prob_hist_car;
prob_nocar_hist = prob_nocar*prob_hist_nocar;

% Testing part v:
% Make decision on presence or absence of car
if prob_car_hist > prob_nocar_hist
    label = 1;
else
    label = 0;
end

end