close all; clear all;

N = 100;
M = 100;
fs = 1000; Ts = 1/fs;
f1 = 125; T1 = 1/f1;
f2 = 200; T2 = 1/f2;
A1 = 100;
A2 = 200;
fi1 = pi/7;
fi2 = pi/11;

ts_N = 0:Ts:(N-1)*Ts;
ts_NM = 0:Ts:(N+M-1)*Ts;
x1 = @(t) A1*cos(2*pi*f1*t+fi1);
x2 = @(t) A2*cos(2*pi*f2*t+fi2);
x = x1(ts_N) + x2(ts_N); 
xz = [x,zeros(1,M)];

figure;
subplot(4,1,1); plot(ts_N, x1(ts_N)); title("x1(t)"); xlabel("[s]");
subplot(4,1,2); plot(ts_N, x2(ts_N)); title("x2(t)"); xlabel("[s]");
subplot(4,1,3); plot(ts_N, x); title("x(t)"); xlabel("[s]");
subplot(4,1,4); plot(ts_NM, xz); title("xz(t)"); xlabel("[s]");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k = 1:N
    for n = 1:N
        A(k,n) = 1/sqrt(N)*exp((j*2*pi/N)*(-(k-1)*(n-1)));
    end
end

X1 = A*x.';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X2 = fft(xz)./(N+M);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

suma = 0;
for f = 0:0.25:1000
    m = 1:length(f);
    for n = 1:N
        suma = suma + x(n)*exp(-j*2*pi*(f/fs)*(n-1));
    end

    X3(m) = suma/N;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fx1 = fs*(0:N-1)/N;
figure; stem(fx1, abs(X1)); title("X1(fx1)"); xlabel("fx1");

fx2 = (0:N+M-1)*fs/(N+M);
figure; stem(fx2, abs(X2)); title("X2(fx2)"); xlabel("fx2");

fx3 = f;
figure; stem(fx3, abs(X3)); title("X3(fx3)"); xlabel("fx3");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
stem(fx1,abs(X1),'o',fx2,abs(X2),'bx',fx3,abs(X3),'k-')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

suma = 0;
for f = -2*fs:0.25:2*fs
    m = 1:length(f);
    for n = 1:N
        suma = suma + x(n)*exp(-j*2*pi*(f/fs)*(n-1));
    end

    X3(m) = suma/N;
end

fx3 = f;
figure; stem(fx3, X3); title("X3(fx3), f = (-2000:0.25:2000)"); xlabel("fx3");
