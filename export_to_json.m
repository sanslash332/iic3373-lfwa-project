load('raw_faces_points_2.mat', 'detections');

fileID = fopen('exported.json','w');

fprintf(fileID,'[\n');

for i=1:length(detections)
  fprintf("Processing: %d/%d \n", i, length(detections));
  raw = detections{i};
  tag = raw{1};
  data = raw{2};
  fprintf(fileID,'  [\"%s\",', tag);
  fprintf(fileID,'{\"s\":%f,', data.s);
  fprintf(fileID,'\"c\":%d,', data.c);
  fprintf(fileID,'\"xy\":[');
  shape = size(data.xy);
  for ii = 1:shape(1)
    fprintf(fileID,'[');
    for jj = 1:shape(2)
      fprintf(fileID,'%f', data.xy(ii, jj));
      if jj < shape(2)
        fprintf(fileID,',');
      end
    end
    fprintf(fileID,']');
    if ii < shape(1)
      fprintf(fileID,',');
    end
  end
  fprintf(fileID,'],');
  fprintf(fileID,'\"level\":%d}]', data.level);
  if i < length(detections)
    fprintf(fileID,',\n');
  else
    fprintf(fileID,'\n');
  end
end

fprintf(fileID,']');
fclose(fileID);
