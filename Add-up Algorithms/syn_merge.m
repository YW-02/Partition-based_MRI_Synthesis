clear
clc

% tumor = imresize(rgb2gray(imread('a0_syn_mo.png')), 0.25);
% rest = imresize(rgb2gray(imread('a0_syn_mr.png')), 0.25);

tumor = rgb2gray(imread('a0_syn_mo.png'));
rest = rgb2gray(imread('a0_syn_mr.png'));

% remove the adjacent black part
ttumor = rgb2gray(imread('a0_syn_mo.png'));
ttumor(ttumor < 100) = 0;
ind = find(ttumor ~= 0);
trest = rgb2gray(imread('a0_syn_mr.png'));
trest(ind) = 0;
trest(trest < 50) = 0;
temp = ttumor + trest;


% Read original
ao = imresize(imread('a0.png'), 4);

% Read mask
% at = imread('at.png');
% at(at > 0) = 255;

% Check that the images are the same size
% assert(all(size(tumor) == size(at)), 'Images must be the same size.');

% % Find the non-zero pixels in mask, and apply to synthetic rest
% mask_indices = find(at ~= 0);
% rest(mask_indices) = 0;
% syn_rest_indices = find(rest > 0);

% Find the non-zero pixels in mask, and apply to synthetic rest
rest(rest < 100) = 0;
syn_rest_indices = find(rest > 0);

% Find the non-zero pixels in synthetic tumor
tumor(tumor < 100) = 0;
syn_tumor_indices = find(tumor ~= 0);

% create the new mask
syn_mask = uint8(zeros(960, 960));
syn_mask(syn_tumor_indices) = 255;

% sandwidch
ao(syn_rest_indices) = rest(syn_rest_indices);
ao(syn_tumor_indices) = tumor(syn_tumor_indices);


figure
subplot(1, 3, 1), imshow(ao), title('Synthetic Image');
subplot(1, 3, 2), imshow(imgaussfilt(ao, 2)), title('Synthetic Image after Denoising');
subplot(1, 3, 3), imshow('a0.png'), title('Original Image');

figure
subplot(1, 3, 1), imshow(temp), title('Synthetic Image');
subplot(1, 3, 2), imshow(imgaussfilt(temp, 4)), title('Synthetic Image after Denoising');
subplot(1, 3, 3), imshow('a0.png'), title('Original Image');

%imwrite(imresize(imgaussfilt(ao, 2), 0.25), 'finalOutput.png');

%imwrite(imbinarize(imresize(syn_mask, 0.25)), 'finalMask.png');

% imwrite(imresize(imgaussfilt(ao, 1), 0.4), 'output1.png');
% imwrite(imresize(imgaussfilt(temp, 4), 0.4), 'output2.png');

% imwrite(ao, 'a0_synthetic.png');
