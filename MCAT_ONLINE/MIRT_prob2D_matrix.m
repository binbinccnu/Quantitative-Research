function [P] = MIRT_prob2D_matrix(theta1,theta2,a1,a2,b)
%theta1 and theta2 are """column""" vectors
%a1 a2 b are column vectors
%output P is a person by item matrix

P = exp([theta1 theta2]*[a1 a2]' + repmat(b',length(theta1),1))./(1 + exp([theta1 theta2]*[a1 a2]' + repmat(b',length(theta1),1)));


P(P<.0001) = .0001;
P(P>.9999) = .9999;
