function [ Xmcx,Xmc ] = nanmean2( X )
%NANMEAN2 Summary of this function goes here
%   Detailed explanation goes here

[rows,columns]=size(X);
Xnan = ~isnan(X);
Xmc = zeros(columns,1);
Xmcx = X;

for i = 1 : columns
    Xmc(i) = mean(X(Xnan(:,i),i));
    Xmcx(~isnan(X(:,i)),i) = X(Xnan(:,i),i) - Xmc(i);
end
end

