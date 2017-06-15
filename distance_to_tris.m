function distances = distance_to_tris( img_size, base_tris )
  %UNTITLED4 Summary of this function goes here
  %   Detailed explanation goes here

  tris_size = [10, 10];

  [XX, YY] = meshgrid(1:img_size(2), 1:img_size(1));

  [alpha, beta, gamma] = baricentric(base_tris, XX, YY);

  alpha_mask = sign(alpha) >= 0;
  beta_mask  = sign(beta ) >= 0;
  gamma_mask = sign(gamma) >= 0;

  is_tris = alpha_mask & beta_mask & gamma_mask;

  distances = sqrt(prod(tris_size))*(1 - is_tris).*(sqrt((1 - alpha_mask).*power(alpha,2) + (1 - beta_mask).*power(beta,2) + (1 - gamma_mask).*power(gamma,2)));

end