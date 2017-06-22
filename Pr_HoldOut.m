function [Accuracy] = Pr_HoldOut(features,foto,persona,k)

    Carac_norm = Bft_norm(features,0);
    indice_training = logical(foto < 11);
    indice_test = not(indice_training);
    
    Indice_clean = Bfs_clean(Carac_norm(indice_training,:));
    Carac_clean = Carac_norm(indice_training,Indice_clean);
    [PCA_Matrix,Score,~] = pca(Carac_clean,'NumComponents',k);
    
    disp('Training model..... ');
    Model = fitcdiscr(Score,persona(indice_training),'DiscrimType','pseudoLinear');
    
    Caracteristicas_test = Carac_norm(indice_test,Indice_clean);
    X_pca_test = (Caracteristicas_test-repmat(mean(Caracteristicas_test),size(Caracteristicas_test,1),1))*PCA_Matrix;
    
    disp('Predicting and evaluating ');
    
    Y_predict = predict(Model, X_pca_test);
    
    Accuracy = Evaluate(persona(indice_test),Y_predict);
    
end
    
