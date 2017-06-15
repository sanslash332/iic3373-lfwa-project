function [alpha, beta, gamma] = baricentric( tris_pos, X, Y )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

  a = tris_pos(1,:);
  b = tris_pos(2,:);
  c = tris_pos(3,:);
  
  abc_1 = b - a;
  abc_2 = c - a;
  
  areaABC = abc_1(1)*abc_2(2) - abc_1(2)*abc_2(1);
  areaPBC = (b(1) - X).*(c(2) - Y) - (b(2) - Y).*(c(1) - X);
  areaPCA = (c(1) - X).*(a(2) - Y) - (c(2) - Y).*(a(1) - X);

  alpha = areaPBC ./ areaABC;
  beta = areaPCA ./ areaABC;
  gamma = 1.0 - alpha - beta;

end

