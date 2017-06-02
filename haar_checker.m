% ## Copyright (C) 2017 jabozzo
% ## 
% ## This program is free software; you can redistribute it and/or modify it
% ## under the terms of the GNU General Public License as published by
% ## the Free Software Foundation; either version 3 of the License, or
% ## (at your option) any later version.
% ## 
% ## This program is distributed in the hope that it will be useful,
% ## but WITHOUT ANY WARRANTY; without even the implied warranty of
% ## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% ## GNU General Public License for more details.
% ## 
% ## You should have received a copy of the GNU General Public License
% ## along with this program.  If not, see <http://www.gnu.org/licenses/>.
% 
% ## -*- texinfo -*- 
% ## @deftypefn {Function File} {@var{retval} =} haar_wave (@var{input1}, @var{input2})
% ##
% ## @seealso{}
% ## @end deftypefn
% 
% ## Author: jabozzo <jabozzo@coalpowered>
% ## Created: 2017-05-25

function intensity = haar_checker (frec_x, frec_y, width_x, width_y, angle, offset_x, offset_y)

% Check number of inputs.
if nargin > 7
    error('myfuns:haar_checker:TooManyInputs', ...
        'requires at most 7 inputs');
end

% Fill in unset optional values.
if nargin < 5
  angle = 0;
end

if nargin < 6
  offset_x = 0;
end

if nargin < 7
  offset_y = 0;
end


angle = mod(angle, 2*pi);
rot_mat = [cos(angle) sin(angle); -sin(angle) cos(angle)];
rad_x = width_x*0.5;
rad_y = width_y*0.5;
dim_s = rot_mat*[width_x -width_x width_x -width_x; width_y width_y -width_y -width_y];
dim_s = max(dim_s, [], 2);

dim_x = round(dim_s(1)+1);
dim_y = round(dim_s(2)+1);

dx = rot_mat * [1;0];
dy = rot_mat * [0;1];

x = (0:dim_x-1) - (dim_x - 1)*0.5;
y = (0:dim_y-1) - (dim_y - 1)*0.5;
[X,Y] = meshgrid(x, y);

X_r = X*rot_mat(1,1) + Y*rot_mat(1,2);
Y_r = X*rot_mat(2,1) + Y*rot_mat(2,2);

mask  = (X_r < -rad_x | X_r > rad_x) ;
mask  = mask |( Y_r < -rad_y | Y_r > rad_y);

X_int = mod(X_r + offset_x*frec_x, frec_x) > frec_x*0.5;
Y_int = mod(Y_r + offset_y*frec_y, frec_y) > frec_y*0.5;

intensity = xor(X_int, Y_int);
intensity(mask) = 0;

end
