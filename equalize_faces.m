face_points = load("raw_faces_points_2.mat");
source_folder = "./faces_lfwa_3/";
destin_folder = "./faces_lfwa_3_eq/";

mkdir(char(destin_folder));

show_selected_reg = true;

for i = 1:length(face_points.detections)
  data = face_points.detections{i};
  f = data{1};
  points = data{2}.xy;
  points(:,1) = 0.5*(points(:,1) + points(:,3));
  points(:,2) = 0.5*(points(:,2) + points(:,4));
  points = points(:,1:2);
  
  fprintf('Equalizing: %d/%d: %s\n', i, length(face_points.detections), f);
  image = imread(char(sprintf('%s%s', source_folder, f)));
  
  R = zeros(size(image));
  for p_i = 1:size(points,1)
    p = points(p_i, :);
    if(p(1) <= size(R, 2) && p(2) <= size(R, 1))
      R(uint32(p(2)), uint32(p(1))) = 1;
    end
  end
  
  R = bwconvhull(R>=1);
  
  quality = 128;
  [x_eq, y_eq] = eqinfo(image, R, quality);
  img = uint8(eqnorm(image, x_eq, y_eq)*255);
  
  if(show_selected_reg)
    close all
    figure()
    tmp = img;
    tmp(~R) = 0;
    imagesc(tmp)
    colormap('gray')
    axis('image')
    pause
  end
  
  out_name = char(sprintf('%s%s', destin_folder, f));
  imwrite(img, out_name);
end
