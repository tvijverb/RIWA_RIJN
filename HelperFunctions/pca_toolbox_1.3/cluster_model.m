function [model] = cluster_model(X,distance,scal,linkage_type)

% cluster_model calculates hierarchical clustering on a data matrix 
%
% [model] = cluster_model(X,distance,scal,linkage_type)
%
% INPUT
% X:           data matrix [samples x variables]
% distance:    distance to be used
%              'euclidean': Euclidean distance
%              'cityblock': City Block distance
%              'mahalanobis': Mahalanobis distance
%              'minkowski': Minkowski distance with exponent 2
%              'jaccard': Jaccard-Tanimoto distance for binary data
% scal:        scaling method:
%              'none': no scaling
%              'cent': mean centering
%              'auto': autoscaling (mean centering and unit variance)
%              'rang': range scaling between 0 and 1
% linkage_type:'single': nearest distance
%              'complete': furthest distance
%              'average': average distance
%              'centroid': center of mass distance
%
% OUTPUT
% model structure with fields:
% L            linkage results as reported in the matlab linkage function
% D            diatnce matrix [samples x samples]
% set          structure array with settings
%
% PCA toolbox for MATLAB
% version 1.3 - May 2017
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% http://michem.disat.unimib.it/chm/

[X_in,param] = data_pretreatment(X,scal);
if license('test','statistics_toolbox')
    D = pdist(X_in,distance);
    L = linkage(D,linkage_type);
    D = squareform(D);
else
    D = NaN;
    L = NaN;
end
% save results
model.L = L;
model.D = D;
model.set.distance = distance;
model.set.linkage_type = linkage_type;
model.set.param = param;
