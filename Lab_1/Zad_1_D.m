close all; clear all;
a = 5;
k = 1;
df = k*a;

A = 5;
t = 1;
fn = 50;
Tn = 1/fn;
fs = 10^4;
Ts = 1/fs;
fm = 1;
Tm = 1/fm;



% x(t) =  a*sin(2*pi*fm*t)
% c(t) = A*sin(2*pi*fn*t)
% y(t) = A*cos(2*pi*fn*t+k*całka(x(t) dt)) = 
% = A*cos(2*pi*fn*t-((k*a)/(2*pi*fm))*cos(2*pi*fm*t)) , df = k*a

ts = 0:Ts:t-Ts;
x = a*sin(2*pi*fm*ts);

figure; title("Sygnał zmodulowany i modulujący")
plot(ts,x, 'b-')
hold on;

y = A*sin(2*pi*fn*ts-((k*a))*cos(2*pi*fm*ts));
plot(ts,y,'b-');


fs2 = 25;
Ts2 = 1/fs2;
ts2 = 0:Ts2:t-Ts2;

ys = A*sin(2*pi*fn*ts2-((k*a))*cos(2*pi*fm*ts2));

figure; title("Sygnał zmodulowany analogowy i spróbk.")
plot(ts2,ys)
hold on;
plot(ts, y)

ys_interp = interp1(ts2, ys, ts)
figure; title("Sygnał zmodulowany fs=25[Hz]")
plot(ts,ys_interp,'b-o');

blad_probk = abs(y-ys_interp);
figure; title("Błąd próbkowania sygnału zmodulowanego")
plot(ts,blad_probk);


