function [C, p, q] = my_gbmm_1067400(A,B)
%% Author: Ioannis Loudaros, ΑΜ:1067400
%% Version: 0.1     Date: 20/01/2023
% A,B :  Μητρώα ζώνης που μας ενδιαφέρει να πολλαπλασιάσουμε.
% C : Το αποτέλεσμα του πολλαπλασιασμού.

if ~(size(A,2)==size(B,1))
    disp("Τα μητρώα δεν είναι συμβατά για πολλαπλασιασμό.")
    return
end


% Μετατροπή των μητρώων στην κατάλληλη μορφή
[AB, pa, qa] = bandmatrix(A);
[BB, pb, qb] = bandmatrix(B);

% Αρχικοποιούμε το μητρώο μας ώστε να γλιτώσουμε χρόνο από τα realloc
n = size(A,1);
C = zeros(n);
p = pa+pb;
q = qa+qb;


% Διατρέχουμε τις γραμμές του C, υπολογίζουμε ποιές θέσεις του έχουν
% μηδενικά στοιχεία, και τα υπολογίζουμε.
for i = 1:n

    start = max(i-p,1);

    % Υπολογισμός πλήθους μη μηδενικών στοιχείων σε αυτή τη σειρά
    if i < p+1
        nonzero_elements = i+q;
    elseif i > n-q
        nonzero_elements = p+1+n-i;
    else
        nonzero_elements = p+q+1;
    end


    for j = start:start+nonzero_elements-1

        % Ανάκτηση μη μηδενικών στοιχείων στήλης και γραμμής
        [Arow, asize] = getrowfrombm(AB,i,pa,qa);
        Bcolumn = BB(:,j);

        % Ευθυγράμμιση διανυσμάτων
        first_element = find(Bcolumn,1,'first');
        last_element = find(Bcolumn,1,'last');
        bsize = last_element-first_element+1;

        a_start = max(1,i-pa);
        a_end = a_start + asize-1;

        b_start = max(1,j-qb);
        b_end = b_start+bsize-1;

        if a_start<b_start
            a_start_shift = b_start-a_start;
            b_start_shift = 0;
        else
            b_start_shift = a_start-b_start;
            a_start_shift = 0;
        end

        if a_end<b_end
            b_end_shift = b_end-a_end;
            a_end_shift = 0;
        else
            a_end_shift = a_end-b_end;
            b_end_shift = 0;
        end

        % Οι πράξεις γίνονται μόνο μεταξύ στοιχείων των διαγωνίων.
        % Δεν σπαταλάται χρόνος στα μηδενικά.
        C(i,j)= dot(Arow(1+a_start_shift:end-a_end_shift), Bcolumn(first_element+b_start_shift:last_element-b_end_shift));
    end
end



end