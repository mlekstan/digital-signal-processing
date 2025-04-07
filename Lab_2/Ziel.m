close all; clear all;

N = 10

m = 0:N-1 % m - nr cos() czyli częstotliwość
n = 0:N-1 % n - próbka kosinusa

A = sqrt(2/N) * cos(pi/N * (m+0.5)' * (n+0.5))
s = A';

orto = S * A; pause

figure; plot(s); title('s'); pause

x = 2*s(:,2) + 4*s(:,20)

y = A*x;

figure; stem(y) 