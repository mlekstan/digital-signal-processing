clear all;
close all;

%% 1.
img = imread('im1.png'); % wczytaj obraz
img_dct2 = dct2(img);    % wyznacz dct2

% wyswietl obraz oryginalny
figure;
subplot(1,3,1);
imagesc(img);
set(gca,'DataAspectRatio',[1 1 1]);
title('Przed DCT2');

% petla szukajaca wspolczynnikow znaczacych
for i = 1:length(img_dct2)
    for j = 1:length(img_dct2)
        if(img_dct2(i,j)>10)
            fprintf('Wspolczynnik znaczacy: %d %d', i, j);
            fprintf('\n');
        end
    end
end

subplot(1,3,2);
imagesc(idct2(img_dct2));
set(gca,'DataAspectRatio',[1 1 1]);
title('Po IDCT2 bez zerowania');

% zerowanie polowy znaczacych wspolczynnikow (jeden wspolczynnik??)
img_dct2(1,12) = 0; 
img_new = idct2(img_dct2);
subplot(1,3,3);
imagesc(img_new);
set(gca,'DataAspectRatio',[1 1 1]);
title('Po wyzerowaniu wspol. zn.');

%% 2.
% wczytanie i wyswietlenie obrazu
img2 = imread('cameraman.tif');
figure;
subplot(1,3,1);
imshow(img2);
title('Obraz oryginalny');

img2_dct2a = dct2(img2);
img2_dct2 = dct2(img2);

% 2a
% wyzerowanie czestotliwosci
K = 64; H = zeros(256,256); H(1:K,1:K) = ones(K,K); % maska czêstotliwoœciowa, lewy górny róg
img2_dct2a = img2_dct2a.*H; % iloczyn widma DCT i maski

subplot(1,3,2);
imagesc(idct2(img2_dct2a));
set(gca,'DataAspectRatio',[1 1 1]);
title('Wyzerowanie wysokich czêstotliwoœci');

% 2b
pom = 0;
prog = 30;
for i = 1:length(img2_dct2)
    for j = 1:length(img2_dct2)
        if(abs(img2_dct2(i,j))<prog)
            img2_dct2(i,j) = 0;
        else
            pom = pom + 1;
        end
    end
end

fprintf('W DCT2 cameraman.tif z zadanym progiem pozostawiono %d wspolczynnikow', pom);
fprintf('\n');

subplot(1,3,3);
imagesc(idct2(img2_dct2));
set(gca,'DataAspectRatio',[1 1 1]);
title(['Tylko wspolczynniki od progu: ' num2str(prog)]);

%% 3
% obrazy bazowe
IM1=zeros(128,128);
IM1(2,10)=1;
im1=idct2(IM1);

IM2=zeros(128,128);
IM2(50,15)=1;
im2=idct2(IM2);

IM3=zeros(128,128);
IM3(80,4)=1;
im3=idct2(IM3);

IM4=zeros(128,128);
IM4(12,60)=1;
im4=idct2(IM4);

IM5=zeros(128,128);
IM5(90,100)=1;
im5=idct2(IM5);

% generujemy nowy obrazek 128x128
im=im1+im2+im3+im4+im5;

figure;
subplot(1,6,1);
imagesc(im1); title('im1');
subplot(1,6,2);
imagesc(im2); title('im2');
subplot(1,6,3);
imagesc(im3); title('im3');
subplot(1,6,4);
imagesc(im4); title('im4');
subplot(1,6,5);
imagesc(im5); title('im5');
subplot(1,6,6);
imagesc(im); title('im - suma 1:5');

% analiza obrazu sumarycznego
IM = dct2(im);
figure;
subplot(1,2,1);
imagesc(IM); title('DCT2 obrazu sumarycznego');

% szukamy wspolrzednych 3-5 pikselow aby je potem moc wyzerowac
for i = 1:length(IM)
    for j = 1:length(IM)
        if(abs(IM(i,j))>0.99)
            fprintf('Zapalony piksel w: %d %d', i, j);
            fprintf('\n');
        end
    end
end

% zostawiamy tylko jeden zapalony wspolczynnik
IM(2,10) = 0;
IM(50,15) = 0;
IM(80,4) = 0;
IM(90,100) = 0;

im_cut = idct2(IM);
subplot(1,2,2);
imagesc(im_cut); title('DCT2 obrazu sum. - wyzerowane wsp.');

%% 4.
img3 = imread('im2.png'); % wczytaj obraz
img_dct3 = dct2(img3);    % wyznacz dct2
figure;
imagesc(img_dct3);

% dct to operacja ortogonalna
% macierz jednostkowa w transponowaniu daje macierz jednostkowa
% iloczyn macierzy jednostkowej i transponowanej macierzy jednostkowej,
% daje macierz jednostkowa
