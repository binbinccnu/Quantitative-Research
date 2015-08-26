function logit_optimal = untitled(b)
P = linspace(.01,.99,1000);
Q = 1 - P;
logit = log(P./Q);
expect = exp(2*b - logit) ./ (1 + exp(2*b - logit)).^2;
eb = exp(b)/(1+exp(b))^2;
D = (P.*Q + expect) .* (P.*Q + expect + 2*eb) .* logit.^2;
max_index = D == max(D);
P_optimal = P(max_index);
logit_optimal = log(P_optimal/(1-P_optimal));
if logit_optimal < 0
    logit_optimal = -logit_optimal;
end

%theta_11 = a1/(a1^2+a2^2) * logit_optimal