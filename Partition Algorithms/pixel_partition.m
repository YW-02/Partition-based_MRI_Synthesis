clear
clc

% Read in the grayscale PNG image
a0_modified = imread('a0_maskremoved.png');

% Set up the range limits for each of the 4 images
ranges = [0 49; 50 99; 100 149; 150 255];

% Loop through the ranges and generate a new image for each one
for i = 1:size(ranges, 1)
    % Create a logical mask for the pixels in the current range
    mask = (a0_modified >= ranges(i, 1)) & (a0_modified <= ranges(i, 2));
    
    % Apply the mask to the original image to get the new image
    new_image = uint8(mask) .* a0_modified;
    
    % Save the new image as a PNG file
    imwrite(new_image, sprintf('a0_range_%d_%d.png', ranges(i, 1), ranges(i, 2)));
end