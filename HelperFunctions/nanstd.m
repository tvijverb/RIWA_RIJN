function [ Xstdx,Xstdf,Xkeepo ] = nanstd(X,rm_low_std)
%NANMEAN2 Summary of this function goes here
%   Detailed explanation goes here
rm_low_std = logical(rm_low_std);

[rows,columns]=size(X);
Xnan = ~isnan(X);
Xstd = zeros(columns,1);
Xstdx = X;
Xkeepo = zeros(columns,1);
for i = 1 : columns
    Xstd(i) = std(X(Xnan(:,i),i));
    if(Xstd(i) > 0.0001 && rm_low_std)
        Xstdx(~isnan(X(:,i)),i) = X(Xnan(:,i),i) / Xstd(i);
        Xkeepo(i) = 1;
    %elseif (Xstd(i) <= 0.05 && rm_low_std)
    %    Xstdx(~isnan(X(:,i)),i) = NaN;
    else
        %Xstdx(~isnan(X(:,i)),i) = X(Xnan(:,i),i) / Xstd(i);
        %Xkeepo(i) = 1;
    end
end
Xkeepo = logical(Xkeepo);
Xstdx(:,~Xkeepo) = [];
Xstdf = Xstd(Xkeepo);
end