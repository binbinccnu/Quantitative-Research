function alpha = AlphaPermute(Q)

% Q is the Q matrix
% alpha is the all possible alpha vectors regarding this number of
% dimension

dim = size(Q,2);
alpha = zeros(1,dim);

for j = 1:dim 
    permute = combnk(1:dim,j);
    alpha0  =zeros(size(permute,1),dim);
    for l = 1:size(alpha0,1)
        alpha0(l,permute(l,:))=1;
    end
    alpha = [alpha;alpha0];
end

