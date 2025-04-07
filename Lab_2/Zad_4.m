close all; clear all;

[x ,fs] =audioread("mowa.wav");

N = 256;

A = DCT_II(N);

punkty_start = [123,1680,4666,7000,10000,12345,20000,23456,30000,34556];
M = length(punkty_start);
f = 0:fs/(N-1):fs; % przeskalowanie na Hz

for i = 1:M
    x_fragment = x(punkty_start(i):punkty_start(i)+255);
    y=A*x_fragment;
    figure;
    subplot(2,1,1); plot(x_fragment); title("x("+punkty_start(i)+":"+(punkty_start(i)+255)+")");
    subplot(2,1,2); stem(f,y); title("y(f)");
end
