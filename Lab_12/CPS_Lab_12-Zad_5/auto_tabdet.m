close all; clear all;

%% tu wklei� cz�� kodu z zadania 3,lub obraz wynikowy obraz wynikowy z zadania 3
B1 = ; % obraz wynikowy z zadania 3: I3,Ican,Isob lub B1

%% 5a tutaj powinien znale�� si� algorytm automatycznej detekcji tablicy,
% szkielet algorytmu:

% etykietowanie element�w obrazu binarnego
[L, num] = bwlabel(B1, 4); % etykietowanie element�w obrazu binarnego
imshow(L,[]); 
labelsnr = unique(L); % licza element�w obrazu binarnego
wece = []; % wektor cech

for i =1:length(labelsnr)
    labelsnr(i)
    B2 = zeros(size(B1));
    B2(L==labelsnr(i)) = 1;
    imshow(B2,[]);title('B2 - element o etykiecie nr i')
    pause
    BWprops  = regionprops(B2,  ); % wyznaczanie cechy (OKRE�LI� jakiej) elementu obrazu z i - t� etykiet�
    wece = [wece BWprops. ]; % uzupe�nienie wektora cech o warto�� cechy elementu obrazu z i - t� etykiet�
end

% SFORMU�UJ kryterium indetyfikacji danego elementu obrazu jako tablica
% rejestracyjna

B2 = zeros(size(B1));
B2(L==labelsnr(i)) = 14 ;



% wymno�enie maski tablicy rejestracyjnej z oryginalnym obrazem
I2 = B2.*I1;
% wyci�cie ramki w kt�rej mie�ci si� tablica + ewentualna obr�bka
 

% usuni�cie liter z tablicy rejestracyjnej 
imcontrast  
lt =   ;      % dolny prog binaryzacji
ut =   ;     % gorny prog binaryzacji

I2(I2>lt&I2<ut)) =  ; % przypisanie piskelom liter warto�ci piksela z jasnej cz�sci tablicy