clear all; close all;

A = 230;
t = 0.1;
f = 50;
T = 1/f;
fs = 10^4;
Ts = 1/fs;
fs3 = 200;
Ts3 = 1/fs3;

l_probek = t * fs;  
ts = Ts * (0:l_probek-1);

l_probek_3 = t * fs3;
ts_3 = Ts3 * (0:l_probek_3-1)

xhat = sinc_interp(A*sin(2*pi*f*ts_3),ts_3,ts)

figure;

plot(ts,A*sin(2*pi*f*ts),'b-')
hold on;
plot(ts_3,A*sin(2*pi*f*ts_3),'g-o')
plot(ts, xhat, 'r-o')