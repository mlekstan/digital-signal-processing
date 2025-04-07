close all; clear all;

t = 0.1;
A = 230; 
f = 50;
T = 1/f;
omega_0 = 2 * pi * f;

fs_1 = 10^4; % [Hz]
Ts_1 = 1/fs_1; % [s]

l_probek_1 = t/Ts_1;
numery_probek_1 = 0:l_probek_1-1;

% A * sinus(omega_0 * t)

macierz_probek_1 = A*sin(omega_0 * (Ts_1*numery_probek_1));

plot(Ts_1*numery_probek_1,macierz_probek_1, 'b-');
hold on;

fs_2 = 500; % [Hz]
Ts_2 = 1/fs_2; % [s]

l_probek_2 = t/Ts_2;
numery_probek_2 = 0:l_probek_2-1;

% A * sinus(omega_0 * t)

macierz_probek_2 = A*sin(omega_0 * (Ts_2*numery_probek_2));

plot(Ts_2*numery_probek_2,macierz_probek_2, 'r-o');


fs_3 = 200; % [Hz]
Ts_3 = 1/fs_3; % [s]

l_probek_3 = t/Ts_3;
numery_probek_3 = 0:l_probek_3-1;

% A * sinus(omega_0 * t)

macierz_probek_3 = A*sin(omega_0 * (Ts_3*numery_probek_3));

plot(Ts_3*numery_probek_3,macierz_probek_3, 'k-x');


