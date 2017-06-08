function [X, Xn] = Bfx_haar(I,R, options)
%BFX_HAAR Summary of this function goes here
%   Detailed explanation goes here
  kernels = options.kernels;
  div_x = options.div_x;
  div_y = options.div_y;
  
  strlen = 24;
  
  X  = zeros(1, length(kernels) * div_x * div_y);
  Xn = char(zeros(length(kernels) * div_x * div_y, strlen));

  index = 0;
  for ii=1:length(kernels)
    coo = conv2(I, kernels{ii});
    coo_size = size(coo);
    coo_step = round(coo_size ./ [div_x, div_y]);
    for x=1:div_x
      for y=1:div_y
        index = index + 1;
        label = char(sprintf("Haar(%d,%d)(%d)", x, y, index));
        Xn(index,1:length(label)) = label;
        if(x < div_x)
          if(y < div_y)
            slice = coo(((x-1)*coo_step(1)+1):(x*coo_step(1)+1), ((y-1)*coo_step(2)+1):(y*coo_step(2)+1));
          else
            slice = coo(((x-1)*coo_step(1)+1):(x*coo_step(1)+1), ((y-1)*coo_step(2)+1):end);
          end
        else
          if(y < div_y)
            slice = coo(((x-1)*coo_step(1)+1):end, ((y-1)*coo_step(2)+1):(y*coo_step(2)+1));
          else
            slice = coo(((x-1)*coo_step(1)+1):end, (y*coo_step(2)+1):end);
          end
        end
        X(index) = sum(sum(slice));
      end
    end
  end

end

