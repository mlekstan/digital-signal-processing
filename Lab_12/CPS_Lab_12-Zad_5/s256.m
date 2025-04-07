
% --------------------------------------------------------------------------------------
% Tabela 22-8 (str. 704)
% Æwiczenie: Falkowa dekompozycja obrazu metod¹ predykcyjn¹ (predykcja - uaktualnienie)
% --------------------------------------------------------------------------------------
 
function A=s256(A);

% Skalowanie wartoœci macierzy do przedzia³u 0 - 255;

Amin=min(A(:));
A=A-Amin;
Amax=max(A(:));
A=255*A/Amax;
