clc; clear all; close all;

% Sygnały
N = 80;
x = randn(1, N);
y = randn(1, N);

% Obliczanie autokorelacji moją funkcją korelacji z różnymi opcjami normalizacji
autoCorrMy_none = correlation(x, x, 'none');
autoCorrMy_biased = correlation(x, x, 'biased');
autoCorrMy_unbiased = correlation(x, x, 'unbiased');

% Obliczanie korelacji moją funkcją korelacji z różnymi opcjami normalizacji
corrMy_none = correlation(x, y, 'none');
corrMy_biased = correlation(x, y, 'biased');
corrMy_unbiased = correlation(x, y, 'unbiased');

% Obliczanie autokorelacji za pomocą funkcji xcorr(x) 
autoCorr_xcorr_none = xcorr(x, 'none');
autoCorr_xcorr_biased = xcorr(x, 'biased');
autoCorr_xcorr_unbiased = xcorr(x, 'unbiased');

% Oblicznie korelacji za pomocą funkcji xcorr(x, y)
corr_xcorr_none = xcorr(x, y, 'none');
corr_xcorr_biased = xcorr(x, y, 'biased');
corr_xcorr_unbiased = xcorr(x, y, 'unbiased');

% Porównanie funkcji autokorelacji
n = -N+1:N-1;
figure;
subplot(3,1,1);
hold on;
plot(n, autoCorrMy_none);
plot(n, autoCorr_xcorr_none, '--');
title('Autokokrealcje (none)');
xlabel('k');
ylabel('R(k)');
legend('correlation', 'xcorr');
grid on;

subplot(3,1,2);
hold on;
plot(n, autoCorrMy_biased);
plot(n, autoCorr_xcorr_biased, '--');
title('Autokorelacje (biased)');
xlabel('k');
ylabel('R(k)');
legend('correlation', 'xcorr');
grid on;

subplot(3,1,3);
hold on;
plot(n, autoCorrMy_unbiased);
plot(n, autoCorr_xcorr_unbiased, '--');
title('Autokorelacje (unbiased)');
xlabel('k');
ylabel('R(k)');
legend('correlation', 'xcorr');
grid on;

% Porównanie funkcji korelacji
figure;
subplot(3,1,1);
hold on;
plot(n, corrMy_none);
plot(n, corr_xcorr_none, '--');
title('Korelacje (none)');
xlabel('k');
ylabel('R(k)');
legend('correlation', 'xcorr');
grid on;

subplot(3,1,2);
hold on;
plot(n, corrMy_biased);
plot(n, corr_xcorr_biased, '--');
title('Korelacje (biased)');
xlabel('k');
ylabel('R(k)');
legend('correlation', 'xcorr');
grid on;

subplot(3,1,3);
hold on;
plot(n, corrMy_unbiased);
plot(n, corr_xcorr_unbiased, '--');
title('Korelacje (unbiased)');
xlabel('k');
ylabel('R(k)');
legend('correlation', 'xcorr');
grid on;

% Współczynniki korelacji
r = corrcoef(x, y);
r_my = pearsonCorrelationCoefficient(x, y);
disp(['Współczynnik korelacji - corrcoef(x, y): ', num2str(r(1,2))]);
disp(['Współczynnik korelacji - pearsonCorrelationCoefficient(x, y): ', num2str(r_my)]);

%% Funkcje

function R = correlation(x, y, norm_type)
    N = length(x);
    R = zeros(1, 2*N-1);

    for k = -N+1:N-1 
        sum = 0;
        if k >= 0
            for n = 1:N-k
                sum = sum + x(n) * y(n+k);
            end
        else
            for n = -k+1:N
                sum = sum + x(n) * y(n+k);
            end
        end
        
        switch norm_type
            case 'none'
                C = 1;
            case 'biased'
                C = N;
            case 'unbiased'
                C = N - abs(k);
        end
        
        R(k+N) = sum / C; % normalizacja
    end
end


function r = pearsonCorrelationCoefficient(x, y)
    N = length(x);
    mean_x = mean(x);
    mean_y = mean(y);
    std_x = std(x);
    std_y = std(y);
    
    r = sum((x - mean_x) .* (y - mean_y))/((N - 1) * std_x * std_y);
end