
clear all; close all;

% Wczytanie obrazu
[x, cmap] = imread('im1.png');
figure;
imshow(x, cmap), title('im1.png');

% Przeprowadzenie DCT2 na obrazie
dct2_image = dct2(double(x));

% Wyświetlenie wyników DCT2
figure;
imagesc(log(abs(dct2_image))), colormap(jet), colorbar, title('im1.png - DCT2');

% Przekształcenie DCT2 na wektor i pominięcie współczynnika DC
dct2_vector = dct2_image(:);
dc_coefficient = dct2_vector(1);
dct2_vector(1) = []; % Pomijamy współczynnik DC

% Wyznaczenie progu dla znaczących współczynników
fraction = 0.001;
threshold = fraction * max(abs(dct2_vector));

% Znalezienie znaczących współczynników
significant_indices = find(abs(dct2_vector) > threshold);
num_significant = length(significant_indices);

% Wyzerowanie połowy znaczących współczynników
num_to_zero = round(num_significant / 2);
indices_to_zero = significant_indices(randperm(num_significant, num_to_zero));
dct2_vector(indices_to_zero) = 0;

% Przywrócenie współczynnika DC i rekonstrukcja macierzy DCT2
dct2_vector = [dc_coefficient; dct2_vector];
dct2_image_modified = reshape(dct2_vector, size(dct2_image));

% Wyświetlenie wyników DCT2 po wyzerowaniu współczynników
figure;
imagesc(log(abs(dct2_image_modified))), colormap(jet), colorbar, title('im1.png - DCT2 po zerowaniu');

% Rekonstrukcja obrazu po modyfikacji współczynników DCT2
idct2_image = idct2(dct2_image_modified);

% Wyświetlenie obrazu po odwrotnej DCT2
figure;
imshow(uint8(idct2_image), cmap), title('im1.png - IDCT2 po zerowaniu DCT2');

% Porównanie obrazów oryginalnego i po kompresji
figure;
subplot(1, 2, 1);
imshow(x, cmap), title('Oryginalny obraz');
subplot(1, 2, 2);
imshow(uint8(idct2_image), cmap), title('Obraz po kompresji (IDCT2)');
