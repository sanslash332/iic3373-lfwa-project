load('paso1.mat')

Carac_norm = Bft_norm(caracteristicas,0);
indice_training = logical(foto < 11);
indice_test = not(indice_training);

Indice_clean = Bfs_clean(Carac_norm(indice_training,:));
Carac_clean = Carac_norm(indice_training,Indice_clean);
op.m = 100;       
op.show =1;
op.b.name = 'fisher';
Indice_SFS = Bfs_sfs(Carac_clean,persona(indice_training),op);

save('paso2.mat','caracteristicas','persona','labels_c','foto','Indice_SFS','Indice_clean');
%% Modelos

X = Carac_norm(indice_training,Indice_clean(Indice_SFS));
L_training = persona(indice_training);
Y = Carac_norm(indice_test,Indice_clean(Indice_SFS));
L_test = persona(indice_test);

for k=1:length(L_test)
    aux = L_test(k);
    ttest(aux,k) = 1;
end

for k=1:length(L_training)
    aux = L_training(k);
    ttrain(aux,k) = 1;
end


% ModelKnn3 = fitcecoc(X, L_training,'NumNeighbors',5);
% ModelKnn5 = fitcknn(X, L_training,'NumNeighbors',10);
% ModeLDA  = fitcdiscr(X, L_training,'DiscrimType','pseudolinear');
% ModeQDA  = fitcdiscr(X, L_training,'DiscrimType','diagquadratic');

tknn5 = templateKNN('NumNeighbors',5);
ModelKnn5 = fitcecoc(X, L_training,'Learners',tknn5);
tknn10 = templateKNN('NumNeighbors',10);
ModelKnn10 = fitcecoc(X, L_training,'Learners',tknn10);
tlda = templateDiscriminant('DiscrimType','pseudoLinear');
ModelLDA = fitcecoc(X, L_training, 'Learners',tlda);
tqda = templateDiscriminant('DiscrimType','diagQuadratic');
ModelQDA = fitcecoc(X, L_training, 'Learners',tqda);
ModelSVM = fitcecoc(X, L_training);


%  net = patternnet(5);
%  net = train(net,X',ttrain);
%  yy = net(Y');
%  
%  net2 = patternnet(20);
%  net2 = train(net2,X',ttrain);
%  yy2 = net2(Y');
 
 disp('Resultados de Rendimiento')
 disp(['KNN3  ' num2str(1 - loss(ModelKnn5,Y,L_test))])
 disp(['KNN5  ' num2str(1 - loss(ModelKnn10,Y,L_test))])
 disp(['LDA  ' num2str(1 - loss(ModelLDA, Y,L_test))])
 disp(['QDA  ' num2str(1 - loss(ModelQDA, Y,L_test))])
 %disp(['Linear SVM  ' num2str(1 - loss(ModelSVML,Y,L_test))])
 %disp(['Logistic    ' num2str(1 - loss(ModelLogistic,Y,L_test))])
 disp(['SVM  ' num2str(1 - loss(ModelSVM,Y, L_test))])
 %disp(['SVM  G ' num2str(1 - loss(ModelSVM_G,Y, L_test))])

%  figure
%  plotconfusion(ttrain,yy)
%  figure
%  plotconfusion(ttrain,yy2)
%  

%Si quieres calcular los valores predictivos de cada modelo, puedes usar
%predict(modelo,Y);


%% Cross validation

c = cvpartition(persona,'KFold',4);
accuracy = [];

for k=1:4
    X_training = Carac_norm(c.training(k),Indice_clean(Indice_SFS));
    Y_training = persona(c.training(k));
    X_test =  Carac_norm(c.test(k),Indice_clean(Indice_SFS));
    Y_test = persona(c.test(k));
    
    ModelKnn3 = fitcknn(X_training, Y_training,'NumNeighbors',5);
    ModelKnn5 = fitcknn(X_training, Y_training,'NumNeighbors',20);
    ModeLDA  = fitcdiscr(X_training, Y_training,'DiscrimType','pseudolinear');
    ModeQDA  = fitcdiscr(X_training, Y_training,'DiscrimType','diagquadratic');
    ModelSVM = fitcecoc(X_training, Y_training);
    
   
    accuracy = [ accuracy ;(1-loss(ModelKnn3,X_test,Y_test)) (1-loss(ModelKnn5,X_test,Y_test)) ...
        (1-loss(ModeLDA,X_test,Y_test)) (1-loss(ModeQDA,X_test,Y_test)) (1-loss(ModelSVM,X_test,Y_test))];   
    
end

    