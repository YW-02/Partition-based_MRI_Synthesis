clear
clc
close all

% 设置图像尺寸
img_size = 240;

% 创建一个空图像
img = zeros(img_size, img_size);

% 整个大脑的mask
a0 = imread("a0.png");
temp = a0;
a0(a0>0) = 255;
overallmask = imbinarize(a0);
rest = imread("a0_maskremoved.png");

% 肿瘤mask
a0m = imread("a0_maskonly.png");
a0m(a0m>0) = 255;
tumormask = imbinarize(a0m);

% 腐蚀强度
se=strel('square', 4);


% 定义4个点集，每个点集包含若干像素点
% 这里简单地生成一些随机点集，可以根据需要更改这些点的定义
%points_set1 = [randi([50, 70], 50, 1), randi([50, 70], 50, 1)];
%points_set2 = [randi([170, 190], 50, 1), randi([50, 70], 50, 1)];
%points_set3 = [randi([50, 70], 50, 1), randi([170, 190], 50, 1)];
%points_set4 = [randi([170, 190], 50, 1), randi([170, 190], 50, 1)];

% 将点集的点标记在图像上
%for i = 1:length(points_set1)
%    img(points_set1(i, 1), points_set1(i, 2)) = 1;
%end
%for i = 1:length(points_set2)
%    img(points_set2(i, 1), points_set2(i, 2)) = 2;
%end
%for i = 1:length(points_set3)
%    img(points_set3(i, 1), points_set3(i, 2)) = 3;
%end
%for i = 1:length(points_set4)
%    img(points_set4(i, 1), points_set4(i, 2)) = 4;
%end

% 读取4个灰阶分区，二值化，腐蚀
part1 = imread("a0_range_0_49.png");
part1(part1>0) = 255;
part1e = imerode(imbinarize(part1), se);
imwrite(part1e, 'p1e.png');
img(part1e>0) = 1;
part2 = imread("a0_range_50_99.png");
part2(part2>0) = 255;
part2e = imerode(imbinarize(part2), se);
imwrite(part2e, 'p2e.png');
img(part2e>0) = 2;
part3 = imread("a0_range_100_149.png");
part3(part3>0) = 255;
part3e = imerode(imbinarize(part3), se);
imwrite(part3e, 'p3e.png');
img(part3e>0) = 3;
part4 = imread("a0_range_150_255.png");
part4(part4>0) = 255;
part4e = imerode(imbinarize(part4), se);
imwrite(part4e, 'p4e.png');
img(part4e>0) = 4;

% 使用bwdist计算每个像素到最近点集的距离
dist1 = bwdist(img == 1);
dist2 = bwdist(img == 2);
dist3 = bwdist(img == 3);
dist4 = bwdist(img == 4);

% 创建一个空的标签图像
label_img = zeros(img_size, img_size);

% 对每个像素进行赋值，根据最小距离的点集来确定标签
for i = 1:img_size
    for j = 1:img_size
        [~, idx] = min([dist1(i,j), dist2(i,j), dist3(i,j), dist4(i,j)]);
        label_img(i, j) = idx;
    end
end

% 去除头骨之外和肿瘤的区域
label_img(overallmask == 0) = 0;
label_img(tumormask > 0) = 0;

% 可视化结果
figure;
imshow(label_img, []);

A = [0 0 0; 0.25 0.25 0.25; 0.5 0.5 0.5; 0.75 0.75 0.75; 1 1 1];
colormap(A);
c = colorbar;
set(c,'Ticks',0.4:0.8:3.6,'TickLabels',{'0','1','2','3','4'});
title('MRI Partition Results');

figure;
imshow(im2double(rest)*0.5 + label_img*0.12);

% 分区结果保存
imwrite(label_img*0.25, 'a0_division.png');

% 提取每一层分区对应的MRI
partition1 = rest;
partition1(label_img ~= 1) = 0;
partition2 = rest;
partition2(label_img ~= 2) = 0;
partition3 = rest;
partition3(label_img ~= 3) = 0;
partition4 = rest;
partition4(label_img ~= 4) = 0;

imwrite(partition1, 'a0_p1.png');
imwrite(partition2, 'a0_p2.png');
imwrite(partition3, 'a0_p3.png');
imwrite(partition4, 'a0_p4.png');

% 提取每一层分区对应的mask
partition1(partition1 ~= 0) = 255;
partition2(partition2 ~= 0) = 255;
partition3(partition3 ~= 0) = 255;
partition4(partition4 ~= 0) = 255;

imwrite(partition1, 'msk_p1.png');
imwrite(partition2, 'msk_p2.png');
imwrite(partition3, 'msk_p3.png');
imwrite(partition4, 'msk_p4.png');

% tumor mask
tumor = imread('a0_maskonly.png');
tumor(tumor > 0) = 255;
imwrite(tumor, 'tumor_mask.png');