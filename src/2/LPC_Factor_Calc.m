function [a,g] = LPC_Factor_Calc(X, p)

% X: Matrix that has all the frames stored column-by-column
% p: required number of LPC coefficients

cols = size(X,2);

a=[];
g=[];

for i=1:cols
[A G] = lpc_new(X(:,i), p);
a = [a A];
g = [g G];
end

end