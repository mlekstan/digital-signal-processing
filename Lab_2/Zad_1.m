close all; clear all;

N = 20;

A = DCT_II(N);

%{
for k = 0:N-1
    for n = 0:N-1
        if k ~= 0
            sk = sqrt(2/N);
        else
            sk = sqrt(1/N);
        end
        
        A(k+1,n+1) = sk*cos(pi*k/N*(n+0.5));

    end
end
%}

for k = 1:N
    a = true;
    norma(k) = norm(A(k,:));
    if round(norma) == 1
        disp("Wiersz nr " + k + " jest znormalizowany");
    else
        disp("Wiersz nr " + k + " nie jest znormalizowany");
    end

    for m = 1:N
        b = A(k,:) .* A(m,:);
        prod(k,m) = sum(b);
            
        if (m ~= k) && (round(prod(k,m)) ~= 0)
            a = false;
            disp("Wiersz nr " + k + " nie jest ortogonalny z pozostałymi wierszami");
            break; 
        end
    end
    if a == true;
        disp("Wiersz nr " + k + " jest ortogonalny z pozostałymi wierszami");
    end
end
