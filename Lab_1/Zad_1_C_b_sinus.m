close all; clear all;

A = 230;
fs = 100;
Ts = 1/fs;
t = 1;
liczba_probek = t*fs;
numery_probek = 0:liczba_probek-1;

figure;
plot(Ts*numery_probek,A*sin(2*pi*5*Ts*numery_probek),'b-o');
hold on;
plot(Ts*numery_probek,A*sin(2*pi*105*Ts*numery_probek),'r-o');
plot(Ts*numery_probek,A*sin(2*pi*305*Ts*numery_probek),'k-o');
hold off;

figure;
plot(Ts*numery_probek,A*sin(2*pi*95*Ts*numery_probek),'b-o');
hold on;
plot(Ts*numery_probek,A*sin(2*pi*195*Ts*numery_probek),'r-o');
plot(Ts*numery_probek,A*sin(2*pi*295*Ts*numery_probek),'k-o');
hold off;

figure;
plot(Ts*numery_probek,A*sin(2*pi*95*Ts*numery_probek),'b-o');
hold on;
plot(Ts*numery_probek,A*sin(2*pi*105*Ts*numery_probek),'r-o');
hold off;