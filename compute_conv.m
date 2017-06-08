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
%% @deftypefn {Function File} {@var{retval} =} compute_conv (@var{input1}, @var{input2})
%%
%% @seealso{}
%% @end deftypefn

%% Author: jabozzo <jabozzo@coalpowered>
%% Created: 2017-05-25

function result = compute_conv (precomputed, varargin)

index = 0;
for ii = 1:length(varargin)
  img = varargin{ii};
  
  img = [img; zeros(size(precomputed{1},1) - size(img,1), size(img,2))];
  img = [img, zeros(size(precomputed{1},1), size(precomputed{1},2) - size(img,2))];
  
  ft_img = fft2(img);
  
  for jj = 1:length(precomputed)
    index = index + 1;
    img_r = real(ifft2(precomputed{jj}.*ft_img));
    result{index} = img_r;
  end
end
 
end
