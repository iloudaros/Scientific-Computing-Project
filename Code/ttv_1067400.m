function Y = ttv_1067400(X,V,N)
%% Author: Ioannis Louaros, ΑΜ:1067400
%% Version: 0.1     Date: 06/02/2023
% X : The multidimensional array (tensor)
% V : The column vector to be multiplied with X.
% N : The dimension in X along which V is multiplied.

% Check if V is a column vector.
if ~iscolumn(V)
    error('V is not a column vector.');
end

%  Check input types and dimensions
if ndims(V) ~= ndims(X)-1
    error('The numbers of dimensions in V do not correspond to the number of dimensions in X.');
end

% Get the shapes of X, V and Y.
shapeX = size(X);
shapeV = size(V);
shapeY = shapeX([1:N-1,N+1:end]);

dimensions_left = 1:size(shapeX,2);
dimensions_left(dimensions_left==N)=[];

%Checking the length of V.
if shapeV ~=  shapeX(N)
    error('The length of V is different from the length of the fibers in X while in mode N.')
end

% Reshaping X in a way where we can then iterate over it with V.
X_reshaped = permute(X,[N,dimensions_left]);
X_reshaped = reshape(X_reshaped,1,[],1);

% Calculate Y.

Y=zeros(shapeY);

for i = 1:prod(shapeY)
    Y(i) = X_reshaped((i-1)*shapeV(1)+1 : i*shapeV(1)) * V;
end