function [row, nonzero_elements] = getrowfrombm(AB, row_num, p, q)
%% Author: Ioannis Loudaros, ΑΜ:1067400
%% Version: 0.1     Date: 21/01/2023
% AB :  Το συμπιεσμένο μητρώο ζώνης
% row_num : Η γραμμή που θέλουμε

n = p+q+1;
non_compressed_height = size(AB,2);


% Υπολογισμός πλήθους μη μηδενικών στοιχείων σε αυτή τη σειρά
if row_num < p+1
    nonzero_elements = row_num+q;
elseif row_num > non_compressed_height-q
    nonzero_elements = p+1+non_compressed_height-row_num;
else
    nonzero_elements = n;
end

row = zeros(1,nonzero_elements);

% Εύρεση σημείου εκκίνησης μέσα στο συμπιεσμένο μητρώο
starting_point = zeros(1,2);

starting_point(1) = min(n, row_num+q);

if row_num <= p+1
    starting_point(2)=1;
else
    starting_point(2)=row_num-p;
end

index = starting_point;

% Υπολογισμός σειράς
for i = 1:nonzero_elements

    row(i) = AB(index(1),index(2));
    index = index + [-1 1];

end