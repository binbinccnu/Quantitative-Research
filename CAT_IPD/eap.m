function eap_estimate = eap(a, b, c, D, u, nqt,prior_mean)
% computes expected a posteriori (EAP) ability estimates for 3PL model

% Inputs:
%   1)   a = J×1 vector of discrimination parameters (for the J items)
%   2)   b = J×1 vector of difficulty parameters (for the J items)
%   3)   c = J×1 vector of guessing parameters (for the J items)
%   4)   d = a positive scaling constant (typically d=1.702)
%   5)   u = 1xJ matrix where u_{j}=1 if the subject correctly
%        answered the j-th item, and u_{j}=0 otherwise
%   6)   nqt is the number of quadrature points
% Output:
%     eap_estimate = a scalor containing EAP ability estimate for the subject
%based on previous estimated value as the prior mean

J=length(a);
xk=zeros(1,nqt);
step=8/(nqt-1);
like=ones(1,nqt);
prior=zeros(1,nqt);

for q=1:nqt;
    xk(q)=-4+(q-1)*step;
    prior(q)=exp(-(xk(q)-prior_mean)^2/2)/sqrt(2*pi);
end

%likelihood of responses given the quadrature points
for k=1:nqt
    for j=1:J
        pij=c(j)+(1-c(j))/(1+exp(-D*a(j)*(xk(k)-b(j))));
        like(k)=like(k)*pij^u(j)*(1-pij)^(1-u(j));
    end
end

numerator=0;
denominator=0;

for k=1:nqt;
    numerator=numerator+like(k)*prior(k)*xk(k);
    denominator=denominator+like(k)*prior(k);
end

eap_estimate=numerator/denominator;