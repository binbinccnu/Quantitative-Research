% This constructs the W-matrix, P, fbar, and rbar jointly.
function [W,f,r,P] = irt_auxiliaryonline(X,U,itempar,item_index,item_number,start)
%item_index is the item ID needed to be calibrated in the whole item pool
%X is the quadurature points
%W is the probability 
%P is the probabiltiy of each item for each quadrature point
q = length(X);          %how many quadrature points
n = size(itempar,1);    %how many items
N = size(U,1);
Like = zeros(q,N);      %likelihoods for each quaduature point
f = zeros(q,N);
r = zeros(q,N);
weighted_L = zeros(q,N);

%this part is to compute W, which is N by 1
Pstar = zeros(q,n);
for j=1:q
    Pstar(j,:) = exp(exp(itempar(:,1)).*(X(j)-itempar(:,2)));
end
Pstar = Pstar./(1+Pstar); 
cs = ones(q,1)*itempar(:,3)';
P = cs + (1-cs).*Pstar; %probability of each item for each quadrature point at the starting value
W = (Pstar(:,item_number).*(1-Pstar(:,item_number)))./(P(:,item_number).*(1-P(:,item_number))); %W is e/(1+e) * 1/(1+e) / P / (1-P) at each quadrature point for each item

%this part is to compute posterior distribution for each examinee, each
%quadrature point
for j = 1:N             %each examinee
    if U(j,item_index)~=9
        for k = 1:q     %each quadrature point %itegrating out the theta, get the likelihood function        
            lll = zeros(n,1);  
            
            for i = start:n %each item           
                if U(j,i)~=9            
                    lll(i) = (log(P(k,i))*U(j,i))+(log(1-P(k,i))*(1-U(j,i)));
                end
            end
            Like(k,j) = sum(lll); %L is the likelihood for the jth examinee in kth quadrature point  
        end
    end
end

A = log(normpdf(X)*ones(1,N));%A is q by N
for j=1:N
    if U(j,item_index)~=9
        weighted_L(:,j) = exp(Like(:,j)+A(:,j));
    end
end
%transform back into original scale this is the weighted 

%this is the weighted likelihood
denom = sum(weighted_L,1);%intergrated value over theta for each examinee

for j=1:N
    if U(j,item_index)~=9
        f(:,j) = weighted_L(:,j)/denom(j);      %f is q by N
    end
end
%weight for the joint likelihood for each quadrature point for each examinee
for j=1:N
    if U(j,item_index)~=9
        r(:,j) = U(j,item_index)*f(:,j);
    end
end

r = sum(r,2);             %r is q by 1            
f = sum(f,2);             %f is q by 1, intergrated likelihood over theta for all examinees