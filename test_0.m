frecs = {[1, 1], [5, 3], [7, 7, 2, 2]};
sizes = {[10, 20], [10, 10], [20, 20]};
angles = {8, 8, 3};

index = 0;
for ii =1:length(frecs)
  f = frecs{ii};
  s = sizes{ii};
  a = angles{ii};
  for angle = 0:(a-1)
    ang = (pi*angle)/a; 
    index = index + 1;
    if length(f) == 2
      kernels{index} = haar_checker(f(1), f(2), s(1), s(2), ang, 0,0);
    elseif length(f) == 4
      kernels{index} = haar_wave(f(1), f(2), f(3), f(4), s(1), s(2), ang, 0,0);
    else
      error('myfuns:haar:InvalidInput', ...
        'Length of frecs{ii} must be 2 or 4.');
    end
  end 
end

disp("Apreta espacio para pasar a la siguiente.")
for ii=1:index
  imshow(kernels{ii})
  colorbar()
  pause;
end
disp("Listo.")
