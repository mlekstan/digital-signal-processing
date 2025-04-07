close all; clear all;

[x, fs] = audioread('DontWorryBeHappy.wav');
fs
x = double(x);
x = x(:, 1);
N = 32;
Q = 3;

[symbols, bps] = koder_MDCT(x,N,Q);
kbpsec = bps*fs/1000
y = dekoder_MDCT(symbols,N,Q);

% Błąd
    max_error = max(abs(x - y))
    mean_error = mean(abs(x - y))

% Wykresy
    n = 1:length(x);

    figure;
    hold all;
    plot(n, x)
    plot(n, y);
    title(['Sygnał oryginalny vs po odkodowaniu z MDCT dla N=', num2str(N)]);
    legend('Referencyjny', 'Zrekonstruowany')


sound(x,fs);
pause();
sound(y,fs);


function [symbols,bps] = koder_MDCT(x,N,Q)
    % Koder transformatowy
    %
    % [symblos,bps] = koder(x, N, Q)
    % x – sygnał wejściowy
    %
    % N – długość bloku próbek dla transformaty MDCT
    % Q – współczynniki skalujące (jeden wspólny lub wektor indywidualnych współczynników)
    % symbols – tablica zakodowanych symboli
    % bps – średnia liczba bitów zakodowanych danych na próbkę sygnału wejściowego
    
    H = N/2;                        % przesunięcia kolejnych bloków
    M = floor((length(x)-H)/H);      % liczba bloków
    symbols = zeros(H,M);               % tablica symboli danych zakodowanych
    window = sin(pi*((0:(N-1))+0.5)/N)'; % okienko do transformaty MDCT
    
    h_wbar = waitbar(0,'Przetwarzanie ramek', 'Name', 'Kodowanie transformatowe');
    for m = 0:M-1
        waitbar(m/M,h_wbar);
        n0 = m*H + 1;               % początek bloku
        x0 = x(n0:n0+N-1);          % pobieranie bloku próbek
        x0 = x0.*window;               % okienkowanie
        A = macierz_analizy_MDCT(N);    % obliczenie macierzy analizy MDCT
        Fk = A*x0;
        Fkq = fix(Fk.*Q);           % kwantowanie współczynników
        symbols(:,m+1) = Fkq;           % zapisanie do tablicy symboli
    end
    close(h_wbar);
    
    % Oszacowanie wielkości strumienia danych
    zakr = (max(symbols')-min(symbols'))'  % zakresy zmienności symboli
    koszt = max(0,ceil(log2(zakr))) % szacunkowy koszt zakodowania symboli
    bps = mean(koszt)              % średnia liczba bitów na próbkę
end

function y = dekoder_MDCT(symbols,N,Q)
    % Dekoder transformatowy
    % y = dekoder(symbols, N, Q)
    %
    % symbols – tablica zakodowanych symboli
    % N – długość bloku próbek dla transformaty MDCT
    % Q – współczynniki skalujące (jeden wspólny lub wektor indywidualnych współczynników)
    % y – sygnał odtworzony
    
    H = N/2;                        % przesunięcia kolejnych bloków
    M = size(symbols,2);                % liczba bloków
    L = H * (M+1);                  % szacowana długość sygnału zdekodowanego
    y = zeros(L,1);                 % miejsce na próbki sygnału
    window = sin(pi*((0:(N-1))+0.5)/N)'; % okienko do transformaty MDCT
    
    h_wbar = waitbar(0,'Dekodowanie ramek', 'Name', 'Kodowanie transformatowe');
    for m = 0:M-1
        waitbar(m/M,h_wbar);
        Fkq = symbols(:,m+1);           % odczytanie kolejnego wektora symboli
        Fkr = Fkq./Q;               % odtworzenie współczynników transformaty
        S = macierz_analizy_MDCT(N)';    % macierz syntezy MDCT
        y0 = S*Fkr;                  % synteza 
        %y0 = idct4(Fkr);            % obliczenie odwrotnej transformaty
        y0 = y0.*window;               % ponowne okienkowanie
        n0 = m*H + 1;               % początek bloku    
        y(n0:n0+N-1) = y(n0:n0+N-1)+y0; % składanie bloków na zakładkę
    end
    close(h_wbar);
end

function A = macierz_analizy_MDCT(N)
    % Szybkie obliczenie macierzy MDCT z bloku próbek
    % A = macierz_analizy_MDCT(x)
    % x - pionowy wektor próbek
    % N - liczba próbek w wektorze x
    
    if mod(N, 2)
        error('Rząd transformacji musi być parzysty');
    end
    
    for k = 1:N/2
        for m = 1:N
            A(k,m) = sqrt(4/N)*cos(2*pi/N*((k-1)+0.5)*((m-1)+0.5+N/4));
        end
    end
end