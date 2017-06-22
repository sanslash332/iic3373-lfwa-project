source_folder = "./faces_lfwa_3/";
destin_folder = "./faces_lfwa_3_eq/";

mkdir(char(destin_folder));

ims = dir(char(sprintf('%s*.png', source_folder)));
for i = 1:length(ims)
  f = ims(i);
  fprintf('Equalizing: %d/%d: %s\n', i, length(ims), f.name);
  image = imread(char(sprintf('%s%s', source_folder, f.name)));
  R = [];
  quality = 128;
  [x_eq, y_eq] = eqinfo(image, R, quality);
  img = uint8(eqnorm(image, x_eq, y_eq)*255);
  out_name = char(sprintf('%s%s', destin_folder, f.name));
  imwrite(img, out_name);
end