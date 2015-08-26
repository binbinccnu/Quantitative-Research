function [information_a1,information_a2,information_b] = fisher(theta,a,b)

P = MIRT_prob2D_matrix(theta(:,1),theta(:,2),a(:,1),a(:,2),b);
Q = 1 - P;

information_a1 = theta(:,1).*theta(:,1).*P.*Q;
information_a2 = theta(:,2).*theta(:,2).*P.*Q;
information_b  = P.*Q;
