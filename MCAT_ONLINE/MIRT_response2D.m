function U = MIRT_response2D(theta1,theta2,a1,a2,b)
% theta1 and theta2 are column vectors
% a1 a2 and b are column vectors

U = zeros(length(theta1),length(b));
P = MIRT_prob2D_matrix(theta1,theta2,a1,a2,b);
R = unifrnd(0,1,length(theta1),length(b));
U(P>R) = 1;
     