clear all; close all;

[x,cmap] = imread('im1.png');

figure;
imshow(x,cmap), title('im1.png'); % wyświetlenie oryginalenego obrazu

DCT2 = dct2(x); % transformacja DCT2 na oryginalnym obrazie
[rows_num,columns_num] = size(DCT2); % liczba wierszy i kolumn obrazu po transformacji DCT2

figure;
imshow(DCT2,cmap), title('im1.png - DCT2'); % wyświetlenie wyniku transformacji DCT2 na oryginalnym obrazie

IDCT2 = idct2(DCT2); % odwrotna transformacja DCT2 -> odtwarzamy obraz na podstwie współczynników czestotliwościowych

figure;
imshow(IDCT2,cmap), title('im1.png - IDCT2'); % wyświetlenie wyniku odwrotnej transformacji DCT2

DCT2_trans = DCT2.'; % transpozycja DCT2
DCT2_vector = DCT2_trans(:); % zapis wyniku transformacji DCT2 do wektora


fraction = 0.0001;
threshold = fraction * max(DCT2_vector(2:end)); % próg wyliczany na podstawie ułamka maksymalnej wartości w macierzy DCT2
DCT2_zeros = zeros(rows_num,columns_num);

p = 0; k = 0; s = 0;
for i=2:length(DCT2_vector)
    if (abs(DCT2_vector(i)) > threshold && p == 0)
        DCT2_vector(i) = 0;
        p = p + 1;
        k = k + 1;
        s = s + 1;
    elseif (abs(DCT2_vector(i)) > threshold && p ~= 0)
        p = 0;
        s = s + 1; 
    end
    
    rem = mod(i,128);
    if (rem == 0)
        DCT2_zeros(i/columns_num,:) = DCT2_vector((i-columns_num)+1:i);
    end
end

figure;
imshow(DCT2_zeros,cmap); title('im1.png - DCT2 po zerowaniu');

IDCT2_zeros = idct2(DCT2_zeros);

figure;
imshow(IDCT2_zeros,cmap); title('im1.png - IDCT2 po zerowaniu DCT2');










