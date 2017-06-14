face_points = load('./raw_faces_points_2.mat');

r_eye_points = 10:15;
l_eye_points = 21:26;
nose_points  = 1:9;
mouth_points = 32:51;

eyes_size = [30 40];
nose_size = [60 30];
mouth_size = [40 55];
id = affine2d(eye(3));

cropped_parts = cell(length(face_points.detections), 1);

fit_factor = 0.5;

for ii = 1:length(face_points.detections)
  data = face_points.detections{ii};
  filename = data{1};
  points = data{2}.xy;

  newpoints = zeros(size(points));
  
  newpoints(:,1) = (1-fit_factor)*points(:,1) + 0.5*fit_factor*(points(:,1) + points(:,3));
  newpoints(:,3) = (1-fit_factor)*points(:,3) + 0.5*fit_factor*(points(:,1) + points(:,3));

  newpoints(:,2) = (1-fit_factor)*points(:,2) + 0.5*fit_factor*(points(:,2) + points(:,4));
  newpoints(:,4) = (1-fit_factor)*points(:,4) + 0.5*fit_factor*(points(:,2) + points(:,4));
  
  fprintf("Processing %d/%d : %s\n", ii, length(face_points.detections), char(filename));
  
  if(length(points) ~= 68)
    fprintf("  Could not process, skipping...\n");
    stru.filename = filename;
    stru.success = 0;
    stru.r_eye = zeros(eyes_size);
    stru.l_eye = zeros(eyes_size);
    stru.nose = zeros(nose_size);
    stru.mouth = zeros(mouth_size);
  else  
    img = imread(filename);
  
    % [minx miny maxx maxy]
    r_eye_positions = newpoints(r_eye_points,:);
    l_eye_positions = newpoints(l_eye_points,:);
    nose_positions  = newpoints(nose_points,:);
    mouth_positions = newpoints(mouth_points,:);
  
    r_eye_ranges = [min(r_eye_positions(:,1)) min(r_eye_positions(:,2)) max(r_eye_positions(:,3)) max(r_eye_positions(:,4))];
    l_eye_ranges = [min(l_eye_positions(:,1)) min(l_eye_positions(:,2)) max(l_eye_positions(:,3)) max(l_eye_positions(:,4))];
    nose_ranges = [min(nose_positions(:,1)) min(nose_positions(:,2)) max(nose_positions(:,3)) max(nose_positions(:,4))];
    mouth_ranges = [min(mouth_positions(:,1)) min(mouth_positions(:,2)) max(mouth_positions(:,3)) max(mouth_positions(:,4))];
  
    r_eye_crop = imref2d(eyes_size, [r_eye_ranges(1) r_eye_ranges(3)], [r_eye_ranges(2) r_eye_ranges(4)]);
    r_eye = imwarp(img, id, 'cubic', 'OutputView', r_eye_crop);
  
    l_eye_crop = imref2d(eyes_size, [l_eye_ranges(1) l_eye_ranges(3)], [l_eye_ranges(2) l_eye_ranges(4)]);
    l_eye = imwarp(img, id, 'cubic', 'OutputView', l_eye_crop);
  
    nose_crop = imref2d(nose_size, [nose_ranges(1) nose_ranges(3)], [nose_ranges(2) nose_ranges(4)]);
    nose = imwarp(img, id, 'cubic', 'OutputView', nose_crop);
  
    mouth_crop = imref2d(mouth_size, [mouth_ranges(1) mouth_ranges(3)], [mouth_ranges(2) mouth_ranges(4)]);
    mouth = imwarp(img, id, 'cubic', 'OutputView', mouth_crop);
  
    stru.filename = filename;
    stru.success = 1;
    stru.r_eye = r_eye;
    stru.l_eye = l_eye;
    stru.nose = nose;
    stru.mouth = mouth;
    
    cropped_parts{ii} = stru;
  end
  
end

save('cropped_parts.mat', 'cropped_parts');