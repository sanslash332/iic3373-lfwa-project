function [Accuracy] = Pr_HoldOut(features,foto,persona,k)
    
    %k = Nº PSA

    Carac_norm = Bft_norm(features,0);
    indice_training = logical(foto < 11);
    indice_test = not(indice_training);
    
%     Indice_clean = Bfs_clean(Carac_norm(indice_training,:));
%     Carac_clean = Carac_norm(indice_training,Indice_clean);
    [PCA_Matrix,Score,~] = pca(Carac_norm(indice_training,:),'NumComponents',k);
    
    disp('Training model LDA..... ');
    Model{1}.m = fitcdiscr(Score,persona(indice_training),'DiscrimType','pseudoLinear');
    Model{1}.name = 'LDA';
    disp('Training model QDA..... ');
    Model{2}.m = fitcdiscr(Score,persona(indice_training),'DiscrimType','diagquadratic');
    Model{2}.name = 'qda';
    disp('Training model KNN10..... ');
    Model{3}.m = fitcknn(Score,persona(indice_training),'NumNeighbors',10);
    Model{3}.name = 'knn10';
    disp('Training model KNN5..... ');
    Model{4}.m = fitcknn(Score,persona(indice_training),'NumNeighbors',5);
    Model{4}.name = 'knn5';
    
%     tlda = templateDiscriminant('DiscrimType','pseudoLinear');
%     Model = fitcecoc(Score,persona(indice_training),'Learners',tlda);

    Caracteristicas_test = Carac_norm(indice_test,:);
    X_pca_test = (Caracteristicas_test-repmat(mean(Caracteristicas_test),size(Caracteristicas_test,1),1))*PCA_Matrix;
    
  
    Accuracy = {};
    
    for k=1:length(Model)
        fprintf('Predicting and Evaluating %s \n',Model{k}.name);
        Y_predict = predict(Model{k}.m, X_pca_test);
        Accuracy{k}.acc = Evaluate(persona(indice_test),Y_predict);
        Accuracy{k}.model = Model{k}.name;
    end
    
end
    
