function [Accuracy,CI] = Pr_CrossVal(features,persona,k,p,ci)

    %k = N° of Folds
    % p N° of PCA Elements
    
    Carac_norm = Bft_norm(features,0);
    
    c = cvpartition(persona,'KFold',k);
    Accuracy = zeros(1,k);
    disp('Working.....')
    
    for ii=1:k
        
        X_training = Carac_norm(c.training(ii),:);
        Y_training = persona(c.training(ii));
        X_test =  Carac_norm(c.test(ii),:);
        Y_test = persona(c.test(ii));
        
        Indice_clean = Bfs_clean(X_training);
        Carac_clean = X_training(:,Indice_clean);
        [PCA_Matrix,Score,~] = pca(Carac_clean,'NumComponents',p);
        Model = fitcdiscr(Score,Y_training,'DiscrimType','pseudoLinear');
        
        Caracteristicas_test = X_test(:,Indice_clean);
        X_pca_test = (Caracteristicas_test-repmat(mean(Caracteristicas_test),size(Caracteristicas_test,1),1))*PCA_Matrix;
        Y_predict = predict(Model, X_pca_test);
        
        Accuracy(ii) = sum(diag(confusionmat(Y_test,Y_predict)))./length(Y_predict);
        
    end
        
    % CI, c=Interval Confidence
    
        v = length(Accuracy);
        pm = mean(Accuracy);
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
        CI = [p1 p2];
    
end
