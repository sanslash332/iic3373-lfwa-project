function [x_info, y_info] = eqinfo(img, R, bins)
  
  if(isempty(R))
    values = img;
  else
    values = img(R);
  end

  values = values(:);
  [y_info, x_info] = histcounts(values,bins);
  
  x_range = [0, x_info(end)];
  if(x_range(end) < 2)
    x_range(end) = 1;
  else
    x_range(end) = 255;
  end
  
  y_info  = cumsum(y_info);
  y_info  = y_info./y_info(end);
  
  x_info = (x_info - x_range(1))/(x_range(end) - x_range(1));
  
  x_info = 0.5*(x_info(1:(end-1)) + x_info(2:end));
  x_info = [0 x_info 1]';
  y_info = [0 y_info 1]';
  
end

