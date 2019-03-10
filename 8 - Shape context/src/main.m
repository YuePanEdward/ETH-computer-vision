clc
clear all
close all

knn = 9;

classificationAccuracy = zeros(knn,1);
for k=1:knn
   classificationAccuracy(k) = shape_classification(k);
end
figure(knn+1);
plot(1:knn,classificationAccuracy);
