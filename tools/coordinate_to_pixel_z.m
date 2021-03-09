function int_output = coordinate_to_pixel_z(coordinate,channelSize,imageSize)
%COORDINATE_TO_PIXEL
%   Detailed explanation
%   1D

from_center = coordinate / (channelSize/2);

from_center_on_image = from_center * imageSize / 2;

output = imageSize/2 - from_center_on_image; % Coordinate systems are different on axis (hence the minus sign)

int_output = round(output);

if int_output == 0 % Specialfall...
    int_output = 1;
elseif int_output > imageSize
    int_output = imageSize;
end

end