function R = blkToeplitzTrid(n,B,A,C)
% Author: Ioannis Loudaros, ΑΜ:1067400, Date: 15/01/22


%Testing the Matrices
if( ~(size(A,1)==size(A,2)) || ~(size(B,1)==size(B,2)) || ~(size(C,1)==size(C,2)) )
    error("There are non-square matrices in the arguments.");

else 
    if (~( (size(A,1)==size(B,1)) && (size(B,1)==size(C,1)) ))
        error("The matrices are not of the same size.")
end

m=size(A,1);% Κρατάμε το μήκος (ή το πλάτος) των μητρώων
Z=zeros(m);% Προετοιμάζουμε ένα μητρώο στο μέγεθος των υπολοίπων με μηδενικά
T={Z,A,B,C};% Οργανώνουμε τα μητρώα μας, 
% τώρα μπορούμε να τους ανασφερόμαςστε εύκολα μέσω δεικτών στο Τ

% Προετοιμάζουμε την κλήση της toeplitz
col = ones(1,n);
col(1)=2;
col(2)=3;
row = ones(1,n);
row(1)=2;
row(2)=4;
Indexes = toeplitz(col,row); % Δημιουργήσαμε ένα μητρώο που σε κάθε του θέση
% είναι ο δείκτης που αντιστοιχεί σε ένα μητρώο του Τ

R = cell2mat(T(Indexes));
R = sparse(R);
end
