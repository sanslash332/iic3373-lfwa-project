
%% Extracción de Características


b(1).name = 'lbp';
b(1).options.type = 2;
b(1).options.vdiv = 1;                  % one vertical divition
b(1).options.hdiv = 1;                  % one horizontal divition
b(1).options.semantic = 0;              % classic LBP
b(1).options.samples  = 8;              % number of neighbor samples
b(1).options.mappingtype = 'u2';  

b(2).name = 'haralick';
b(2).options.type = 2;
b(2).options.dharalick = 1;
b(2).options.show = 0; 

b(3).name = 'haralick';
b(3).options.type = 2;
b(3).options.dharalick = 2;
b(3).options.show = 0; 

b(4).name = 'haralick';
b(4).options.type = 2;
b(4).options.dharalick = 3;
b(4).options.show = 0;


b(5).name = 'gabor';
b(5).options.type = 2;
b(5).options.Lgabor  = 8;                 % number of rotations
b(5).options.Sgabor  = 8;                 % number of dilations (scale)
b(5).options.fhgabor = 2;                 % highest frequency of interest
b(5).options.flgabor = 0.1;               % lowest frequency of interest
b(5).options.Mgabor  = 21;                % mask size
b(5).options.show    = 0;     

f.path          = '.\faces_lfwa_3';  % directory of the images
f.prefix        =  '*';
f.extension     =  '.png';
f.gray          = 1;
f.imgmin        = 1;
f.imgmax        = 4175;

opf.b = b;
opf.channels = 'g';              % grayscale image


[caracteristicas,labels_c,S] = Bfx_files(f,opf);
%%
persona =ones(length(S),1);
foto = ones(length(S),1);

for k=1:length(S)
    name = S(k,:);
    c = strsplit(name,'/');
    persona(k) = str2double(c{2}(6:9));
    foto(k) = str2double(c{2}(11:14));
end

% save('paso1.mat','caracteristicas','persona','labels_c','foto');

%% Selección de características

indice_training = logical(foto < 11);
indice_test = not(indice_training);

Indice_clean = Bfs_clean(caracteristicas(indice_training,:));
Carac_clean = caracteristicas(indice_training,Indice_clean);
op.m = 50;       
op.show =1;
op.b.name = 'fisher';
Indice_SFS = Bfs_sfs(Carac_clean,L_training,op);

%% Modelos

X = caracteristicas(indice_training,Indice_SFS);
L_training = persona(indice_training);
Y = caracteristicas(indice_test,Indice_SFS);
L_test = persona(indice_test);


 ModelKnn = fitcknn(X, L_training,'NumNeighbors',3);
 ModeLDA  = fitcdiscr(X, L_training,'DiscrimType','linear');
 
 t1 = templateSVM('KernelFunction','linear');
 t2 = templateSVM('KernelFunction','gaussian');
 ModelSVM_polynomial = fitcecoc(X, L_training,'Learners',t1);
 ModelSVM_gaussian = fitcecoc(X, L_training, 'Learners',t2);
 
 
 disp('Resultados de Rendimiento')
 disp(['KNN  ' num2str(1 - loss(ModelKnn,Y,L_test))])
 disp(['LDA  ' num2str(1 - loss(ModeLDA, Y,L_test))])
 disp(['SVM Poly  ' num2str(1 - loss(ModelSVM_polynomial,Y, L_test))])
 disp(['SVM Gaussian  ' num2str(1 - loss(ModelSVM_gaussian,Y, L_test))])  
    