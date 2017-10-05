function [] = plot_benchmark_imputation( mknn, oplsda, pca )
%% Created by Thomas Vijverberg on 05-10-2017 at Radboud University Nijmegen
% Last edited by Thomas Vijverberg on 05-10-2017

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%INPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% knn       k-Nearest Neighbours imputation result
% oplsda    OPLS-DA imputation result
% pca       PCA-IA imputation result

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% start of the script
figure(1);

hold on;
for i = 1 : length(mknn(:,1,1))
    plot(mean(mknn(i,:,3)));
    disp(num2str(mean(mknn(i,:,1))));
end


end

