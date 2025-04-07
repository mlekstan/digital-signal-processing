close all; clear all;

[x, fs] = audioread( 'DontWorryBeHappy.wav' );      % wczytanie próbki dźwiękowej
x = double(x(:,1));

a = 0.9545;                                         % wpółczynnik predykcji
Nb = 4;                                             % liczba bitów 


%% Bez kwantyzacji
d = x - a * [0; x(1:end-1)];                        % KODER
y1 = dekoder(d, a);                                 % DEKODER
y1_error = abs(y1 - x.');
max_error_1 = max(y1_error)                         % maks. błąd rekonstrukcji 
avg_error_1 = mean(y1_error)                        % średni błąd rekonstrukcji

%% Z kwantyzacją
dq = lab11_kwant(d, Nb);                            % kwantyzator
y2 = dekoder(dq, a);                                % DEKODER
y2_error = abs(y2-x.');
max_error_2 = max(y2_error)                         % maks. błąd rekonstrukcji
avg_error_2 = mean(y2_error)                        % średni błąd rekonstrukcji

%% Wykresy
figure(1);
n = 1:length(x);
plot(n, d, 'b', n, dq, 'r');
legend('d(n)', 'dq(n)');
title('Porównanie d(n) i dq(n)');
xlabel('Numer próbki');
ylabel('Amplituda');

figure(2);
plot(n, x, 'b', n, y1, 'r--');
legend('Oryginalny sygnał x(n)', 'Zrekonstruowany sygnał y1(n)');
title('Porównanie sygnału oryginalnego ze zrekonstruowanym y1(n)');
xlabel('Numer próbki');
ylabel('Amplituda');

figure(3);
plot(n, x, 'b', n, y2, 'r');
legend('Oryginalny sygnał x(n)', 'Zrekonstruowany sygnał y2(n)');
title('Porównanie sygnału oryginalnego ze zrekonstruowanym y2(n)');
xlabel('Numer próbki');
ylabel('Amplituda');

figure(4);
plot(n, y2_error, 'b', n, y1_error, 'r');
legend('Błąd rekonstrukcji y2(n)', 'Błąd rekonstrukcji y1(n)');
title('Błędy rekonstrukcji');
xlabel('Numer próbki');
ylabel('Wartość błędu');


%% Odsłuchanie dźwięku przed i po operacjach
disp('Odtwarzanie oryginalnego sygnału ...');
sound(x, fs);
pause();

disp('Odtwarzanie zrekonstruowanego sygnału y1 ...');
sound(y1, fs);
pause(); 

disp('Odtwarzanie zrekonstruowanego sygnału y2 ...');
sound(y2, fs);
pause(); 

%% Funkcje
function xq= lab11_kwant(x, Nb)
    Nq = 2^Nb;
    x_min = min(x);
    x_max = max(x);

    dx = (x_max-x_min)/(Nq-1);

    ranges_borders = [x_min:dx:x_max];
    
    xq = dx*round(x/dx);

end

function y = dekoder(x, a)
    for i=1:length(x)                                  
        if i == 1
            y(i) = x(i);
        else 
            y(i) = x(i) + a*y(i-1);
        end
    end
end
