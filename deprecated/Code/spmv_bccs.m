function y = spmv_bccs(y,x,nb,val,brow_idx,bcol_ptr)
% Author: Ioannis Loudaros, ΑΜ:1067400, Date: 16/01/22

nzblocks = bcol_ptr(end)-1; % Το πλήθος των nz blocks
block_size = size(val,2)/nzblocks % Το πλήθος των στοιχείων κάθε block
block_side_size = sqrt(block_size) % To μέγεθος της πλευράς του block
matrix_side_size = (size(bcol_ptr,2)-1) * block_side_size % Το μέγεθος της πλευράς του αρχικού μητρώου

block_columns = size(bcol_ptr,2)-1 % Πλήθος των block-στηλών

%Preallocation
nzblocks_in_col=zeros(1,block_columns) % Το πλήθος των nz blocks για κάθε στήλη

for i = 1 : block_columns % Για κάθε block-στήλη

    nzblocks_in_col(i) = bcol_ptr(i+1)-bcol_ptr(i)% Βρίσκουμε πόσα nz blocks διαθέτει

end

for i = 1 : nzblocks

    for j = 1 : block_size


    %TELOS XRONOU

end
