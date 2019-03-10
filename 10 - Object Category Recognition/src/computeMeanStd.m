function [mu sigma] = computeMeanStd(vBoW)
    mu = mean(vBoW);
    sigma = std(vBoW); 
%     if sigma < 0.5
%         sigma = 0.5;
%     end
end