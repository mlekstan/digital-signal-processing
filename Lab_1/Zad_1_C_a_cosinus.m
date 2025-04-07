close all; clear all;

A = 230;
fs = 100;
Ts = 1/fs;
t = 1;
liczba_probek = t*fs;
numery_probek = 0:liczba_probek-1;

for f = 0:5:300
    disp(f);
    omega_0 = 2*pi*f;
    macierz_probek = A*cos(omega_0*Ts*numery_probek);
    plot(Ts*numery_probek,macierz_probek,'b-o');
    pause;
end