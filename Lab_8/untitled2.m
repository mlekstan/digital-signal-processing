close all; clear all;

f = 2;
t = 0:0.01:1;


x = sin(2*pi*f*t);

figure;
plot(t,x);

for w = 0:0.25:2
  X = x.*exp(-j*2*pi*w*t);
  figure;
  plot(X);
  pause;
end