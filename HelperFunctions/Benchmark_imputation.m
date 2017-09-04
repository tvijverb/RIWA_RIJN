function [ knn,pca,oplsda ] = Benchmark_imputation( )
%% Created by Thomas Vijverberg on 19-04-2016 at Radboud University Nijmegen
% Last edited by Thomas Vijverberg on 19-04-2016

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%INPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input data structure (STRUCT) 'S' with dimension 1 x (total_measurements)
%Must contain atleast contain:
%Data input (S.Data)
%IDs input (S.ID)
%Labels S.Labels

%Point of measurement 'place'
% 1:Rhine,Andijk
% 2:Meuse, Eijsden
% 3:Meuse, Heel
% 4:Meuse, Keizersveer
% 5:Rhine, Lobith

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Run 500 times
for zz  = 1 : 100
    %% Generate simulation data
    [ X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11,Y1,Y2,Y3,Y4,Y5,Y6,Y7,Y8,Y9,Y10,Y11 ] = Generate_simulation_data();
    X1 = mncn(X1);
    X2 = mncn(X2);
    X3 = mncn(X3);
    X4 = mncn(X4);
    X5 = mncn(X5);
    X6 = mncn(X6);
    X7 = mncn(X7);
    X8 = mncn(X8);
    X9 = mncn(X9);
    X10 = mncn(X10);
    X11 = mncn(X11);
    Y1 = mncn(Y1');
    Y2 = mncn(Y2');
    Y3 = mncn(Y3');
    Y4 = mncn(Y4');
    Y5 = mncn(Y5');
    Y6 = mncn(Y6');
    Y7 = mncn(Y7');
    Y8 = mncn(Y8');
    Y9 = mncn(Y9');
    Y10 = mncn(Y10');
    Y11 = mncn(Y11');
    
    Y = [Y1 Y2 Y3 Y4 Y5 Y6 Y7 Y8 Y9 Y10 Y11];
    X = [X1 X2 X3 X4 X5 X6 X7 X8 X9 X10 X11];
    Ystd = std(Y);
    %% Remove 15 random indices
    removed_index = randi([1 60],15,1);
    removed_Y1 = Y1(removed_index);
    removed_Y2 = Y2(removed_index);
    removed_Y3 = Y3(removed_index);
    removed_Y4 = Y4(removed_index);
    removed_Y5 = Y5(removed_index);
    removed_Y6 = Y6(removed_index);
    removed_Y7 = Y7(removed_index);
    removed_Y8 = Y8(removed_index);
    removed_Y9 = Y9(removed_index);
    removed_Y10 = Y10(removed_index);
    removed_Y11 = Y11(removed_index);
    
    Ymiss = [removed_Y1 removed_Y2 removed_Y3 removed_Y4 removed_Y5 removed_Y6 removed_Y7 removed_Y8 removed_Y9 removed_Y10 removed_Y11];
    
    Y1(removed_index) = NaN;
    Y2(removed_index) = NaN;
    Y3(removed_index) = NaN;
    Y4(removed_index) = NaN;
    Y5(removed_index) = NaN;
    Y6(removed_index) = NaN;
    Y7(removed_index) = NaN;
    Y8(removed_index) = NaN;
    Y9(removed_index) = NaN;
    Y10(removed_index) = NaN;
    Y11(removed_index) = NaN;
    
    %% k-NN imputation
    disp('Start of k-NN imputation algorithm');
    tic
    
    
    k = 10;
    kk = 4;
    kkk = 2;
    
    Xknn1 = [X1 Y1];
    Xknn2 = [X2 Y2];
    Xknn3 = [X3 Y3];
    Xknn4 = [X4 Y4];
    Xknn5 = [X5 Y5];
    Xknn6 = [X6 Y6];
    Xknn7 = [X7 Y7];
    Xknn8 = [X8 Y8];
    Xknn9 = [X9 Y9];
    Xknn10 = [X10 Y10];
    Xknn11 = [X11 Y11];
    
    [Xknn1] = knnW3timeLag( Xknn1,k,kk,kkk);
    [Xknn2] = knnW3timeLag( Xknn2,k,kk,kkk);
    [Xknn3] = knnW3timeLag( Xknn3,k,kk,kkk);
    [Xknn4] = knnW3timeLag( Xknn4,k,kk,kkk);
    [Xknn5] = knnW3timeLag( Xknn5,k,kk,kkk);
    [Xknn6] = knnW3timeLag( Xknn6,k,kk,kkk);
    [Xknn7] = knnW3timeLag( Xknn7,k,kk,kkk);
    [Xknn8] = knnW3timeLag( Xknn8,k,kk,kkk);
    [Xknn9] = knnW3timeLag( Xknn9,k,kk,kkk);
    [Xknn10] = knnW3timeLag( Xknn10,k,kk,kkk);
    [Xknn11] = knnW3timeLag( Xknn11,k,kk,kkk);
    
    Yknn1 = Xknn1(removed_index,11);
    Yknn2 = Xknn2(removed_index,11);
    Yknn3 = Xknn3(removed_index,11);
    Yknn4 = Xknn4(removed_index,11);
    Yknn5 = Xknn5(removed_index,11);
    Yknn6 = Xknn6(removed_index,11);
    Yknn7 = Xknn7(removed_index,11);
    Yknn8 = Xknn8(removed_index,11);
    Yknn9 = Xknn9(removed_index,11);
    Yknn10 = Xknn10(removed_index,11);
    Yknn11 = Xknn11(removed_index,11);
    
    Yknn = [Yknn1 Yknn2 Yknn3 Yknn4 Yknn5 Yknn6 Yknn7 Yknn8 Yknn9 Yknn10 Yknn11];
    
    Yknndiff = ( Ymiss - Yknn ) ./ repmat(Ystd,15,1);
    Yknndiff = reshape(Yknndiff,1,[]);
    knn(zz,:) = [mean(Yknndiff) std(Yknndiff)];
    toc
    
    %% PCA-IA imputation
    disp('Start of PCA-IA imputation algorithm');
    tic
    
    for i = 1 :4
        Xpca1 = [X1 Y1];
        Xpca2 = [X2 Y2];
        Xpca3 = [X3 Y3];
        Xpca4 = [X4 Y4];
        Xpca5 = [X5 Y5];
        Xpca6 = [X6 Y6];
        Xpca7 = [X7 Y7];
        Xpca8 = [X8 Y8];
        Xpca9 = [X9 Y9];
        Xpca10 = [X10 Y10];
        Xpca11 = [X11 Y11];
        
        Xpca1 = msvd(Xpca1,i);
        Xpca2 = msvd(Xpca2,i);
        Xpca3 = msvd(Xpca3,i);
        Xpca4 = msvd(Xpca4,i);
        Xpca5 = msvd(Xpca5,i);
        Xpca6 = msvd(Xpca6,i);
        Xpca7 = msvd(Xpca7,i);
        Xpca8 = msvd(Xpca8,i);
        Xpca9 = msvd(Xpca9,i);
        Xpca10 = msvd(Xpca10,i);
        Xpca11 = msvd(Xpca11,i);
        
        Ypca1 = Xpca1(removed_index,11);
        Ypca2 = Xpca2(removed_index,11);
        Ypca3 = Xpca3(removed_index,11);
        Ypca4 = Xpca4(removed_index,11);
        Ypca5 = Xpca5(removed_index,11);
        Ypca6 = Xpca6(removed_index,11);
        Ypca7 = Xpca7(removed_index,11);
        Ypca8 = Xpca8(removed_index,11);
        Ypca9 = Xpca9(removed_index,11);
        Ypca10 = Xpca10(removed_index,11);
        Ypca11 = Xpca11(removed_index,11);
        
        Ypca = [Ypca1 Ypca2 Ypca3 Ypca4 Ypca5 Ypca6 Ypca7 Ypca8 Ypca9 Ypca10 Ypca11];
        
        Ypcadiff = ( Ymiss - Ypca ) ./ repmat(Ystd,15,1);
        Ypcadiff = reshape(Ypcadiff,1,[]);
        pca(zz,i,:) = [mean(Ypcadiff) std(Ypcadiff)];
    end
    
    toc
    
    %% OPLS-DA imputation
    disp('Start of OPLS-DA imputation algorithm');
    tic
    
    [b_acc,n_LV,w,yhat,q,P_o,W_o,i_fold]=DAMACY_top(X1(~ismember(1:60,removed_index),:),1:(60-length(unique(removed_index))),Y1(~ismember(1:60,removed_index)),5,1);
    [~,~,y_hat] = OPLSpred(X1(ismember(1:60,removed_index),:),P_o,W_o,w,q,i_fold);
    Yoplsda1 = [];
    a = 1:60;
    aa = a(ismember(1:60,removed_index));
    for i = 1 :length(aa)
        Yoplsda1(find(removed_index == aa(i))) = y_hat(i);
    end
    
    [b_acc,n_LV,w,yhat,q,P_o,W_o,i_fold]=DAMACY_top(X2(~ismember(1:60,removed_index),:),1:(60-length(unique(removed_index))),Y2(~ismember(1:60,removed_index)),5,1);
    [~,~,y_hat] = OPLSpred(X2(ismember(1:60,removed_index),:),P_o,W_o,w,q,i_fold);
    Yoplsda2 = [];
    a = 1:60;
    aa = a(ismember(1:60,removed_index));
    for i = 1 :length(aa)
        Yoplsda2(find(removed_index == aa(i))) = y_hat(i);
    end
    
    [b_acc,n_LV,w,yhat,q,P_o,W_o,i_fold]=DAMACY_top(X3(~ismember(1:60,removed_index),:),1:(60-length(unique(removed_index))),Y3(~ismember(1:60,removed_index)),5,1);
    [~,~,y_hat] = OPLSpred(X3(ismember(1:60,removed_index),:),P_o,W_o,w,q,i_fold);
    Yoplsda3 = [];
    a = 1:60;
    aa = a(ismember(1:60,removed_index));
    for i = 1 :length(aa)
        Yoplsda3(find(removed_index == aa(i))) = y_hat(i);
    end
    
    [b_acc,n_LV,w,yhat,q,P_o,W_o,i_fold]=DAMACY_top(X4(~ismember(1:60,removed_index),:),1:(60-length(unique(removed_index))),Y4(~ismember(1:60,removed_index)),5,1);
    [~,~,y_hat] = OPLSpred(X4(ismember(1:60,removed_index),:),P_o,W_o,w,q,i_fold);
    Yoplsda4 = [];
    a = 1:60;
    aa = a(ismember(1:60,removed_index));
    for i = 1 :length(aa)
        Yoplsda4(find(removed_index == aa(i))) = y_hat(i);
    end
    
    [b_acc,n_LV,w,yhat,q,P_o,W_o,i_fold]=DAMACY_top(X5(~ismember(1:60,removed_index),:),1:(60-length(unique(removed_index))),Y5(~ismember(1:60,removed_index)),5,1);
    [~,~,y_hat] = OPLSpred(X5(ismember(1:60,removed_index),:),P_o,W_o,w,q,i_fold);
    Yoplsda5 = [];
    a = 1:60;
    aa = a(ismember(1:60,removed_index));
    for i = 1 :length(aa)
        Yoplsda5(find(removed_index == aa(i))) = y_hat(i);
    end
    
    [b_acc,n_LV,w,yhat,q,P_o,W_o,i_fold]=DAMACY_top(X6(~ismember(1:60,removed_index),:),1:(60-length(unique(removed_index))),Y6(~ismember(1:60,removed_index)),5,1);
    [~,~,y_hat] = OPLSpred(X6(ismember(1:60,removed_index),:),P_o,W_o,w,q,i_fold);
    Yoplsda6 = [];
    a = 1:60;
    aa = a(ismember(1:60,removed_index));
    for i = 1 :length(aa)
        Yoplsda6(find(removed_index == aa(i))) = y_hat(i);
    end
    
    [b_acc,n_LV,w,yhat,q,P_o,W_o,i_fold]=DAMACY_top(X7(~ismember(1:60,removed_index),:),1:(60-length(unique(removed_index))),Y7(~ismember(1:60,removed_index)),5,1);
    [~,~,y_hat] = OPLSpred(X7(ismember(1:60,removed_index),:),P_o,W_o,w,q,i_fold);
    Yoplsda7 = [];
    a = 1:60;
    aa = a(ismember(1:60,removed_index));
    for i = 1 :length(aa)
        Yoplsda7(find(removed_index == aa(i))) = y_hat(i);
    end
    
    [b_acc,n_LV,w,yhat,q,P_o,W_o,i_fold]=DAMACY_top(X8(~ismember(1:60,removed_index),:),1:(60-length(unique(removed_index))),Y8(~ismember(1:60,removed_index)),5,1);
    [~,~,y_hat] = OPLSpred(X8(ismember(1:60,removed_index),:),P_o,W_o,w,q,i_fold);
    Yoplsda8 = [];
    a = 1:60;
    aa = a(ismember(1:60,removed_index));
    for i = 1 :length(aa)
        Yoplsda8(find(removed_index == aa(i))) = y_hat(i);
    end
    
    [b_acc,n_LV,w,yhat,q,P_o,W_o,i_fold]=DAMACY_top(X9(~ismember(1:60,removed_index),:),1:(60-length(unique(removed_index))),Y9(~ismember(1:60,removed_index)),5,1);
    [~,~,y_hat] = OPLSpred(X9(ismember(1:60,removed_index),:),P_o,W_o,w,q,i_fold);
    Yoplsda9 = [];
    a = 1:60;
    aa = a(ismember(1:60,removed_index));
    for i = 1 :length(aa)
        Yoplsda9(find(removed_index == aa(i))) = y_hat(i);
    end
    
    [b_acc,n_LV,w,yhat,q,P_o,W_o,i_fold]=DAMACY_top(X10(~ismember(1:60,removed_index),:),1:(60-length(unique(removed_index))),Y10(~ismember(1:60,removed_index)),5,1);
    [~,~,y_hat] = OPLSpred(X10(ismember(1:60,removed_index),:),P_o,W_o,w,q,i_fold);
    Yoplsda10 = [];
    a = 1:60;
    aa = a(ismember(1:60,removed_index));
    for i = 1 :length(aa)
        Yoplsda10(find(removed_index == aa(i))) = y_hat(i);
    end
    
    [b_acc,n_LV,w,yhat,q,P_o,W_o,i_fold]=DAMACY_top(X11(~ismember(1:60,removed_index),:),1:(60-length(unique(removed_index))),Y11(~ismember(1:60,removed_index)),5,1);
    [~,~,y_hat] = OPLSpred(X11(ismember(1:60,removed_index),:),P_o,W_o,w,q,i_fold);
    Yoplsda11 = [];
    a = 1:60;
    aa = a(ismember(1:60,removed_index));
    for i = 1 :length(aa)
        Yoplsda11(find(removed_index == aa(i))) = y_hat(i);
    end
    
    Yoplsda = [Yoplsda1' Yoplsda2' Yoplsda3' Yoplsda4' Yoplsda5' Yoplsda6' Yoplsda7' Yoplsda8' Yoplsda9' Yoplsda10' Yoplsda11'];
    
    Yoplsdadiff = ( Ymiss - Yoplsda ) ./ repmat(Ystd,15,1);
    Yoplsdadiff = reshape(Yoplsdadiff,1,[]);
    oplsda(zz,:) = [mean(Yoplsdadiff) std(Yoplsdadiff)];
    
    % figure
    % plot(mncn(Y11));
    % hold on
    % plot(yhat);
    toc
end
figure
aboxplot([knn(:,2) oplsda(:,2) squeeze(pca(:,1,2)) squeeze(pca(:,2,2)) squeeze(pca(:,3,2)) squeeze(pca(:,4,2))],'labels',{'k-NN','OPLS-DA','PCA 1PC','PCA 2PCs','PCA 3PCs'});
title('Standard Deviation simulated imputation 100 repetitions','Fontsize',24);
ylabel('?','Fontsize',24);

end

