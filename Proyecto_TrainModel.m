function [Model] = Proyecto_TrainModel(Caracteristicas,persona_training)

    X = Caracteristicas;
    L_training = persona_training;

    tknn5 = templateKNN('NumNeighbors',5);
    Model.ModelKnn5 = fitcecoc(X, L_training,'Learners',tknn5);
    tknn10 = templateKNN('NumNeighbors',10);
    Model.ModelKnn10 = fitcecoc(X, L_training,'Learners',tknn10);
    tlda = templateDiscriminant('DiscrimType','pseudoLinear');
    Model.ModelLDA = fitcecoc(X, L_training, 'Learners',tlda);
    tqda = templateDiscriminant('DiscrimType','diagQuadratic');
    Model.ModelQDA = fitcecoc(X, L_training, 'Learners',tqda);
    Model.ModelSVM = fitcecoc(X, L_training);
    
end