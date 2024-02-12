function x = tdbmsolver_1067400(A,B)
%% Author: Ioannis Louaros, ΑΜ:1067400
%% Version: 0.1     Date: 03/02/2023
% A : Το συμπιεσμένο μητρώο.
% B : Το δεξιό μέλος.
% x : Η λύση του συστήματος.

A = debandmatrix_1067400(A);

n = size(A, 2);

for k = 1:log2(n)+1
    D = diag(diag(A));
    L = tril(A,-1)*-1;
    U = triu(A,1)*-1;
    D_inv = inv(D);

    A = (D+L+U)*D_inv*A; % Δημιουργία του Α^(k)
    B = (D+L+U)*D_inv*B; % Δημιουργία του B^(k)
end
    x = B./diag(A);

end
