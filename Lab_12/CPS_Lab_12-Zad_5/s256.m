
% --------------------------------------------------------------------------------------
% Tabela 22-8 (str. 704)
% �wiczenie: Falkowa dekompozycja obrazu metod� predykcyjn� (predykcja - uaktualnienie)
% --------------------------------------------------------------------------------------
 
function A=s256(A);

% Skalowanie warto�ci macierzy do przedzia�u 0 - 255;

Amin=min(A(:));
A=A-Amin;
Amax=max(A(:));
A=255*A/Amax;
