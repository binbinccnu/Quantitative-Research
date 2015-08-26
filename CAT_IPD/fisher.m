function information=fisher(theta_hat,a,b,c,D)
%this function computes fisher information

sum1 = exp(-D * a .* (theta_hat - b));
sum0 = (1 + sum1).* (1 + sum1);
sum2 = sum0 .* (1 + c .* sum1);
sum0 = (1 - c) .* D * D .*a .* a;
sum1 = sum0 .* sum1;
information = sum1./sum2;