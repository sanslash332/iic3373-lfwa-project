function x = omp(D, y, sparse_values)
%OMP Summary of this function goes here
%   Detailed explanation goes here

  if(size(y, 2) ~= 1)
    eror("y must be a column vector!")
  end

  valid = 1:size(D, 2);
  x = zeros(1, size(D, 2));

  for ii = 1:sparse_values
    dD = sqrt(sum((D(:, valid)-y).^2,1));
    [~, sorted] = sort(dD);
    index = valid(sorted(1));
    vector = D(:,index);
    eigen_val = sum(vector.*y)/norm(vector);
    x(index) = eigen_val;
    valid = valid([1:(index-1) (index+1):end]);
    y = y - eigen_val*vector;
  end

end

