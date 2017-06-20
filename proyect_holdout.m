function [train_set, test_set] = proyect_holdout(persona, photo, patch, offset, seed, k)
  %UNTITLED2 Summary of this function goes here
  %   Detailed explanation goes here

  unique_offset = unique(offset);
  
  train_set = find(photo <= k);
  
  test_set = find(photo > k & offset == (length(unique_offset) + 1)/2);
  
%   persona_unique = unique(persona);
%   offset_unique  = unique(offset);
%   patch_unique   = unique(patch);
%   
%   train_set = unit32(zeros(length(persona_unique)*length(patch_unique)*length(offset_unique)*k, 1));
%   test_set  = unit32(zeros(length(persona) - length(train_set), 1));
%   
%   max_photo = 0;
%   for p = persona_unique
%     max_photo = max(max_photo, length(unique(photo(persona(p == persona)))));
%   end
%   
%   photo_perm = randperm(max_photo);
%   
%   for p_i = 0:(length(persona_unique)-1)
%     p = persona_unique(p_i+1);
%     photo_index  = index(persona == p);
%     photo_local  = photo(photo_index);
%     photo_unique = unique(photo_local);
%     photo_perm_local = photo_perm(photo_perm <= length(photo_unique));
%     
%     photo_reorder = photo_unique(photo_perm_local);
%     
%     for f_i = photo_reorder(k)
%     
%     end
%   end
  
  

end

