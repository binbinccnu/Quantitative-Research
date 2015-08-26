function D = D_value(theta1,theta2,a1,a2,b,sparse,cali_item)
% thetas are column vectors indicating theta_mle for all examinees
% a1 a2 b are column vectors for pretest items
% information computes D optimality information for a set of items
% compute D for all pretest items, first compute previous information, then
% compute information including that person

%%
P = MIRT_prob2D_matrix(theta1,theta2,a1(cali_item),a2(cali_item),b(cali_item));
Q = 1 - P;
P(sparse(:,cali_item) == 9) = 0;
Theta1 = repmat(theta1,1,length(cali_item));
Theta2 = repmat(theta2,1,length(cali_item));

I_11 = P.*Q.*Theta1.*Theta1;
I_22 = P.*Q.*Theta2.*Theta2;
I_33 = P.*Q;

I_12 = P.*Q.*Theta1.*Theta2;
I_21 = I_12;

I_13 = P.*Q.*Theta1;
I_31 = I_13;

I_23 = P.*Q.*Theta2;
I_32 = I_23;

I = [sum(I_11,1)' sum(I_12)' sum(I_13)'; sum(I_21)' sum(I_22)' sum(I_23)'; sum(I_31)' sum(I_32)' sum(I_33)'];

D = det(I);