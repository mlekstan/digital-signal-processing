% Dla dociekliwych: wygeneruj macierz kwadratową A za pomocą funkcji randn() dla N=20.
% Sprawdź ortonormalność jej wierszy (czy norma wierszy=1). Wyznacz macierz odwrotną S=inv(A).
% Sprawdź, czy AS==I ?, czyli czy sekwencja operacji y=Ax, xs=Sy posiada właściwość perfekcyjnej
% rekonstrukcji. Dokonaj analizy i syntezy dowolnego sygnału losowego jak powyżej oraz sprawdź czy
% xs==x? 

close all; clear all;

N = 20;

A = randn(N,N);

prod = ones(N,N);

for k = 1:N
    a = true;
    norma(k) = norm(A(k,:));
    if round(norma) == 1
        disp("Wiersz nr " + k + " jest znormalizowany");
    else
        disp("Wiersz nr " + k + " nie jest znormalizowany");
    end

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

S = inv(A);

I = S*A;

szumowy = randn(N,1);

z = A*szumowy; % analiza (z)
szumowy_r = S*z; % rekonstrukcja/synteza

figure;
plot(szumowy,'b-o');
hold on;
plot(szumowy_r,'r-x');



