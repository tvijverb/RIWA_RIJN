function [ S_HighDensity ] = data_selfpredict_imputation( S_HighDensity )
%% Created by Thomas Vijverberg on 29-09-2017 at Radboud University Nijmegen
% Last edited by Thomas Vijverberg on 29-09-2017

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%OUTPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Runs self prediction imputation algorithm. How good is the prediction on
% the known data?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% loop over all S

disp('Running Self-prediction')

for i = 1 : length(S_HighDensity)
    [r,c] = size(S_HighDensity(i).Xstdx);
    isnanmat = isnan(S_HighDensity(i).Xstdx);
    ismat = ~isnanmat;
    S_HighDensity(i).predictvalue = zeros(fliplr(size(S_HighDensity(i).Xstdx)));
    for j = 1 : c
        sum_have_column = sum(ismat(:,j));
        row = 1:r;
        rowIdx = ismat(:,j);
        thisrow= row(rowIdx);
        for k = 1 : sum_have_column
            kk = thisrow(k);
            predictmatrix = S_HighDensity(i).Xstdx;
            predictmatrix(j,kk) = NaN;
            predictmatrix = msvd(predictmatrix,3);
            S_HighDensity(i).predictvalue(j,kk) = predictmatrix(j,kk);
        end
        yimp = S_HighDensity(i).predictvalue(j,thisrow);
        yreal = S_HighDensity(i).Xstdx(rowIdx,j);
        S_HighDensity(i).MSE(j) = mean((yimp-yreal').^2);
        disp(['Now at column: ',num2str(j),' of self-prediction']);
    end
end




end
