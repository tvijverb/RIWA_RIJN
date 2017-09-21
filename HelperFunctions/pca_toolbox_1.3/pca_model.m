function [model] = pca_model(X,num_comp,scal)

% pca_model calculates Principal Components Analysis (PCA) on a data matrix
%
% [model] = pca_model(X,num_comp,scal);
%
% INPUT:
% X            data matrix [samples x variables]
% num_comp     number of significant principal components
% scal:        scaling method:
%              'none': no scaling
%              'cent': mean centering
%              'auto': autoscaling (mean centering and unit variance)
%              'rang': range scaling between 0 and 1
%
% OUTPUT:
% model structure with fields:
% exp_var    explained variance [num_comp x 1]
% cum_var    cumulative explained variance [num_comp x 1]
% T          score matrix [n x num_comp]
% L          loading matrix [p x num_comp]
% E          eigenvalues [num_comp x 1]
% Thot       T2 Hotelling [1 x samples]
% Tcont      T2 Hotelling contributions [samples x variables]
% Qres       Q residuals [1 x samples]
% Qcont      Q contributions [sampels x variables]
% set        structure array with settings
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
ran = min(size(X,1),size(X,2));
if num_comp > ran
    num_comp = ran;
end

[X_in,param] = data_pretreatment(X,scal);

[Tmat,E,L] = svd(X_in,0);     % diagonalisation
eigmat = E;
Efull = diag(E).^2/(n-1);      % eigenvalues
exp_var = Efull/sum(Efull);
E = Efull(1:num_comp);
exp_var = exp_var(1:num_comp);
for k=1:num_comp; cum_var(k) = sum(exp_var(1:k)); end;

L = L(:,1:num_comp);       % loadings and scores
T = X_in*L;

% T2 hotelling
I = zeros(size(T,2),size(T,2)); mL = I;
for i=1:size(T,2)
    I(i,i) = E(i);
    mL(i,i) = 1/sqrt(E(i));
end
mL = mL*L';
for i=1:size(T,1)
    Thot(i) = T(i,:)*inv(I)*T(i,:)';
    Tcont(i,:) = T(i,:)*mL;
end

% Q residuals
Xmod = T*L';
Err = X_in - Xmod;
for i=1:size(T,1)
    Qres(i) = Err(i,:)*Err(i,:)';
end

% T2 and Q limits
[tlim,qlim] = calc_qt_limits(Efull,num_comp,size(X,1));

% save results
model.exp_var = exp_var;
model.cum_var = cum_var';
model.E = E;
model.L = L;
model.T = T;
model.eigmat = eigmat;
model.Tmat = Tmat;
model.Qres = Qres;
model.Qcont = Err;
model.Thot = Thot;
model.Tcont = Tcont;
model.set.tlim = tlim;
model.set.qlim = qlim;
model.set.num_comp = num_comp;
model.set.param = param;
model.set.ran = ran;