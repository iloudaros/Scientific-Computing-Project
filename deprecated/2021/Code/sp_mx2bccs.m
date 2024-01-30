function [val, brow_idx, bcol_ptr]=sp_mx2bccs(A,nb)
% Author: Ioannis Loudaros, ΑΜ:1067400, Date: 16/01/22

% Δοκιμάζουμε αν τα δεδομένα μας είναι σωστά
if ( ~(size(A,1) == size(A,2)) ), error("Το μητρώο δεν είναι τετραγωνικό!");
end

if (mod(height(A),nb) ~= 0), error("Το μητρώο δεν διαιρείται ακριβώς!");
end


numoblocks = height(A)/nb;% Υπολογίζουμε πόσα blocks χρειαζόμαστε ανάλογα το μέγεθος που δόθηκε

dist=ones(1,numoblocks)*nb;% Φτιάχνουμε την κατάλληλη διαμέρηση που θα χρησιμοποιήσουμε στην mat2cell

A=mat2cell(A,dist,dist);% Χωρίζουμε το Α σε blocks


% Preallocation
nzblocks_in_col = zeros(numoblocks,1);% Ένας πίνακας για να μετράμε τα μη μηδενικά blocks σε κάθε στήλη
bcol_ptr = zeros(numoblocks,1);


% ------------------ Βρίσκουμε πόσα μη μηδενικά blocks υπάρχουν ανα block-στήλη του Α ---------------
for i=1:width(A)
    a=A(:,i); %Πάρε μια στήλη από blocks του Α
    for j = 1:height(A)
        [~,~,k]=find(a{j});% Βρες τις μη μηδενικές τιμές του block
        if ~isempty(k)% Αν αυτές υπάρχουν
            nzblocks_in_col(i)=nzblocks_in_col(i)+1;% Τότε πρόσθεσε 1 στο πλήθος block της στήλης            
        end
    end
end


% -------------------- Κάνουμε iterate το Α άνα block ---------------------
flag=0; % Σημαία εύρεσης του πρώτου μη μηδενικού block
nzblocks_found=0; % Πόσα nzblocks έχουμε βρει κατά το itteration

for i= 1:numoblocks

    flag_for_column = 0; % Η σημαία που εξετάζει αν είναι το πρώτο nz block που έχει βρεθεί σε αυτή τη στήλη
    
    for j= 1:numoblocks

        [~,~,k]=find(A{j,i});% Βρες τις μη μηδενικές τιμές του block

        if ~isempty(k)% Αν αυτές υπάρχουν, τότε
            if ~flag% Αν είναι το πρώτο block με μη μηδενικές τιμές
                val=reshape(A{j,i},[],1);% Δημιούργησε το val και αποθήκευσε το block
                bcol_ptr(i)=1;% Ενημέρωσε την κατάλληλη θέση του bcol_ptr ότι από αυτή τη στήλη ξεκινάνε τα nz blocks

                brow_idx(1)=j;% Ενημέρωσε την κατάλληλη θέση του brow_idx για την block-σειρά στην οποία βρίσκεται αυτό το block
                nzblocks_found=1;
                flag=1;% Ενημέρωσε ότι το πρώτο μη μηδενικό block βρέθηκε
                flag_for_column=1;% Ενημέρωσε ότι βρέθηκε το πρώτο στοιχείο της στήλης
            else % Αν είχε βρεθεί κιάλλο block προηγουμένως  
                val=[val;reshape(A{j,i},[],1)]; % Πρόσθεσε το block στο val
                nzblocks_found=nzblocks_found+1;
                brow_idx(nzblocks_found)=j;% Ενημέρωσε την κατάλληλη θέση του brow_idx για την block-σειρά στην οποία βρίσκεται αυτό το block

                if ~flag_for_column % Αν είναι το πρώτο block της στήλης αυτής που βρίσκουμε
                bcol_ptr(i)= bcol_ptr(i-1)+nzblocks_in_col(i-1);
                flag_for_column=1;
                end
                
            end
            

        end
    end
end

%Δηλώνουμε το τέλος του δείκτη και φροντίζουμε για τις κενές του θέσεις
length = size(bcol_ptr,1); % Μέτρα το μέγεθος του δείκτη
        bcol_ptr(end+1)=1+nzblocks_found; % Για να δείξεις ότι έχει τελείωσει πρόσθεσε ένα στοιχείο στο τέλος

        for i=length:-1:1 % Όπου βλέπεις 0 στον δείκτη επανέλαβε την επόμενη τιμή του δείκτη
            if bcol_ptr(i)==0
                bcol_ptr(i)=bcol_ptr(i+1);
            end
        end



val=val';
bcol_ptr=bcol_ptr';
end
