close all; clear all;

A = 230;
t = 0.1;
f = 50;
T = 1/f;
fs = 10^4;
Ts = 1/fs;
fs3 = 200;
Ts3 = 1/fs3;

l_probek = t * fs;  
ts = Ts * (0:l_probek-1); % wektor wszystkich miejsc (t) w których chcemy odtworzyć sygnał
x = A*sin(2*pi*f*ts); % syganał prawie analogowy

l_probek_3 = t * fs3;
ts_3 = Ts3 * (0:l_probek_3-1)
xs = A*sin(2*pi*f*ts_3); % sygnał próbkowany ze stosunkowo małą częstotliwością, który chcemy zinterpolować

for idx = 1:l_probek
    t = ts(idx);
    xhat(idx) = 0;
    for n = -l_probek_3-1:l_probek_3-1 % zakres sinc()
        xhat(idx) = xhat(idx) + A*sin(2*pi*f*n*Ts3) * sinc((1/Ts3) * (t-n*Ts3)); % we wzorze należy wykorzystać „n" i „t"
    end
end

blady_bezwzgl = abs(xhat-x);
sredni_blad_bezwzgl = mean(blady_bezwzgl)
blady_wzgl = blady_bezwzgl./abs(x);
sredni_blad_proc = mean(blady_wzgl) * 100
x(51),xhat(51)

figure;

plot(ts,x,'b-')
hold on;
plot(ts_3,xs,'g-o')
plot(ts, xhat, 'r-o')