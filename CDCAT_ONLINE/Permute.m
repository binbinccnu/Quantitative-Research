function alpha0 = Permute(dim,j)
%%% j is number of attributes


permute = combnk(1:dim,j);
alpha0  =zeros(size(permute,1),dim);
for l = 1:size(alpha0,1)
    alpha0(l,permute(l,:))=1;
end