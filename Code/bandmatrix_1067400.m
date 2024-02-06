function [AB,p,q] = bandmatrix_1067400(A,p,q)
%% Author: Ioannis Loudaros, ΑΜ:1067400
%% Version: 0.1     Date: 03/02/2023
% A : Το μητρώο προς συμπίεση.
% q : Το πλήθος μη μηδενικών υπερδιαγωνίων.
% p : Το πλήθος μη μηδενικών υποδιαγωνίων.
% AB : Το συμπιεσμένο μητρώο.

%Υπολογισμός p, q
if nargin==2
    disp("Δεν μπορείς να δώσεις μόνο το p");

elseif nargin==1
    q = find(A(1,:),1, "last")-1;

    p = find(A(:,1),1,"last")-1;
end

% Αρχικοποίηση του ΑΒ για να μην χάνεται χρόνος στα realloc
AB = zeros(q+p+1,length(A));


% Σε κάθε επανάληψη εξάγουμε την κατάλληλη διαγώνιο,  
% προσθέτουμε όσα μηδενικά χρειάζονται δεξία και αριστερά της 
% και την εισάγουμε στην κατάλληλη θέση στον καινούργιο πίνακα. 
% Κινούμαστε από κάτω προς τα πάνω.
for i = 1:q+p+1 
    if i-p<=0
        AB(end-i+1,:)= [diag(A,i-1-p)' zeros(1,abs(i-1-p))];
    else
        AB(end-i+1,:)= [zeros(1,i-1-p) diag(A,i-1-p)'];
    end

end