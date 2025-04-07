clear all;

N = 100;
fs = 1000; Ts = 1/fs;
f1 = 100; T1 = 1/f1;
f2 = 200; T2 = 1/f2;
A1 = 100;
A2 = 200;
fi1 = pi/7;
fi2 = pi/11;

ts = 0:Ts:(N-1)*Ts;

x1 = @(t) A1*cos(2*pi*f1*t+fi1);
x2 = @(t) A2*cos(2*pi*f2*t+fi2);
x = x1(ts) + x2(ts);

figure;
subplot(3,1,1); plot(ts, x1(ts)); title("x1(t)"); xlabel("[s]");
subplot(3,1,2); plot(ts, x2(ts)); title("x2(t)"); xlabel("[s]");
subplot(3,1,3); plot(ts, x); title("x(t)"); xlabel("[s]");

for k = 1:N
    for n = 1:N
        A(k,n) = 1/sqrt(N)*exp((j*2*pi/N)*(-(k-1)*(n-1)));
    end
end

X = A*x.'; % analiza DFT

f = (0:N-1)*(fs/N);
figure;
subplot(4,1,1); stem(f, real(X)); title("Re(X)"); xlabel("[Hz]");
subplot(4,1,2); stem(f, imag(X)); title("Im(X)"); xlabel("[Hz]");
subplot(4,1,3); stem(f, abs(X)); title("abs(X)"); xlabel("[Hz]");
subplot(4,1,4); stem(f, angle(X) .* (abs(X)>1)); title("fi(X)"); xlabel("[Hz]");

B = A';

xr = B*X; % rekonstrukcja IDFT

if xr == x
    disp("xr == x");
else
    disp("xr ~= x");
    error = abs(x-xr');
    figure;
    stem((0:N-1), error); title("Różnica między xr a x"), xlabel("n");

    mean_error = mean(error);
    disp("mean_error = " + mean_error);
end

new_X = fft(x); % analiza FFT
new_xr = ifft(new_X); % rekonstrukcja IFFT

if xr == x
    disp("new_xr == xr");
else
    disp("new_xr ~= xr");
    new_error = abs(new_xr-xr');
    figure;
    stem((0:N-1), new_error); title("Różnica między (new x) a x"), xlabel("n");
    
    mean_new_error = mean(new_error);
    disp("mean_new_error = " + mean_new_error);
end


new_X_X_error = abs(new_X-X');
figure;
stem((0:N-1), new_X_X_error); title("Różnica między X a (new X)"), xlabel("n");





