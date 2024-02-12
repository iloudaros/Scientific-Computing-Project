function C = ttt_1067400(A, B, Option)
%% Author: Ioannis Louaros, ΑΜ:1067400
%% Version: 0.1     Date: 06/02/2023
% A : Το συμπιεσμένο μητρώο.
% B : Το δεξιό μέλος.
% Option : Η λύση του συστήματος.

% Get the shapes of X, V and Y.
shapeA = size(A);
shapeB = size(B);
shapeC = zeros([shapeA,shapeB]);


if nargin == 2
    % Initialize output tensor C
    C = zeros([shapeA, shapeB]);

    % Iterate through each element of A and multiply with B
    for i = 1:shapeA(1)
        for j = 1:shapeA(2:end-1)
            for k = 1:shapeA(end)
                C(i, j, :, k) = A(i, j, k) * B(:, k);
            end
        end
    end





elseif nargin == 3 && all(Option == 'all')
    % Perform inner product if mode is 'all'

    if ~(all(shapeA==shapeB))
        error('Cannot perform inner product of A and B. The dimensions do not match.' )
    end
    C = sum(A(:) .* B(:));



else
    error('Input error: Invalid mode for ttt_1067400.');
end
end
