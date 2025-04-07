clc; clear all; close all;

% wczytywanie obrazu
[image, cmap] = imread("lena512.png");

% filtry w częstotliwości
[M, N] = size(image);
K = 128;
H_LP = triangleMask(M, N, K);

K = 128;
H_HP = ones(M, N) - triangleMask(M, N, K);

figure;
subplot(2,1,1);
imshow(H_LP);
title("Maska LP");
subplot(2,1,2);
imshow(H_HP);
title("Maska HP");

% odpowiedzi inpulsowe filtrów
N = 32;
window = blackman(32);
h_LP = abs(fwind1(H_LP, window)); % fwind wylicza odpowiedź impulsową z odwrotnej transformaty fouriera przeprowdzonej na H. Tak wyliczona odpowiedź jest mnozona przez okno
h_HP = abs(fwind1(H_HP, window));

H_LP = dct2(h_LP); % odpowiedź częstotliwościowa filtra po wcześniejszym zastosowaniu okna na odpowiedzi impulsowej
H_HP = dct2(h_HP);

figure;
subplot(2,2,1);
imshow(h_LP, cmap);
title("h - LP");
subplot(2,2,2);
imshow(h_HP, cmap);
title("h - HP");

subplot(2,2,3);
imshow(H_LP, cmap);
title("H - LP");
subplot(2,2,4);
imshow(H_HP, cmap);
title("H - HP");

% filtracja
image_LP  = filter2(h_LP, image);
image_HP= filter2(h_HP, image);
IMAGE_LP  = dct2(image_LP); % charakterystyka czestotliwościowa obrazu po filtracji LP
IMAGE_HP = dct2(image_HP); % charakterystyka częstotliwościowa obrazu po filtracji HP
IMAGE = dct2(image); % charakterystyka częstotliwościowa oryginalnego obrazu

figure;
subplot(2,3,1);
imshow(image, cmap);
title("Obraz oryginalny");

subplot(2,3,2);
imshow(image_LP, cmap);
title("Obraz po filtracji LP");

subplot(2,3,3);
imshow(image_HP, cmap);
title("Obraz po filtracji HP");

subplot(2,3,4);
imshow(IMAGE);
title("DCT2 obrazu oryginalnego");

subplot(2,3,5);
imshow(IMAGE_LP);
title("DCT2 obrazu po filtracji LP");

subplot(2,3,6);
imshow(IMAGE_HP);
title("DCT2 obrazu po filtracji HP");


%% b) (Gauss)
hsize = 32;
sigma = 5;
h = fspecial('gaussian', hsize, sigma);

image_gauss = filter2(h, image);
IMAGE_GAUSS = dct2(image_gauss);

figure;
subplot(221);
imshow(image, cmap);
title("Obraz oryginalny");

subplot(222);
imshow(image_gauss, cmap);
title("Obraz po filtracji LP (Gauss)");

subplot(223);
imshow(IMAGE);
title("DCT2 obrazu oryginalnego");

subplot(224);
imshow(IMAGE_GAUSS);
title("DCT2 obrazu po filtracji LP (Gauss)");