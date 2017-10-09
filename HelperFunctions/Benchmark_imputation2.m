function [ knn,pca,oplsda ] = Benchmark_imputation2( )
%% Created by Thomas Vijverberg on 05-10-2017 at Radboud University Nijmegen
% Last edited by Thomas Vijverberg on 05-10-2017

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%INPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

remove_num_mat = [5 10 15 20 30 40 50 60 70 80 90];
data_length = 1000;
repeat_n_times = 100;

%% Run 500 times
for miss = 1 : length(remove_num_mat)
    remove_num = remove_num_mat(miss);
    for zz  = 1 : repeat_n_times
        %% Generate simulation data
        disp(['Now at miss: ', num2str(miss), ' of ', num2str(length(remove_num_mat)), ' and repetition ', num2str(zz), ' of ', num2str(repeat_n_times)]);
        [ X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6 ] = Generate_simulation_data2(data_length);
        X1 = mncn(X1);
        X2 = mncn(X2);
        X3 = mncn(X3);
        X4 = mncn(X4);
        X5 = mncn(X5);
        X6 = mncn(X6);
        Y1 = mncn(Y1');
        Y2 = mncn(Y2');
        Y3 = mncn(Y3');
        Y4 = mncn(Y4');
        Y5 = mncn(Y5');
        Y6 = mncn(Y6');

        Y = [Y1 Y2 Y3 Y4 Y5 Y6];
        X = [X1 X2 X3 X4 X5 X6];
        Ystd = std(Y);
        %% Remove 15 random indices
        removed_index = randi([1 data_length],remove_num,1);
        removed_Y1 = Y1(removed_index);
        removed_Y2 = Y2(removed_index);
        removed_Y3 = Y3(removed_index);
        removed_Y4 = Y4(removed_index);
        removed_Y5 = Y5(removed_index);
        removed_Y6 = Y6(removed_index);
        
        Ymiss = [removed_Y1 removed_Y2 removed_Y3 removed_Y4 removed_Y5 removed_Y6];

        Y1(removed_index) = NaN;
        Y2(removed_index) = NaN;
        Y3(removed_index) = NaN;
        Y4(removed_index) = NaN;
        Y5(removed_index) = NaN;
        Y6(removed_index) = NaN;
       
        %% k-NN imputation
        k = 10;
        kk = 10;
        kkk = 4;

        Xknn1 = [X1 Y1];
        Xknn2 = [X2 Y2];
        Xknn3 = [X3 Y3];
        Xknn4 = [X4 Y4];
        Xknn5 = [X5 Y5];
        Xknn6 = [X6 Y6];
        

        [Xknn1] = knnW3timeLag( Xknn1,k,kk,kkk);
        [Xknn2] = knnW3timeLag( Xknn2,k,kk,kkk);
        [Xknn3] = knnW3timeLag( Xknn3,k,kk,kkk);
        [Xknn4] = knnW3timeLag( Xknn4,k,kk,kkk);
        [Xknn5] = knnW3timeLag( Xknn5,k,kk,kkk);
        [Xknn6] = knnW3timeLag( Xknn6,k,kk,kkk);
        
        Yknn1 = Xknn1(removed_index,11);
        Yknn2 = Xknn2(removed_index,11);
        Yknn3 = Xknn3(removed_index,11);
        Yknn4 = Xknn4(removed_index,11);
        Yknn5 = Xknn5(removed_index,11);
        Yknn6 = Xknn6(removed_index,11);
        

        Yknn = [Yknn1 Yknn2 Yknn3 Yknn4 Yknn5 Yknn6];

        Yknndiff = ( Ymiss - Yknn ) ./ repmat(Ystd,remove_num,1);
        Yknndiff = reshape(Yknndiff,1,[]);
        YknnMSE = sqrt(((Ymiss - Yknn).^2)) ./ repmat(Ystd,remove_num,1);


        knn(miss,zz,:) = [mean(Yknndiff) std(Yknndiff) mean(mean(YknnMSE))];
        %% PCA-IA imputation
        for i = 1 :4
            Xpca1 = [X1 Y1];
            Xpca2 = [X2 Y2];
            Xpca3 = [X3 Y3];
            Xpca4 = [X4 Y4];
            Xpca5 = [X5 Y5];
            Xpca6 = [X6 Y6];

            Xpca1 = msvd(Xpca1,i);
            Xpca2 = msvd(Xpca2,i);
            Xpca3 = msvd(Xpca3,i);
            Xpca4 = msvd(Xpca4,i);
            Xpca5 = msvd(Xpca5,i);
            Xpca6 = msvd(Xpca6,i);
            
            Ypca1 = Xpca1(removed_index,11);
            Ypca2 = Xpca2(removed_index,11);
            Ypca3 = Xpca3(removed_index,11);
            Ypca4 = Xpca4(removed_index,11);
            Ypca5 = Xpca5(removed_index,11);
            Ypca6 = Xpca6(removed_index,11);

            Ypca = [Ypca1 Ypca2 Ypca3 Ypca4 Ypca5 Ypca6];

            Ypcadiff = ( Ymiss - Ypca ) ./ repmat(Ystd,remove_num,1);
            YpcaMSE = sqrt(((Ymiss - Ypca).^2)) ./ repmat(Ystd,remove_num,1);

            Ypcadiff = reshape(Ypcadiff,1,[]);
            pca(miss,zz,i,:) = [mean(Ypcadiff) std(Ypcadiff) mean(mean(YpcaMSE))];
        end
        %% OPLS-DA imputation
        [b_acc,n_LV,w,yhat,q,P_o,W_o,i_fold]=DAMACY_top(X1(~ismember(1:data_length,removed_index),:),1:(data_length-length(unique(removed_index))),Y1(~ismember(1:data_length,removed_index)),5,1);
        [~,~,y_hat] = OPLSpred(X1(ismember(1:data_length,removed_index),:),P_o,W_o,w,q,i_fold);
        Yoplsda1 = [];
        a = 1:data_length;
        aa = a(ismember(1:data_length,removed_index));
        for i = 1 :length(aa)
            Yoplsda1(find(removed_index == aa(i))) = y_hat(i);
        end

        [b_acc,n_LV,w,yhat,q,P_o,W_o,i_fold]=DAMACY_top(X2(~ismember(1:data_length,removed_index),:),1:(data_length-length(unique(removed_index))),Y2(~ismember(1:data_length,removed_index)),5,1);
        [~,~,y_hat] = OPLSpred(X2(ismember(1:data_length,removed_index),:),P_o,W_o,w,q,i_fold);
        Yoplsda2 = [];
        a = 1:data_length;
        aa = a(ismember(1:data_length,removed_index));
        for i = 1 :length(aa)
            Yoplsda2(find(removed_index == aa(i))) = y_hat(i);
        end

        [b_acc,n_LV,w,yhat,q,P_o,W_o,i_fold]=DAMACY_top(X3(~ismember(1:data_length,removed_index),:),1:(data_length-length(unique(removed_index))),Y3(~ismember(1:data_length,removed_index)),5,1);
        [~,~,y_hat] = OPLSpred(X3(ismember(1:data_length,removed_index),:),P_o,W_o,w,q,i_fold);
        Yoplsda3 = [];
        a = 1:data_length;
        aa = a(ismember(1:data_length,removed_index));
        for i = 1 :length(aa)
            Yoplsda3(find(removed_index == aa(i))) = y_hat(i);
        end

        [b_acc,n_LV,w,yhat,q,P_o,W_o,i_fold]=DAMACY_top(X4(~ismember(1:data_length,removed_index),:),1:(data_length-length(unique(removed_index))),Y4(~ismember(1:data_length,removed_index)),5,1);
        [~,~,y_hat] = OPLSpred(X4(ismember(1:data_length,removed_index),:),P_o,W_o,w,q,i_fold);
        Yoplsda4 = [];
        a = 1:data_length;
        aa = a(ismember(1:data_length,removed_index));
        for i = 1 :length(aa)
            Yoplsda4(find(removed_index == aa(i))) = y_hat(i);
        end

        [b_acc,n_LV,w,yhat,q,P_o,W_o,i_fold]=DAMACY_top(X5(~ismember(1:data_length,removed_index),:),1:(data_length-length(unique(removed_index))),Y5(~ismember(1:data_length,removed_index)),5,1);
        [~,~,y_hat] = OPLSpred(X5(ismember(1:data_length,removed_index),:),P_o,W_o,w,q,i_fold);
        Yoplsda5 = [];
        a = 1:data_length;
        aa = a(ismember(1:data_length,removed_index));
        for i = 1 :length(aa)
            Yoplsda5(find(removed_index == aa(i))) = y_hat(i);
        end

        [b_acc,n_LV,w,yhat,q,P_o,W_o,i_fold]=DAMACY_top(X6(~ismember(1:data_length,removed_index),:),1:(data_length-length(unique(removed_index))),Y6(~ismember(1:data_length,removed_index)),5,1);
        [~,~,y_hat] = OPLSpred(X6(ismember(1:data_length,removed_index),:),P_o,W_o,w,q,i_fold);
        Yoplsda6 = [];
        a = 1:data_length;
        aa = a(ismember(1:data_length,removed_index));
        for i = 1 :length(aa)
            Yoplsda6(find(removed_index == aa(i))) = y_hat(i);
        end

        Yoplsda = [Yoplsda1' Yoplsda2' Yoplsda3' Yoplsda4' Yoplsda5' Yoplsda6'];

        Yoplsdadiff = ( Ymiss - Yoplsda ) ./ repmat(Ystd,remove_num,1);
        YoplsMSE = sqrt(((Ymiss - Yoplsda).^2))./ repmat(Ystd,remove_num,1);

        Yoplsdadiff = reshape(Yoplsdadiff,1,[]);
        oplsda(miss,zz,:) = [mean(Yoplsdadiff) std(Yoplsdadiff) mean(mean(YoplsMSE))];
    end
end
%figure(1)
%cmap = [0.9 0.9 0.9; 0.9 0.9 0.9; 0.9 0.9 0.9; 0.9 0.9 0.9; 0.9 0.9 0.9; 0.9 0.9 0.9];
%aboxplot([knn(:,2) oplsda(:,2) squeeze(pca(:,1,2)) squeeze(pca(:,2,2)) squeeze(pca(:,3,2)) squeeze(pca(:,4,2))],'labels',{'k-NN','OPLS-DA','PCA 1PC','PCA 2PCs','PCA 3PCs','PCA 4PCs'},'colormap',cmap);
%title('Standard Deviation Imputation Error - 100 repetitions','Fontsize',24);

% figure(2)
% cmap = [0.9 0.9 0.9; 0.9 0.9 0.9; 0.9 0.9 0.9; 0.9 0.9 0.9; 0.9 0.9 0.9; 0.9 0.9 0.9; 0.9 0.9 0.9; 0.9 0.9 0.9; 0.9 0.9 0.9; 0.9 0.9 0.9; 0.9 0.9 0.9; 0.9 0.9 0.9];
% aboxplot([knn(1,:,3)' oplsda(1,:,3)' squeeze(pca(1,:,1,3))' squeeze(pca(1,:,2,3))' squeeze(pca(1,:,3,3))' squeeze(pca(1,:,4,3))'],'labels',{'k-NN','OPLS-DA','PCA 1PC','PCA 2PCs','PCA 3PCs','PCA 4PCs'},'colormap',cmap);
% data = [knn(:,:,3)' oplsda(:,:,3)' squeeze(pca(:,:,1,3))' squeeze(pca(:,:,2,3))' squeeze(pca(:,:,3,3))' squeeze(pca(:,:,4,3))'];
% plot_whiskergraph(data',remove_num_mat);
% title('Mean Imputation Error - 100 repetitions','Fontsize',24);
% ylabel('?','Fontsize',24);
% plot_benchmark_imputation(knn,oplsda,pca);
end

