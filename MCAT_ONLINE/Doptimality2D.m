function Dvalue = Doptimality2D(theta1,theta2,a1,a2,b,selected)
% theta is a scalar
% a1 a2 b are column vectors
% information computes D optimality information for a set of items


p = MIRT_prob2D_matrix(theta1,theta2,a1(selected),a2(selected),b(selected));
q = 1 - p;
I_11 = p.*q.*a1(selected)'.*a1(selected)';
I_12 = p.*q.*a1(selected)'.*a2(selected)';
I_21 = I_12;
I_22 = p.*q.*a2(selected)'.*a2(selected)';
I_selected = [sum(I_11) sum(I_12); sum(I_21) sum(I_22)];

p = MIRT_prob2D_matrix(theta1,theta2,a1,a2,b);
q = 1 - p;
Dvalue = p'.*q'.*(a1.*a1.*I_selected(2,2)...
    + a2.*a2.*I_selected(1,1)...
    - 2.*a1.*a2.*I_selected(1,2));


% 
% for j = 1:length(b)
%     p = MIRT_prob2D_matrix(theta1,theta2,a1([selected j]),a2([selected j]),b([selected j]));
%     q = 1 - p;
%     I_11 = p.*q.*a1([selected j])'.*a1([selected j])';
%     I_12 = p.*q.*a1([selected j])'.*a2([selected j])';
%     I_21 = I_12;
%     I_22 = p.*q.*a2([selected j])'.*a2([selected j])';
%     I = [sum(I_11) sum(I_12); sum(I_21) sum(I_22)];
%     Dvalue1(j) = det(I);
% end



% I_selected = 0;
% for j = 1:length(selected)
%     p = MIRT_prob2D_matrix(theta1,theta2,a1(selected(j)),a2(selected(j)),b(selected(j)));
%     q = 1 - p;
%     I_selected = I_selected + q*p*([a1(selected(j))*a1(selected(j)) a1(selected(j))*a2(selected(j));a1(selected(j))*a2(selected(j)) a2(selected(j))*a2(selected(j))]);
% end
% 
% Dvalue2 = zeros(length(b),1);
% % first compute fisher information
% for j = 1:length(b)
%     p = MIRT_prob2D_matrix(theta1,theta2,a1(j),a2(j),b(j));
%     q = 1 - p;
%     I = I_selected + q*p*([a1(j)*a1(j) a1(j)*a2(j);a1(j)*a2(j) a2(j)*a2(j)]);
%     Dvalue2(j) = det(I);
% %     Dvalue2(j) = p*q*(a1(j)*a1(j)*I_selected(2,2)...
% %         + a2(j)*a2(j)*I_selected(1,1)...
% %         - 2*a1(j)*a2(j)*I_selected(1,2));
% end