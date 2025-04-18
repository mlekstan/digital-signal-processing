close all; clear all;

% wczytanie obrazu
I = imread('car1.jpg');
% ---- ewentualne przejście do skali szarości
I1 =  double(rgb2gray(I));
figure;
imshow(I1,[]);
title('I1 - bazowy')

% filtracja wstępna:
% generowanie maski filtru Gaussa
hsize = 128;
sigma = 2;
h = fspecial('gaussian', hsize, sigma);

I2 = imfilter(I1, h);
figure;
imshow(I2,[]);
title('I2 - po filtracji wstępnej');
% kwantyzacja po filtracji [0 255]
I2 = quant(I2,1);

% -----  dobór progu ------
imcontrast  

lt =  70;      % dolny prog binaryzacji
ut =  87;     % gorny prog binaryzacji

% ----- binaryzacja -------
B1 = I2; 
B1(B1<lt)=0; % usunięcie pikseli o wartościach mniejszych od lt 
B1(B1>ut)=0; % usunięcie pikseli o wartościach większych od ut 
B1(B1>0) = 1; % przypisanie pozostałym o wartościom 1
figure;
imshow(B1,[]);
title('B1 - po binaryzacji');

% -- operacje morfologiczne (kolejność i liczba iteracji do wyboru):
B1 = bwmorph(B1,'dilate',1);figure;imshow(B1,[]);title('B1 - po operacji morfologicznej dylatacji')
% B1 = bwmorph(B1,'erode',1);figure;imshow(B1,[]);title('B1 - po operacji morfologicznej erozji')
%B1 = imfill(B1,26,'holes');figure;imshow(B1,[]);title('B1 - po operacji morfologicznej wypełanienia')
% B1 = bwareaopen(B1,  ); figure;imshow(B1,[]);title('B1 - po operacji morfologicznej usunięcia elementów o powierzchni mniejszej niż X pikseli')

% -- detekcja krawędzi (kolejność i liczba iteracji do wyboru):

I_sobel = edge(B1,'sobel');
figure;
imshow(I_sobel,[]);
title('Detekcja krawędzi filtrem Sobela')

h = fspecial('prewitt');
I_prewitt = filter2(h, B1);
figure;
imshow(I_prewitt,[]);
title('Detekcja krawędzi filtrem Prewitta')

I_canny = edge(B1,'canny');
figure; imshow(I_canny,[]);
title('Detekcja krawędzi filtrem Cannego')