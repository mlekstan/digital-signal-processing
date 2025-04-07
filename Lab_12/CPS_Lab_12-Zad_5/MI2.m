
% ------------------------------------------------------------------------------
% Tabela 22-14 (str. 727)
% Æwiczenie: Dopasowywanie obrazów metod¹ maksymalizacji informacji wzajemnej
% ------------------------------------------------------------------------------
 
function [NMI,a] = MI2(I1,I2)
% Informacja wzajemna pomiêdzy dwoma obrazami

a = jointhist(I1,I2); % oblicz histogram wzajemny miêdzy obrazami
[w,k] = size(a);

b= a./(w*k);          % normalizacja histogramu wzajemnego
y_marg = sum(b);      % histogram 1 (obrazu pierwszego)
x_marg = sum(b');     % histogram 2 (obrazu drugiego)

ids = find(y_marg~=0); Hy = -sum(y_marg(ids).*log2(y_marg(ids))); % entropia histogramu 1
ids = find(x_marg~=0); Hx = -sum(x_marg(ids).*log2(x_marg(ids))); % entropia histogramu 2
Hxy = -sum(sum(b.*log2(b+(b==0))));      % entropia histogramu wzajemnego
NMI = (Hx + Hy)/Hxy-1;                   % unormowana informacja wzajemna

