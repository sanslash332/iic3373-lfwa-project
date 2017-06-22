function equalized = eqnorm(img, x_info, y_info)
  %UNTITLED2 Summary of this function goes here
  %   Detailed explanation goes here

  equalized = zeros(size(img));
  if(max(max(img)) > 2)
    img = single(img)/255.0;
  end
  equalized(:) = interp1q(x_info, y_info, single(img(:))); 

end

