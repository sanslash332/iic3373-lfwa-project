load('face_points.mat')
face_points = load('./raw_faces_points_2.mat');

horror_show = true;

wrap_size = [120 120];

skipped = 0;

unwrapped_faces = {};

for ii = 1:length(face_points.detections)
  data = face_points.detections{ii};
  filename = data{1};
  points = data{2}.xy;

  newpoints = [0.5*(points(:,1) + points(:,3)), 0.5*(points(:,2) + points(:,4))];
  
  fprintf("Processing %d/%d : %s\n", ii, length(face_points.detections), char(filename));
  
  if(length(points) ~= 68)
    fprintf("  Could not process, skipping...\n");
    stru.filename = filename;
    stru.success = 0;
    stru.data = uint8(zeros(wrap_size));
    stru.distorsion = single(zeros(wrap_size));
    unwrapped_faces{ii} = stru;
    skipped = skipped + 1;
  else  
    img = imread(filename);

    [unwrapped, distorsion] = unwrap(img, wrap_size, tris_faces, newpoints, tris_vertex);
    
    if(horror_show)
      f = figure();
      imagesc(unwrapped)
      axis('image')
      colormap gray
      fprintf("Press key for next image.")
      pause
      close(f)
    end
    
    stru.filename = filename;
    stru.success = 1;
    stru.data = unwrapped;
    stru.distorsion = distorsion;
    
    unwrapped_faces{ii} = stru;
  end
  
end

if(~horror_show)
  save('unwrapped_faces.mat', 'unwrapped_faces');
end

if(skipped > 0)
  fprintf("Skipped %d images.\n", skipped);
end