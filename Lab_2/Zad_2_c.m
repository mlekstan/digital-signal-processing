% „Zepsute" DCT: wygeneruj macierz A dla DCT, podstawiając niepoprawne indeksy (wartości)
% częstotliwości, np. zastąp „k" przez „k+0.25" (wzór w pkt. 1). Sprawdź ortogonalność tej macierzy,
% sprawdź wynik analizy oraz perfekcyjną rekonstrukcję na sygnale szumowym i harmonicznym.

close all; clear all;

N = 20;

A = DCT_II_demaged(N)

for k = 1:N
    a = true;
    for m = 1:N
        b = A(k,:) .* A(m,:);
        prod(k,m) = sum(b);
            
        if (m ~= k) && (round(prod(k,m)) ~= 0)
            a = false;
            disp("Wiersz nr " + k + " nie jest ortogonalny z pozostałymi wierszami");
            break; 
        end
    end
    if a == true;
        disp("Wiersz nr " + k + " jest ortogonalny z pozostałymi wierszami");
    end
end

f1 = 1;
f2 = 5;
fs = 50;
Ts = 1/fs;

ts = 0:Ts:Ts*(N-1);
harmoniczny = sin(2*pi*f1*ts.') + cos(2*pi*f2*ts.');

y = A*harmoniczny; % analiza (y)
harmoniczny_r = inv(A)*y; % rekonstrukcja/synteza

figure;
plot(ts,harmoniczny,'b-o');
hold on;
plot(ts,harmoniczny_r,'r-x');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

szumowy = randn(N,1);

z = A*szumowy; % analiza (z)
szumowy_r = inv(A)*z; % rekonstrukcja/synteza

figure;
plot(ts,szumowy,'b-o')
hold on;
plot(ts,szumowy_r,'r-x')




