function [L,F] = FisherScoreonline(xi,itempar,U,item_index,item_number,mu_a,ssq_a,mu_b,ssq_b,alp,bet,start)

itempar(item_number,:) = xi;
L = zeros(3,1);
F = zeros(3,3);
X = linspace(-3,3,31)';        %quadrature points
[W,f,r,P] = irt_auxiliaryonline(X,U,itempar,item_index,item_number,start);
P = P(:,item_number);
%%
L(1) = exp(xi(1))*(1-xi(3))*(r-f.*P)'*(W.*(X-xi(2)))-(xi(1)-mu_a)/ssq_a;

L(2) = -exp(xi(1))*(1-xi(3))*(r-f.*P)'*W-(xi(2)-mu_b)/ssq_b;

L(3) = (1-xi(3))^-1*sum((r-f.*P)./P)+((alp-2)/xi(3)-(bet-2)/(1-xi(3)));


F(1,1) = -exp(xi(1))^2*sum(f.*(X-xi(2)).^2.*((P-xi(3))/(1-xi(3))).^2.*(1-P)./P)-1/ssq_a;

F(2,2) = -exp(xi(1))^2*sum(f.*((P-xi(3))/(1-xi(3))).^2.*(1-P)./P)-1/ssq_b;

F(3,3) = -sum(f./(1-xi(3))^2.*(1-P)./P)-(alp-2)/xi(3)^2-(bet-2)/(1-xi(3))^2;

F(1,2) = exp(xi(1))^2*sum(f.*(X-xi(2)).*((P-xi(3))/(1-xi(3))).^2.*((1-P)./P));
F(2,1) = F(1,2);

F(1,3) = -exp(xi(1))^2*sum(f.*(X-xi(2)).*((P-xi(3))/(1-xi(3))^2).*((1-P)./P));
F(3,1) = F(1,3);

F(2,3) = exp(xi(1))*sum(f.*((P-xi(3))/(1-xi(3))^2).*((1-P)./P));
F(3,2) = F(2,3);