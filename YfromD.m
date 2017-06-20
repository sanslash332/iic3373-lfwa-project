function [Y, persona_Y] = YfromD(D, test_set, persona, photo)
%YFROMD Summary of this function goes here
%   Detailed explanation goes here

  valid_D = D(:, test_set);

  valid_persona = persona(test_set);
  valid_photo   = photo(test_set);
  
  unique_persona = unique(valid_persona);
  % Reduce at end of function
  Y = zeros(size(D, 1), length(valid_persona));
  persona_Y = uint32(zeros(size(Y, 1), size(Y, 2)));
  
  index = 0;
  
  for p_i = 1:length(unique_persona)
    p = unique_persona(p_i);
    local_range  = find(valid_persona == p);
    local_data   = valid_D(:, local_range);
    local_photo  = valid_photo(local_range);
    unique_photo = unique(local_photo);
    for f_i = 1:length(unique_photo)
      f = unique_photo(f_i);
      index = index + 1;
      patches = local_photo == f;
      data = local_data(:, patches);
      Y(:, index) = sum(data, 2);
      persona_Y(index) = p;
    end
    
  end

  Y = Y(:, 1:index);
  persona_Y = persona_Y(1:index);
  
end

