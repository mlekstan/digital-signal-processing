close all; clear all;

[x,cmap] = imread('im1.png');

figure;
imshow(x,cmap), title('im1.png'); % wyświetla obraz oryginalny

DCT2 = dct2(x);  % DCT2 oryginalnego obrazu
[rows_num,columns_num] = size(DCT2); 

figure;
imshow(DCT2,cmap), title('im1.png - DCT2'); % wyświetlanie oryginalnego obrazu

IDCT2 = idct2(DCT2); % IDCT2 na wyniku transformacji DCT2

figure;
imshow(IDCT2,cmap), title('im1.png - IDCT2'); % odtyworzony obraz za pomocą IDCT2

DCT2_vector = DCT2(:);
DC_coefficient = DCT2_vector(1);
DCT2_vector = DCT2_vector(2:end);

fraction = 0.00001;
threshold = fraction * max(DCT2_vector);

significant_values_indexes = find(abs(DCT2_vector) > threshold); % indeksy wartości które przekraczają próg
num_significant_values = length(significant_values_indexes) % liczba wartości które przekroczyły próg (wartości znaczących)
half_num_significant_values = round(num_significant_values/2) % połowa liczby wartości znaczących
indexes_to_zero = significant_values_indexes(randperm(num_significant_values,half_num_significant_values)); % wybór randowmowych indeksów 

DCT2_vector(indexes_to_zero) = 0; % zerowanie wartości odpowiadajacych wylosowanym indeksom

DCT2_vector = [DC_coefficient; DCT2_vector];
DCT2_zeros = reshape(DCT2_vector,[rows_num,columns_num]);

figure;
imshow(DCT2_zeros,cmap), title('im1.png - DCT2 po zerowaniu');

IDCT2_zeros = idct2(DCT2_zeros);

figure;
imshow(IDCT2_zeros,cmap); title('im1.png - IDCT2 po zerowaniu');

figure;
subplot(1,2,1);
imshow(IDCT2,cmap), title('im1.png - IDCT2');
subplot(1,2,2); 
imshow(IDCT2_zeros,cmap), title('im1.png - IDCT2 po zerowaniu');













