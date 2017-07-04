function [Accuracy,CI] = Pr_CrossVal(features,persona,k,p,ci)

    %k = Nº of Folds
    %p = Nº of PCA Elements
    
    Carac_norm = Bft_norm(features,0);
    
    c = cvpartition(persona,'KFold',k);
    Accuracy = zeros(k,4);
    disp('Working Folds.....')
    
    for ii=1:k
        %         Indice_clean = Bfs_clean(X_training);
        %         Carac_clean = X_training(:,Indice_clean);
        fprintf('Fold = %d \n',ii);
        X_training = Carac_norm(c.training(ii),:);
        Y_training = persona(c.training(ii));
        X_test =  Carac_norm(c.test(ii),:);
        Y_test = persona(c.test(ii));
        [PCA_Matrix,Score,~] = pca(X_training,'NumComponents',p);
                
        disp('Training model LDA..... ');
        Model{1}.m = fitcdiscr(Score,Y_training,'DiscrimType','pseudoLinear');
        Model{1}.name = 'LDA';
%         disp('Training model QDA..... ');
%         Model{2}.m = fitcdiscr(Score,Y_training,'DiscrimType','diagquadratic');
%         Model{2}.name = 'qda';
%         disp('Training model KNN10..... ');
%         Model{3}.m = fitcknn(Score,Y_training,'NumNeighbors',10);
%         Model{3}.name = 'knn10';
%         disp('Training model KNN5..... ');
%         Model{4}.m = fitcknn(Score,Y_training,'NumNeighbors',5);
%         Model{4}.name = 'knn5';
        
        Caracteristicas_test = X_test(:,:);
        X_pca_test = (Caracteristicas_test-repmat(mean(Caracteristicas_test),size(Caracteristicas_test,1),1))*PCA_Matrix;
        
        for jj=1:length(Model)
            Y_predict = predict(Model{jj}.m , X_pca_test);
            Accuracy(ii,jj) = sum(diag(confusionmat(Y_test,Y_predict)))./length(Y_predict);
        end
        
    end
        
    % CI, c=Interval Confidence
    
    CI = cell(1,length(Model));
    
    for k=1:size(Accuracy,2)
        Acc = Accuracy(:,k);
        v = length(Acc);
        pm = mean(Acc);
        mu = pm;
        sigma = sqrt(pm*(1-pm)/size(features,1));
        t = (1-ci)/2;
        if v>20
            z = norminv(1-t);
        else
            z = tinv(1-t,v-1);
        end
        p1 = max(0,mu - z*sigma);
        p2 = min(1,mu + z*sigma);
        CI{k}.ci = [p1 p2];
        CI{k}.mean = pm;
    end
    
end
