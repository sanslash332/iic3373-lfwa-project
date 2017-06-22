compile;

max_tries = 10;

load face_p146_small.mat

model.interval = 5;
model.thresh = min(-0.65, model.thresh);

if length(model.components)==13 
    posemap = 90:-15:-90;
elseif length(model.components)==18
    posemap = [90:-15:15 0 0 0 0 0 0 -15:-15:-90];
else
    error('Can not recognize this model');
end

ims = dir('faces_lfwa_3_eq/*.png');

detections = {length(ims), 1};

for i = 1:length(ims)
    fprintf('testing: %d/%d\n', i, length(ims));
    im = repmat(imread(['faces_lfwa_3_eq/' ims(i).name]), 1,1,3);
    
    thres = model.thresh;
    for ty = 1:max_tries
      bs = detect(im, model, model.thresh);
      bs = clipboxes(im, bs);
      bs = nms_face(bs,0.3);
      
      success = ~isempty(bs);
      if success
          break
      end
      model.thresh = model.thresh - 0.1;
    end
    model.thresh = thres;
    
    if ~success
      fprintf('Could not detect face on image: %d\n', i);
    end
    
    % show highest scoring one
    %showboxes(im, bs(1),posemap),title('Highest scoring detection');
    detections{i} = {ims(i).name, bs(1)};
end

disp('saving...');
save('raw_faces_points.mat', 'detections')
disp('done!');