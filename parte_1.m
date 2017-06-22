
%% Extracci�n de Caracter�sticas sobre las caras enteras, aqui saco la de las caras enteras

% b(1).name = 'lbp';
% b(1).options.type = 2;
% b(1).options.vdiv = 1;                  % one vertical divition
% b(1).options.hdiv = 1;                  % one horizontal divition
% b(1).options.semantic = 0;              % classic LBP
% b(1).options.samples  = 8;              % number of neighbor samples
% b(1).options.mappingtype = 'u2';  
% 
% b(2).name = 'haralick';
% b(2).options.type = 2;
% b(2).options.dharalick = 1;
% b(2).options.show = 0; 
% 
% b(3).name = 'haralick';
% b(3).options.type = 2;
% b(3).options.dharalick = 2;
% b(3).options.show = 0; 
% 
% b(4).name = 'hog';
% b(4).options.type = 2;
% b(4).options.nj = 3;
% b(4).options.ni = 3;
% b(4).options.B = 9; % Angles
% b(4).options.show = 0;
% 
% 
% b(5).name = 'gabor';
% b(5).options.type = 2;
% b(5).options.Lgabor  = 8;                 % number of rotations
% b(5).options.Sgabor  = 8;                 % number of dilations (scale)
% b(5).options.fhgabor = 2;                 % highest frequency of interest
% b(5).options.flgabor = 0.1;               % lowest frequency of interest
% b(5).options.Mgabor  = 21;                % mask size
% b(5).options.show    = 0;  
% 
% 
% f.path          = '.\faces_lfwa_3';  % directory of the images
% f.prefix        = '*';
% f.extension     = '.png';
% f.gray          = 1;
% f.imgmin        = 1;
% f.imgmax        = 4174;
% 
% opf.b = b;
% opf.channels = 'g';              % grayscale image
% 
% [X_faces,labels_c,S] = Bfx_files(f,opf);

%%
% persona =ones(length(S),1);
% foto = ones(length(S),1);
% 
% for k=1:length(S)
%     name = S(k,:);
%     c = strsplit(name,'/');
%     persona(k) = str2double(c{2}(6:9));
%     foto(k) = str2double(c{2}(11:14));
% end
% 
% save('paso1.mat','X_faces','persona','labels_c','foto');
% 
%% Localizado

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

b(4).name = 'hog';
b(4).options.type = 2;
b(4).options.nj = 3;
b(4).options.ni = 3;
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

mask = uint8(zeros(length(all_data), 1));
valid_index = 0;
for k=1:length(mask)
  valid = all_data{k}.success;
  if(valid)
    valid_index = k;
  end
  mask(k) = valid;
end

test_features_length = 0;
test_data = all_data{valid_index}.data;
for ii = 1:length(test_data)
  patch = test_data{ii};
  [x,xn] = Bfx_int(patch,opf);
  test_features_length = test_features_length + length(x);
end

valid_indexes = find(mask);
features = zeros(length(valid_indexes), test_features_length);
features_labels = zeros(length(valid_indexes), 24);
persona  = uint32(zeros(length(valid_indexes), 1));
foto     = uint32(zeros(length(valid_indexes), 1));

for k=1:length(valid_indexes)
  index = valid_indexes(k);
  
  filename = all_data{index}.filename;
  data = all_data{index}.data;
  x_cell  = cell(length(data), 1);
  xn_cell = cell(length(data), 1);
  
  fprintf("Processing face %d/%d: %s\n", index, length(all_data), filename);
  
  for patch_i = 1:length(data)
    [x,xn] = Bfx_int(data{patch_i},opf);
    x_cell{patch_i}  = x;
    xn_cell{patch_i} = xn;
  end
  
  features(k, :) = [x_cell{:}];
  features_labels(k, :) = [xn_cell{:}];
  persona(k) = uint32(str2num(filename(6:9)));
  foto(k)    = uint32(str2num(filename(11:14)));
end

save('paso1.mat','features', 'persona', 'foto');
