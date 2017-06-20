function prediction = predict_from_X(D, X, Y, persona)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

  unique_personas = unique(persona);
  prediction = zeros(size(X, 1), length(unique_personas));
  for p_i = 1:length(unique_personas)
    p = unique_personas(p_i);
    mask = p == persona;
    D_delta = D(:, mask);
    X_delta = X(:, mask);
    score = sqrt(sum((D_delta * X_delta' - Y).^2, 1));
    prediction(:, p_i) = score;
  end
  
  [~, order] = sort(prediction, 2);
  
  prediction = unique_personas(unique_personas(order(:,1)));

end

