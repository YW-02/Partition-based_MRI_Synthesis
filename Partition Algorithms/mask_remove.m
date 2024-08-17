% Read in the two grayscale PNG images
a0 = imread('a0.png');
at = imread('at.png');

% Check that the images are the same size
assert(all(size(a0) == size(at)), 'Images must be the same size.');

% Find the non-zero pixels in at
nonzero_indices = find(at ~= 0);

% Set the corresponding pixels in a0 to 0
a0(nonzero_indices) = 0;

% Save the modified image as a new PNG file
imwrite(a0, 'a0_maskremoved.png');