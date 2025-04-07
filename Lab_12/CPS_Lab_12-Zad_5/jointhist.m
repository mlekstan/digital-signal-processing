
% ------------------------------------------------------------------------------
% Tabela 22-14 (str. 727)
% Æwiczenie: Dopasowywanie obrazów metod¹ maksymalizacji informacji wzajemnej
% ------------------------------------------------------------------------------
 
function h = jointhist(I1,I2)
% Histogram wzajemny obrazów dla 256 poziomów jasnoœci o dynamice 0 - 255

I1 = double(uint8(I1));  % przejœcie na reprezentacjê double
I2 = double(uint8(I2));  % 

N=256;  h=zeros(N,N); [w k]=size(I1);
for i=1:w;
    for j=1:k;
        h(I1(i,j)+1,I2(i,j)+1) = h(I1(i,j)+1,I2(i,j)+1) + 1;
    end
end
