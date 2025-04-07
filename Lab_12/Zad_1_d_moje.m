clear all; close all;

% wczytaj obraz
image = imread('im2.png');
image = double(image);
image = rescale(image);

% wyświelt
figure;
imshow(image);

% dct2
image_dct2 = dct2(image);
figure;
imshow(image_dct2);

