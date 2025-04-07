% Wygeneruj macierz odwrotną (syntezy) S=IDCT do macierzy DCT z pkt. 1 (transponuj macierz A,
% czyli zamień wiersze na kolumny), sprawdź czy SA==I (macierz identycznościowa), a następnie
% mając A i S wykonaj analizę:
% X =A x'
% oraz rekonstrukcję (syntezę):
% xs =SX
% sygnału sygnału losowego (funkcja randn()), sprawdź czy transformacja posiada właściwość
% perfekcyjnej rekonstrukcji, (xs==x ?).

close all; clear all;

N = 20;

A = DCT_II(N);
SS = inv(A);
S = A.';

I = S*A;
II = SS*A;

x = randn(N,1); %[1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20];

X = A*x;
xs = S*X;

blad_rekonstr = abs(x-xs)

if isequal(x,xs) == true
    disp("Perfekcyjna rekonstrukcja");
end

