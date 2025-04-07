close all; clear all;

N = 100;
fs = 1000;
Ts = 1/fs;
ts = 0:Ts:Ts*(N-1);

f1 = 50; A1 = 50;
f2 = 100; A2 = 100;
f3 = 150; A3 = 150;

A = DCT_II(N);
S = inv(A);

for i = 1:N
    plot(A(i,:),'b-');
    hold on;
    pause;
    plot(S(:,i),'r-');
    pause;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x1 = A1*sin(2*pi*f1*ts.');
x2 = A2*sin(2*pi*f2*ts.');
x3 = A3*sin(2*pi*f3*ts.');

x = x1 + x2 + x3;
figure;
plot(ts,x)

y = A*x;
figure;
stem(y); title("y(n)");

f = (0:N-1)*fs/N;
figure;
stem(f,y); title("y(f), (f2 = 100)");

x_r = S*y;
figure; 
plot(ts,x,'b-o'); title("Sygnał x i x_r");
hold on;
plot(ts,x_r,'r-x');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f2 = 105;
x2 = A2*sin(2*pi*f2*ts.');
x = x1 + x2 + x3;

figure;
y = A*x;
stem(f,y); title("y(f), (f2 = 105)");

x_r = S*y;
figure; 
plot(ts,x,'b-o'); title("Sygnał x i x_r");
hold on;
plot(ts,x_r,'r-x');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f1 = 50 + 2.5;
f2 = 100 + 2.5;
f3 = 150 + 2.5;

x1 = A1*sin(2*pi*f1*ts.');
x2 = A2*sin(2*pi*f2*ts.');
x3 = A3*sin(2*pi*f3*ts.');
x = x1 + x2 + x3;

figure;
y = A*x;
stem(f,y); title("y(f), (f1 = 52.5, f2 = 102.5, f3 = 152.5)");
