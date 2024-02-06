function [A,p,q] = debandmatrix_1067400(AB,p,q)
%% Author: Ioannis Loudaros, ΑΜ:1067400
%% Version: 0.1     Date: 03/02/2023
% A : Το αποσυμπιεσμένο μητρώο.
% q : Το πλήθος μη μηδενικών υπερδιαγωνίων.
% p : Το πλήθος μη μηδενικών υποδιαγωνίων.
% AB : Το συμπιεσμένο μητρώο.

n = size(AB,2); % Το εξαγώμενο μητρώωο είναι μεγέθους nxn.
A = zeros(n);

%Υπολογισμός p, q
if nargin==2
    disp("Δεν μπορείς να δώσεις μόνο το p");

elseif nargin==1
    q = find(AB(1,:),1, "first")-1;

    p = n - find(AB(end,:),1,"last");
end


% Σε κάθε επανάληψη βάζουμε την κάθε διαγώνιο στην κατάλληλη θέση
% κινούμενοι από κάτω προς τα πάνω
for i = 1:q+p+1 
    if i-p<=0
        length = find(AB(end-i+1,:),1, "last");
        normalized = AB(end-i+1,1:length);
        
    else
        start = find(AB(end-i+1,:),1, "first");
        normalized = AB(end-i+1,start:end);
    end
    A = A + diag(normalized,i-1-p);
end

end