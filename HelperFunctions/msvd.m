function [X] = msvd( X,fn,conv,maxiter )
%MSVD Summary of this function goes here
%   Detailed explanation goes here
[m,n]=size(X);
if nargin < 4
    
    conv = 1e-10;
    maxiter = 1000;
end
center = 1;

Mindex = find(isnan(X));
if length(Mindex) == 0
    if center == 1
        Xc = X - ones(m,1) * mean(X);
    else
        Xc = X;
    end
    [S,V,D] = svd(Xc);
    S = S*V;
    S = S(:,1:fn);
    D = D(:,1:fn);
    Xpredicted = S * D' + ones(m,1) * mean(X);
else
    X = inimiss(X);
    mx = mean(X);
    SS = sum(sum(X(Mindex).^2));
    f = 2 * conv;
    iter = 1;
    while (iter < maxiter && f > conv)
        SSold = SS;
        if center == 1
            mx = mean(X);
            Xc = X - ones(m,1) * mx;
        end
        [S,V,D] = svd(Xc,0);
         S = S*V;
         S = S(:,1:fn);
         D = D(:,1:fn);
         Xpredicted = S * D';
         if center == 1
             Xpredicted = Xpredicted + ones(m,1) * mx;
         end
         X(Mindex) = Xpredicted(Mindex);
         SS = sum(sum(X(Mindex).^2));
         f = abs(SS - SSold) / SSold;
         iter = iter + 1;
    end
end
end

