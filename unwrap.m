function [ f_img, f_distort ] = unwrap(img, unwrapped_size, tris, start_points, end_points)
%UNWRAP Summary of this function goes here
%   Detailed explanation goes here

  img = single(img);
  f_img = zeros(unwrapped_size);
  f_distort = single(zeros(unwrapped_size));
  f_dis = ones(unwrapped_size)*realmax('single');
  
  for ii = 1:size(tris,1)
    c_tris = tris(ii,:);
    start_tris = [start_points(c_tris(1),:); start_points(c_tris(2),:); start_points(c_tris(3),:)];
    end_tris   = [end_points(c_tris(1),:); end_points(c_tris(2),:); end_points(c_tris(3),:)];
    
    u_s = start_tris(2,:) - start_tris(1,:);
    v_s = start_tris(3,:) - start_tris(1,:);
    
    u_e = end_tris(2,:) - end_tris(1,:);
    v_e = end_tris(3,:) - end_tris(1,:);
    
    if(cond([u_s' v_s']) < 10000)
      A  = [[[u_e' v_e']*inv([u_s' v_s']) (end_tris(1,:) - start_tris(1,:))']; 0 0 1];
      img_offset = (A*([0,0,1] - [start_tris(1,:), 0])') + [start_tris(1,:), 0]';
      img_offset = img_offset(1:2,:)';
    
      A(1, 3) = img_offset(1);
      A(2, 3) = img_offset(2);
      tA = affine2d(A');
    
      dis = distance_to_tris(size(img), start_tris);
    
      crop_move = imref2d(unwrapped_size, [1 unwrapped_size(2)], [1 unwrapped_size(1)]);
    
      final_img = imwarp(img, tA, 'cubic', 'OutputView', crop_move);
      final_dis = imwarp(dis, tA, 'nearest', 'OutputView', crop_move, 'FillValues', prod(unwrapped_size), 'SmoothEdges', false);
    
      area_disparity = cross([u_e 0], [v_e 0])/cross([u_s 0], [v_s 0]);
      area_disparity = 20*(1 - sign(area_disparity)) + abs(log(abs(area_disparity)));
    
      less = final_dis < f_dis;
      equal = final_dis == f_dis;
    
      f_img(less) = final_img(less);
      %f_img(equal) = 0.5*(final_img(equal) + f_img(equal));
    
      f_distort(less) = area_disparity;
      %f_distort(equal) = 0.5*(area_disparity + f_distort(equal));
    
      f_dis(less) = final_dis(less);
      
    end
  end

  f_img(f_img > 255) = 255;
  f_img(f_img < 0) = 0;
  
  f_img = uint8(f_img);
  
end
