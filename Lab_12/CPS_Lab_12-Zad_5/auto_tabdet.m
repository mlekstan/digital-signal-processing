close all; clear all;

%% tu wkleiæ czêœæ kodu z zadania 3,lub obraz wynikowy obraz wynikowy z zadania 3
B1 = ; % obraz wynikowy z zadania 3: I3,Ican,Isob lub B1

%% 5a tutaj powinien znaleŸæ siê algorytm automatycznej detekcji tablicy,
% szkielet algorytmu:

% etykietowanie elementów obrazu binarnego
[L, num] = bwlabel(B1, 4); % etykietowanie elementów obrazu binarnego
imshow(L,[]); 
labelsnr = unique(L); % licza elementów obrazu binarnego
wece = []; % wektor cech

for i =1:length(labelsnr)
    labelsnr(i)
    B2 = zeros(size(B1));
    B2(L==labelsnr(i)) = 1;
    imshow(B2,[]);title('B2 - element o etykiecie nr i')
    pause
    BWprops  = regionprops(B2,  ); % wyznaczanie cechy (OKREŒLIÆ jakiej) elementu obrazu z i - t¹ etykiet¹
    wece = [wece BWprops. ]; % uzupe³nienie wektora cech o wartoœæ cechy elementu obrazu z i - t¹ etykiet¹
end

% SFORMU£UJ kryterium indetyfikacji danego elementu obrazu jako tablica
% rejestracyjna

B2 = zeros(size(B1));
B2(L==labelsnr(i)) = 14 ;



% wymno¿enie maski tablicy rejestracyjnej z oryginalnym obrazem
I2 = B2.*I1;
% wyciêcie ramki w której mieœci siê tablica + ewentualna obróbka
 

% usuniêcie liter z tablicy rejestracyjnej 
imcontrast  
lt =   ;      % dolny prog binaryzacji
ut =   ;     % gorny prog binaryzacji

I2(I2>lt&I2<ut)) =  ; % przypisanie piskelom liter wartoœci piksela z jasnej czêsci tablicy