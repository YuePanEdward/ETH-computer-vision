function histo = bow_histogram(vFeatures, vCenters)
  % input:
  %   vFeatures: MxD matrix containing M feature vectors of dim. D
  %   vCenters : NxD matrix containing N cluster centers of dim. D
  % output:
  %   histo    : N-dim. vector containing the resulting BoW
  %              activation histogram.
  N = size(vCenters,1);
  histo = zeros(1,N);
  
  for i=1:size(vFeatures,1)
      [~,match] = min(sum((vCenters-repmat(vFeatures(i,:),[N,1])).^2,2));
      histo(match) = histo(match) + 1;
  end
  % Match all features to the codebook and record the activated
  % codebook entries in the activation histogram "histo".
 
end
