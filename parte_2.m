load('paso1.mat')

indice_training = logical(foto < 11);
indice_test = not(indice_training);

Indice_clean = Bfs_clean(caracteristicas(indice_training,:));
Carac_clean = caracteristicas(indice_training,Indice_clean);
op.m = 50;       
op.show =1;
op.b.name = 'fisher';
Indice_SFS = Bfs_sfs(Carac_clean,persona(indice_training),op);

%% Modelos

X = caracteristicas(indice_training,Indice_SFS);
L_training = persona(indice_training);
Y = caracteristicas(indice_test,Indice_SFS);
L_test = persona(indice_test);


 ModelKnn = fitcknn(X, L_training,'NumNeighbors',10);
 ModeLDA  = fitcdiscr(X, L_training,'DiscrimType','linear');
 
  t1 = templateSVM('KernelFunction','linear');
%  t2 = templateSVM('KernelFunction','gaussian');
% ModelSVM_polynomial = fitcecoc(X, L_training,'Learners',t1);
%  ModelSVM_gaussian = fitcecoc(X, L_training, 'Learners',t2);


 disp('Resultados de Rendimiento')
 disp(['KNN  ' num2str(1 - loss(ModelKnn,Y,L_test))])
 disp(['LDA  ' num2str(1 - loss(ModeLDA, Y,L_test))])
%  disp(['SVM Poly  ' num2str(1 - loss(ModelSVM_polynomial,Y, L_test))])
%  disp(['SVM Gaussian  ' num2str(1 - loss(ModelSVM_gaussian,Y, L_test))])  
    