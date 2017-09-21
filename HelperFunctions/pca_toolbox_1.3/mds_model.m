function [model] = mds_model(X,distance,scal)

% mds_model calculates Multidimensional Scaling (MDS) omn a data matrix
%
% [model] = mds_model(X,distance,scal)
%
% INPUT
% X:           data matrix [samples x variables]
% distance:    distance to be used
%              'euclidean'   - Euclidean distance
%              'cityblock'   - City Block distance
%              'mahalanobis' - Mahalanobis distance
%              'minkowski'   - Minkowski distance with exponent 2
%              'jaccard'     - Jaccard-Tanimoto distance for binary data
% scal:        scaling method:
%              'none': no scaling
%              'cent': mean centering
%              'auto': autoscaling (mean centering and unit variance)
%              'rang': range scaling between 0 and 1
%
% OUTPUT
% model structure with fields:
% T            configuration matrix [samples x coordinates]
% E            eigenvalues of T*T'
% D            distance matrix [samples x samples]
% set          structure array with settings
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% PCA toolbox for MATLAB
% version 1.3 - May 2017
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% http://michem.disat.unimib.it/chm/

[n,p] = size(X);
max_dimension = 10;
[X_in,param] = data_pretreatment(X,scal);

if license('test','statistics_toolbox')
    D = pdist(X_in,distance);
    D = squareform(D);
    [T,E] = cmdscale(D);
    p = min([n p]);
    % save results
    if size(T,2) > max_dimension
        T = T(:,1:max_dimension);
    end
else
    D = NaN;
    T = NaN;
    E = NaN;
end
model.T = T;
model.E = E(1:size(T,2));
model.D = D;
model.set.distance = distance;
model.set.param = param;


