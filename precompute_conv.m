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
%% @deftypefn {Function File} {@var{retval} =} haar_matrices (@var{input1}, @var{input2})
%%
%% @seealso{}
%% @end deftypefn

%% Author: jabozzo <jabozzo@coalpowered>
%% Created: 2017-05-25

function result = precompute_conv(img_size, varargin)

  max_size = [0,0];
  for ii = 1:length(varargin)
    img = varargin{ii};
    max_size = max(max_size , size(img));
  end
  
  target_size = img_size + max_size;
  
  result = cell(length(varargin), 1);
  for ii = 1:length(varargin)
    img = varargin{ii};
    img = [img; zeros(target_size(1) - size(img, 1),   size(img, 2))];
    img = [img, zeros(target_size(1), target_size(2) - size(img, 2))];
    result{ii} = fft2(img);
  end

end
