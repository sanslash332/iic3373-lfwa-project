
%% Extracción de Características sobre las caras enteras, aqui saco la de las caras enteras

b(1).name = 'lbp';
b(1).options.type = 2;
b(1).options.vdiv = 2;                  % one vertical divition
b(1).options.hdiv = 4;                  % one horizontal divition
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

b(4).name = 'hog';
b(4).options.type = 2;
b(4).options.nj = 20;
b(4).options.ni = 10;
b(4).options.B = 9;
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
f.imgmax        = 4174;

opf.b = b;
opf.channels = 'g';              % grayscale image

[X_faces,labels_c,S] = Bfx_files(f,opf);


persona =ones(length(S),1);
foto = ones(length(S),1);

for k=1:length(S)
    name = S(k,:);
    c = strsplit(name,'/');
    persona(k) = str2double(c{2}(6:9));
    foto(k) = str2double(c{2}(11:14));
end

save('paso1.mat','X_faces','persona','labels_c','foto');

%% Localizado

b(1).name = 'lbp';
b(1).options.type = 2;
b(1).options.vdiv = 4;                  % one vertical divition
b(1).options.hdiv = 4;                  % one horizontal divition
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

b(4).name = 'hog';
b(4).options.type = 2;
b(4).options.nj = 20;
b(4).options.ni = 10;
b(4).options.B = 9;
b(4).options.show = 0;


b(5).name = 'gabor';
b(5).options.type = 2;
b(5).options.Lgabor  = 8;                 % number of rotations
b(5).options.Sgabor  = 8;                 % number of dilations (scale)
b(5).options.fhgabor = 2;                 % highest frequency of interest
b(5).options.flgabor = 0.1;               % lowest frequency of interest
b(5).options.Mgabor  = 21;                % mask size
b(5).options.show    = 0;     

opf.b = b;
opf.colstr = 'i'; 

load('all_data.mat');

X_parches = [];


for k=1:length(all_data)
    
    if all_data{k}.success == 1
        
        [X_Leye,Xn_Leye] = Bfx_int(all_data{k}.data{1},opf); 
        [X_Reye,Xn_Reye] = Bfx_int(all_data{k}.data{2},opf); 
        [X_nose,Xn_nose] = Bfx_int(all_data{k}.data{3},opf); 
        [X_mouth,Xn_mouth] = Bfx_int(all_data{k}.data{4},opf); 
        
    else
        
        [X_Leye,Xn_Leye] = Bfx_int(all_data{k-1}.data{1},opf); 
        [X_Reye,Xn_Reye] = Bfx_int(all_data{k-1}.data{2},opf); 
        [X_nose,Xn_nose] = Bfx_int(all_data{k-1}.data{3},opf); 
        [X_mouth,Xn_mouth] = Bfx_int(all_data{k-1}.data{4},opf); 
        
    end
    
    X_parches = [X_parches ; X_Leye X_Reye X_nose X_mouth];
       
end
