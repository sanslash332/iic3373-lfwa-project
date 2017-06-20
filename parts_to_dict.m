function [D, used_values] = parts_to_dict(data)
  
  sample_index = 1;
  while(~(data{sample_index}.success))
    sample_index = sample_index + 1;
  end
  
  patch_sizes = zeros(length(data{sample_index}.data),2);
  s_data = data{sample_index};
  for ii = 1:size(patch_sizes, 1)
    patch_sizes(ii,:) = size(s_data.data{ii});
  end
  patch_lengths = prod(patch_sizes, 2);
  index_off     = cumsum([0 patch_lengths']) + 1;
  
  valid_values = uint8(zeros(length(data), 1));
  for data_i = 1:length(data)
    c_data = data{data_i};
    valid_values(data_i) = c_data.success;
  end
  
  used_values = find(valid_values);
  
  D = zeros(index_off(end), nnz(used_values));
  
  for data_i = 1:length(used_values)
    c_data = data{used_values(data_i)};
    patches = c_data.data;
    for patch_i = 1:length(patches)
      p = patches{patch_i};
      column = zeros(index_off(end), 1);
      column(index_off(patch_i):(index_off(patch_i+1)-1)) = p(:);
      plot(column)
      pause
      D(:, (data_i-1)*length(patches) + patch_i) = column;
    end
  end
  
  % Normalize
  D = D./sqrt(sum((D.^2), 1));
  
end