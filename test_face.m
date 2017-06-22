compile;

image_index = 16;

load face_p146_small.mat
load('raw_faces_points_2.mat', 'detections')

model.interval = 5;
model.thresh = min(-0.65, model.thresh);

if length(model.components)==13 
    posemap = 90:-15:-90;
elseif length(model.components)==18
    posemap = [90:-15:15 0 0 0 0 0 0 -15:-15:-90];
else
    error('Can not recognize this model');
end

path = sprintf("faces_lfwa_3/%s", detections{image_index}{1});
im = imread(char(path));
bs = detections{image_index}{2};

figure,showboxes(repmat(im,1,1,3), bs, posemap),title('Detected face');
