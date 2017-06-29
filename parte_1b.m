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
features_labels = zeros(length(valid_indexes), test_features_length, 24);
persona  = uint32(zeros(length(valid_indexes), 1));
foto     = uint32(zeros(length(valid_indexes), 1));

for k=1:length(valid_indexes)
  index = valid_indexes(k);

  filename = all_data{index}.filename;
  data = all_data{index}.data;
  x_cell  = cell(length(data), 1);

  fprintf("Processing face %d/%d: %s\n", index, length(all_data), filename);

  step = test_features_length/length(data);
  features_labels = char(zeros(test_features_length, 24));
  for patch_i = 1:length(data)
    [x,xn] = Bfx_int(data{patch_i},opf);
    x_cell{patch_i}  = x;
    features_labels(((patch_i - 1)*step +1):patch_i*step, :) = xn;
    index_label = char(sprintf('(%d)', patch_i));
    for label_i = 0:(length(index_label)-1)
      features_labels(((patch_i - 1)*step +1):patch_i*step, end-label_i) = index_label(end-label_i);
    end
  end
  features(k, :) = [x_cell{:}];
  
  name = strsplit(filename,'/');
  persona(k) = uint32(str2num(name{end}(6:9)));
  foto(k)    = uint32(str2num(name{end}(11:14)));
end

save('paso1_patches.mat','features','features_labels', 'persona', 'foto','valid_indexes');

