face_points = load('./raw_faces_points_2.mat');

offsets = [ 0.02,  0.02;...
            0.02,  0, ;...
            0.02, -0.02;...
            0   ,  0.02;...
            0   ,  0, ;...
            0   , -0.02;...
           -0.02,  0.02;...
           -0.02,  0, ;...
           -0.02, -0.02];

n_offsets = size(offsets, 1);
       
r_eye_points = 10:15;
l_eye_points = 21:26;
nose_points  = 1:9;
mouth_points = 32:51;

all_points = {r_eye_points, l_eye_points, nose_points, mouth_points};

r_eye_size = [15 20];
l_eye_size = [15 20];
nose_size  = [30 10];
mouth_size = [15 20];

all_sizes = [r_eye_size; l_eye_size; nose_size; mouth_size];

id = affine2d(eye(3));

all_data = cell(length(face_points.detections)*n_offsets, 1);

fit_factor = 0.3;

person = uint32(zeros(length(all_data), 1));
offset = uint32(zeros(size(person, 1), 1));
photo  = uint32(zeros(size(person, 1), 1));
patch  = uint32(zeros(size(person, 1), 1));

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
  
  stru = struct();
  stru.filename = filename;
  
  if(length(points) ~= 68)
    fprintf("  Could not process, skipping...\n");
    stru.success = 0;
    
    for off_i = 1:n_offsets
      all_data{(ii - 1)*n_offsets + off_i} = stru;  
    end
  else  
    stru.success = 1;
    img = imread(filename);
  
    stru.filename = filename;
    
    % [minx miny maxx maxy]
    ranges = zeros(length(all_points), 4);
    for c_point_i = 1:length(all_points)
      positions = newpoints(all_points{c_point_i},:);
      ranges(c_point_i, :) = [min(positions(:,1)) min(positions(:,2)) max(positions(:,3)) max(positions(:,4))];
    end
    
    for off_i = 1:size(offsets, 1)
      off = offsets(off_i, :);
      
      patches = cell(length(all_points), 1);
      for patch_i = 1:length(patches)
        crop = off.*(ranges(patch_i, 3:4) - ranges(patch_i, 1:2));
        crop = ranges(patch_i,:) + [crop crop];
        crop_transform = imref2d(all_sizes(patch_i, :), [crop(1) crop(3)], [crop(2) crop(4)]);
        patches{patch_i} = imwarp(img, id, 'cubic', 'OutputView', crop_transform);
        stru.data = patches;
        index = (ii - 1)*n_offsets + off_i;
        all_data{index} = stru;
        offset(index) = off_i;
        patch(index)  = patch_i;
        person(index) = uint32(str2num(filename(6:9)));
        photo(index)  = uint32(str2num(filename(11:14)));
      end
    end
  end
end

[Dall, used_index] = parts_to_dict(all_data);

patch  = patch(used_index);
photo  = photo(used_index);
person = person(used_index);
offset = offset(used_index);

save('Dall.mat','Dall', 'person', 'photo', 'patch', 'offset');
clear all;
