%
% BAG OF WORDS RECOGNITION EXERCISE
%
%sizeCodebook = [25,50,75,100,125,150,175,200,225,250,275,300];
sizeCodebook = 200;
idx = 1;
iter = 10;
percentageNN = zeros(length(sizeCodebook),iter);
percentageB = zeros(length(sizeCodebook),iter);
meanNN = zeros(length(sizeCodebook),1);
meanB = zeros(length(sizeCodebook),1);
for k = sizeCodebook
    for m=1:iter
        %training
        disp('creating codebook');
        %sizeCodebook = 200;
        numIterations = 10;
        figure(1);
        vCenters = create_codebook('../data/cars-training-pos',k,numIterations);
        %keyboard;
        disp('processing positve training images');
        vBoWPos = create_bow_histograms('../data/cars-training-pos',vCenters);
        disp('processing negative training images');
        vBoWNeg = create_bow_histograms('../data/cars-training-neg',vCenters);
        %vBoWPos_test = vBoWPos;
        %vBoWNeg_test = vBoWNeg;
        %keyboard;
        disp('processing positive testing images');
        vBoWPos_test = create_bow_histograms('../data/cars-testing-pos',vCenters);
        disp('processing negative testing images');
        vBoWNeg_test = create_bow_histograms('../data/cars-testing-neg',vCenters);

        nrPos = size(vBoWPos_test,1);
        nrNeg = size(vBoWNeg_test,1);

        test_histograms = [vBoWPos_test;vBoWNeg_test];
        labels = [ones(nrPos,1);zeros(nrNeg,1)];

        disp('______________________________________')
        disp('Nearest Neighbor classifier')
        percentageNN(idx,iter) = bow_recognition_multi(test_histograms, labels,...
                                                        vBoWPos,vBoWNeg,...
                                                        @bow_recognition_nearest);
        disp('______________________________________')
        disp('Bayesian classifier')
        percentageB(idx,iter) = bow_recognition_multi(test_histograms, labels,...
                                                      vBoWPos, vBoWNeg,...
                                                      @bow_recognition_bayes);
        disp('______________________________________')
        
        figure(2);
        plot(k,percentageNN(idx,iter),'bx'); hold on;
        plot(k,percentageB(idx,iter),'rx'); hold on;
        meanNN(idx) = meanNN(idx) + percentageNN(idx,iter);
        meanB(idx) = meanB(idx) + percentageB(idx,iter);
    end
    meanNN(idx) = meanNN(idx)/iter;
    meanB(idx) = meanB(idx)/iter;
    idx = idx + 1;
end

figure(2);
plot(sizeCodebook,meanNN,'b','linewidth',1); grid on; hold on;
plot(sizeCodebook,meanB,'r','linewidth',1);
xlabel('Codebook size k');
ylabel('Accuracy [%]')
legend('Accuracy for Nearest Neighbor Classification',...
       'Accuracy for Bayes Classification');
title('Variation of accuracy with codebook size')
