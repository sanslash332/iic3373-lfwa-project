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
b(4).options.B = 9; % Angles
b(4).options.show = 0;


b(5).name = 'gabor';
b(5).options.type = 2;
b(5).options.Lgabor  = 4;                 % number of rotations
b(5).options.Sgabor  = 4;                 % number of dilations (scale)
b(5).options.fhgabor = 2;                 % highest frequency of interest
b(5).options.flgabor = 0.1;               % lowest frequency of interest
b(5).options.Mgabor  = 21;                % mask size
b(5).options.show    = 0;  



f.path          = char("./faces_lfwa_3_eq/");  % directory of the images
f.prefix        = '*';
f.extension     = '.png';
f.gray          = 1;
f.imgmin        = 1;
f.imgmax        = 4174;

opf.b = b;
opf.channels = 'g';              % grayscale image

[features,features_labels,S] = Bfx_files(f,opf);

persona =ones(length(S),1);
foto = ones(length(S),1);

for k=1:length(S)
    name = S(k,:);
    c = strsplit(name,'/');
    persona(k) = str2double(c{end}(6:9));
    foto(k) = str2double(c{end}(11:14));
end

save('paso1_faces.mat','features','features_labels','persona','foto');

