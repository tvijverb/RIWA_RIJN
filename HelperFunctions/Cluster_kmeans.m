function [ C_means, L ] = Cluster_kmeans( X, k )
%CLUSTER_KMEANS Summary of this function goes here
%   Detailed explanation goes here
[rows,columns]=size(X);
%rand = [1 1 1; 2 2 2];

%% Generate initial cluster centers semi-random around mean with stdv 
Xnan = ~isnan(X);
means = zeros(columns,1);
stdvs = means;
for i = 1 : columns
    means(i) = mean(X(Xnan(:,i),i));
    stdvs(i) = (std(X(Xnan(:,i),i))*2);
    inv_stdvs(i) = stdvs(i)^-1;
    if stdvs(i) == 0
        inv_stdvs(i) = 0;
    end
end
stdvs = diag(stdvs);
inv_stdvs = diag(inv_stdvs);
means = repmat(means,[1 k]);

C_means = (rand(k,columns)-repmat(0.5,[k columns])) * stdvs + means';

prev_C_means = zeros(size(C_means));

while C_means ~= prev_C_means
    prev_C_means = C_means;
    for j=1:rows
        for a=1:k
            m(a,:)= (X(j,:)- C_means(a,:)).^2;
        end
        m(isnan(m)) = 0;
        l = m*diag(inv_stdvs);
        [r,~]=find(l==min(min(l)));
        L(j)=r(1);
    end
    for j=1:k
        x=find(L==j);
        X1=nanmean2(X(x,:));
        C_means(j,:)=X1;
    end
end

end
 

