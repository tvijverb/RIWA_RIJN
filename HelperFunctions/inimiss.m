function [ X ] = inimiss( X )
%INIMISS Summary of this function goes here
%   Detailed explanation goes here
[m,n] = size(X);
mis = isnan(X);
ii = find(isnan(X));
[i,j] = find(isnan(X));
X(ii) = 0;
meanc = sum(X) ./ (ones(1,n) * m - sum(mis));
meanr = sum(X') ./ (ones(1,m) * n - sum(mis'));
for k = 1:length(i)
    X(i(k),j(k)) = (meanr(i(k)) + meanc(j(k))) / 2;
end
end

