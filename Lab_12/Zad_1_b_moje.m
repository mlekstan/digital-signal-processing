clear all; close all;

[x,cmap] = imread('cameraman.tif');

figure;
imshow(x,cmap), title(['cameraman.tif']);

% DCT 2D
DCT_a = dct2(x);
DCT_b = DCT_a;

%% a)
highpass = false;
[M,N] = size(x);

% Wartosci maski filtra LP w dziedzinie 2D-DCT
K = 64;
H = triangleMask(M,N,K);
% Wartosci maski filtra HP w dziedzinie 2D-DCT
if highpass
    H = ones(M,N) - H;
end

% filtracja
DCT_a = DCT_a .* H;

% idct
x_a_reconstr = idct2(DCT_a);

% plots
figure;
imshow(H);
text = "Maska filtra ";
if highpass
    text = text + "górnoprzepustowy";
else
    text = text + "dolnoprzepustowego";
end
title(text);

figure;
imshow(x_a_reconstr,cmap);
title("Obraz x zrekonstruowany a)");

%% b)
threshold = 100;
DCT_b(abs(DCT_b) < threshold) = 0;

% idct
x_b_rekonstr = idct2(DCT_b);
x_b_rekonstr = rescale(x_b_rekonstr);
figure;
imshow(x_b_rekonstr,cmap);
title("Obraz x zrekonstruowany b)");