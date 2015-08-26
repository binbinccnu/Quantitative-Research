function logL=likelihood(a,b,c,theta,u,D)
%this function computes a log likelihood ratio
%theta is a vector
%a b c u are vectors

logL=0;
for jj=1:length(theta)
    for j=1:length(u)
        p=P_Computation(theta(jj),a,b,c,D);
        LL=u(j)*log(p)+(1-u(j))*log(1-p);
    end
    logL=logL+LL;
end