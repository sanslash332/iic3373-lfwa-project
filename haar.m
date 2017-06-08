%% Copyright (C) 2017 jabozzo
%% 
%% This program is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 3 of the License, or
%% (at your option) any later version.
%% 
%% This program is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU General Public License for more details.
%% 
%% You should have received a copy of the GNU General Public License
%% along with this program.  If not, see <http://www.gnu.org/licenses/>.

%% -*- texinfo -*- 
%% @deftypefn {Function File} {@var{retval} =} haar (@var{input1}, @var{input2})
%%
%% @seealso{}
%% @end deftypefn

%% Author: jabozzo <jabozzo@coalpowered>
%% Created: 2017-05-25

function results = haar (imgs, frecs, sizes, angles)

  if length(frecs) ~= length(sizes) || length(sizes) ~= length(angles)
   error('myfuns:haar:InputUnmatch', ...
        'Length of frecs, sizes and angles must agree.');
  end

  index = 0;
  kernel_len = 0;
  for a =1:length(angles)
    kernel_len = kernel_len + a;
  end
  kernels = cell(kernel_len,1);
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
  
  kernels = precompute_conv(size(imgs{1}), kernels{:}); 
  results = compute_conv(kernels, imgs{:});

end
