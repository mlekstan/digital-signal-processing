clear all; close all;


% generacja obrazów bazowych
IM1 = zeros(128, 128);
IM1(2, 10) = 1;
im1 = idct2(IM1);

IM2 = zeros(128, 128);
IM2(5, 20) = 1;
im2 = idct2(IM2);

IM3 = zeros(128, 128);
IM3(50, 50) = 1;
im3 = idct2(IM3);

IM4 = zeros(128, 128);
IM4(103, 82) = 1;
im4 = idct2(IM4);

figure;
subplot(2,2,1);
imshow(IM1);
title("IM1");
subplot(2,2,2);
imshow(rescale(im1));
title("im1");

subplot(2,2,3);
imshow(IM2);
title("IM2");
subplot(2,2,4);
imshow(rescale(im2));
title("im2");

figure;
subplot(2,2,1);
imshow(IM3);
title("IM3");
subplot(2,2,2);
imshow(rescale(im3));
title("im3");

subplot(2,2,3);
imshow(IM4);
title("IM4");
subplot(2,2,4);
imshow(rescale(im4));
title("im4");

% suma obrazów bazowych
im = im1 + im2 + im3 + im4;
IM = dct2(im);

figure;
subplot(2, 1, 1)
imshow(rescale(im));
title("im - suma(im1+im2+...)");
subplot(2, 1, 2);
imshow(IM);
title("IM - dct2(im)");

% wyłaczanie pikseli
IM(2, 10) = 0;
IM(5, 20) = 0;
% IM(50, 50) = 0;
IM(103, 82) = 0;

im_ = idct2(IM);

figure;
subplot(2, 1, 1)
imshow(rescale(im_));
title("im_ - wyłaczone piksele");
subplot(2, 1, 2);
imshow(IM);
title("IM - wyłaczone piksele");