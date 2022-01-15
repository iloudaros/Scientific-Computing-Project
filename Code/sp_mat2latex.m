function [val,row_ip,col_ip] = sp_mat2latex(A,sp_type)
% Author: Ioannis Loudaros, ΑΜ:1067400, Date: 13/01/22
% To-do:Βάλε τα περιεχόμενα των cases σε ξεχωριστά functions


nz=nnz(A); % Number of non zero matrix elements
height=size(A,1); % height of A
width=size(A,2); %width of A
flag=0; %flag για την πρώτη γραμμή που έχει μη μηδενική τιμή

%Ακολουθεί preallocation για κάποια vectors που θα χρειαστούν αργότερα (για να μην χάνεται χρόνος στα reallocate)
nz_number_in_row=zeros(height,1);
nz_number_in_column=zeros(width,1);
row_ip=zeros(height,1);
col_ip=zeros(width,1);

switch sp_type
    case 'csr'

        [col_ip,~]=find(A'); %Επιστρέφει τα indexes των στηλών των μη μηδενικών τιμών
        [~,~,val]=find(A'); %Επιστρέφει τις ίδιες τις τιμές (ανα σειρές)


        for i=1:height
            a=A(i,:); %Πάρε μια γραμμή του Α
            nz_in_row = find(a); %Βρες τα μη μηδενικά της στοιχεία
            nz_number_in_row(i) = size(nz_in_row,2); %Μέτρα πόσα είναι
        end

        for i=1:height %Για κάθε σειρά
            if nz_number_in_row(i)>0 %Αν έχει μη μηδενικά στοιχεία
                if flag==0 %Έλεγξε αν είναι η πρώτη σειρά χωρίς μηδενικά στοιχεία
                    row_ip(i)=1; %Βάλε στον δείκτη σειράς ότι η πρώτη τιμή του val είναι αυτής της σειράς
                    flag=1; %Ενημέρωσε ότι η πρώτη τιμή βρέθηκε
                else %Αν δεν είναι η πρώτη σειρά χωρίς μηδενικά στοιχεία
                    row_ip(i)=nz_number_in_row(i-1)+row_ip(i-1); %Τότε το στοιχείο του val από το οποίο ξεκινάει αυτή η σειρά είναι <--
                end
            else
                row_ip=0; %Αν η σειρά έχει μόνο μηδενικά στοιχεία τότε βάλε στον δείκτη σειρά 0

            end
        end

        length = size(row_ip,1); % Μέτρα το μέγεθος του δείκτη
        row_ip(end+1)=1+nz; % Για να δείξεις ότι τελείωσει πρόσθεσε ένα στοιχείο στο τέλος

        for i=length:-1:1 % Όπου βλέπεις 0 στον δείκτη επανέλαβε την επόμενη τιμή του δείκτη
            if row_ip(i)==0
                row_ip(i)=row_ip(i+1);
            end
        end




    case 'csc'
        [row_ip,~]=find(A); %Επιστρέφει τα indexes των γραμμών των μη μηδενικών τιμών
        [~,~,val]=find(A); %Επιστρέφει τις ίδιες τις τιμές (ανα στήλες)


        for i=1:width
            a=A(:,i); %Πάρε μια στήλη του Α
            nz_in_column = find(a); %Βρες τα μη μηδενικά της στοιχεία
            nz_number_in_column(i) = size(nz_in_column,1); %Μέτρα πόσα είναι
        end

        for i=1:width %Για κάθε στήλη
            if nz_number_in_column(i)>0 %Αν έχει μη μηδενικά στοιχεία
                if flag==0 %Έλεγξε αν είναι η πρώτη στήλη χωρίς μηδενικά στοιχεία
                    col_ip(i)=1; %Βάλε στον δείκτη στήλη ότι η πρώτη τιμή του val είναι αυτής της σειράς
                    flag=1; %Ενημέρωσε ότι η πρώτη τιμή βρέθηκε
                else %Αν δεν είναι η πρώτη στήλη χωρίς μηδενικά στοιχεία
                    col_ip(i)=nz_number_in_column(i-1)+col_ip(i-1); %Τότε το στοιχείο του val από το οποίο ξεκινάει αυτή η στήλη είναι <--
                end
            else
                col_ip(i)=0; %Αν η σειρά έχει μόνο μηδενικά στοιχεία τότε βάλε στον δείκτη στήλης 0

            end
        end

        length = size(col_ip,1); % Μέτρα το μέγεθος του δείκτη
        col_ip(end+1)=1+nz; % Για να δείξεις ότι τελείωσει πρόσθεσε ένα στοιχείο στο τέλος

        for i=length:-1:1 % Όπου βλέπεις 0 στον δείκτη επανέλαβε την επόμενη τιμή του δείκτη
            if col_ip(i)==0
                col_ip(i)=col_ip(i+1);
            end
        end


    otherwise
        error("You didn't define the output type correctly")
end

%% 

%Δημιουργείται ένα αρχείο για να γραφεί η Latex
file=fopen('out.tex','w');

%Ξεκινάμε να γράφουμε Latex
fprintf(file, '$$ val = \\begin{tabular}{|');

for i=1:size(val,1), fprintf(file, '1|');
end

fprintf(file,'}\\hline\r\n');%Τέλος πρώτης γραμμής (ορισμός μεγέθους πίνακα)

for i=1:size(val,1)-1, fprintf(file,'%f &',val(i));% Τέλος δεδομένων
end

fprintf(file,'%f\\\\ \\hline \r\n \\end{tabular}$$\r\n',val(end));% Τέλος Tabular


switch sp_type

    case 'csr'

        fprintf(file, '$$ IA = \\begin{tabular}{|');% Αρχή tabular

        for i=1:size(col_ip,1), fprintf(file, '1|');
        end

        fprintf(file,'}\\hline \r\n');% Τέλος πρώτης γραμμής (ορισμός μεγέθους πίνακα)

        for i=1:size(col_ip,1)-1, fprintf(file,'%d &',col_ip(i));% Τέλος δεδομένων
        end

        fprintf(file,'%d\\\\ \\hline \r\n \\end{tabular}$$ \r\n',col_ip(end));% Τέλος Tabular



        fprintf(file, '$$ JA = \\begin{tabular}{|');% Αρχή tabular

        for i=1:size(row_ip,1), fprintf(file, '1|');
        end

        fprintf(file,'}\\hline\r\n');% Τέλος πρώτης γραμμής (ορισμός μεγέθους πίνακα)

        for i=1:size(row_ip,1)-1, fprintf(file,'%d &',row_ip(i));% Τέλος δεδομένων
        end

        fprintf(file,'%d\\\\ \\hline \r\n \\end{tabular}$$\r\n',row_ip(end));% Τέλος Tabular


    case 'csc'

        fprintf(file, '$$ IA = \\begin{tabular}{|');% Αρχή tabular

        for i=1:size(row_ip,1), fprintf(file, '1|');
        end

        fprintf(file,'}\\hline\n');% Τέλος πρώτης γραμμής (ορισμός μεγέθους πίνακα)

        for i=1:size(row_ip,1)-1, fprintf(file,'%d &',row_ip(i));% Τέλος δεδομένων
        end

        fprintf(file,'%d\\\\ \\hline \r\n \\end{tabular}$$\r\n',row_ip(end));% Τέλος Tabular



        fprintf(file, '$$ JA = \\begin{tabular}{|');% Αρχή tabular

        for i=1:size(col_ip,1), fprintf(file, '1|');
        end

        fprintf(file,'}\\hline \r\n');% Τέλος πρώτης γραμμής (ορισμός μεγέθους πίνακα)

        for i=1:size(col_ip,1)-1, fprintf(file,'%d &',col_ip(i));% Τέλος δεδομένων
        end

        fprintf(file,'%d\\\\ \\hline \r\n \\end{tabular}$$ \r\n',col_ip(end));% Τέλος Tabular

end



end
