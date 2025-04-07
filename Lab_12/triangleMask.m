function H = triangleMask(M,N,K)
    H = zeros(M,N);
    for i=1:K
        H(i,1:K-(i-1)) = ones(1,K-(i-1));
    end
end