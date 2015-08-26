function truescore=tcc(theta,a,b,c,D)
%%%this function retures the true score given items and examinees
%theta is a column vector indicating ability levels of examinees
%a is a column vector indicating a parameters (discrimination parameters) of a test
%b is a column vector indicating b parameters (difficulty parameters) of a test
%c is a column vector indicating c parameters (guessing parameters) of a test

%compute probabilities for each examinee and each item
P=P_Computation(theta,a,b,c,D);
%compute true scores for each examinee
truescore=sum(P,2);
