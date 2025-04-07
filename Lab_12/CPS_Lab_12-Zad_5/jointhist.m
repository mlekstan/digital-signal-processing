
% ------------------------------------------------------------------------------
% Tabela 22-14 (str. 727)
% �wiczenie: Dopasowywanie obraz�w metod� maksymalizacji informacji wzajemnej
% ------------------------------------------------------------------------------
 
function h = jointhist(I1,I2)
% Histogram wzajemny obraz�w dla 256 poziom�w jasno�ci o dynamice 0 - 255

I1 = double(uint8(I1));  % przej�cie na reprezentacj� double
I2 = double(uint8(I2));  % 

N=256;  h=zeros(N,N); [w k]=size(I1);
for i=1:w;
    for j=1:k;
        h(I1(i,j)+1,I2(i,j)+1) = h(I1(i,j)+1,I2(i,j)+1) + 1;
    end
end
