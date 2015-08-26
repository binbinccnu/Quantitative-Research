clear; clc; close all
s = .01; g = .2; S = s*(1-s); G = g*(1-g); N = 300; replication = 1000; dim = 3; p = 10;
Q1 = Permute(dim,1); Q1 = repmat(Q1,5*p,1); Q2 = Permute(dim,2); Q2 = repmat(Q2,2*p,1); Q3 = Permute(dim,3); Q3 = repmat(Q3,p,1);
Q = [Q1;Q2;Q3]     ; Q  = Q(randsample(size(Q,1),1),:);
K = linspace(G/S,1,50);

%%
RMSE = []; D = []; Is = [];
for j = 1:length(K)
    mse1_1 = 0; mse2_1 = 0; k = K(j);
    n0 = round(N*G/(k*S+G));
    etas = [zeros(n0,1); ones(N-n0,1)];
    for rep = 1:replication 
        response_select = zeros(N,1);
        P = (1-s).*etas+g.*(1-etas);
        R = unifrnd(0,1,N,1);
        response_select(P>=R) = 1;
        g_est1 = sum(response_select .* (1 - etas)) / sum(1 - etas);
        s_est1 = sum((1 - response_select) .* etas) / sum(etas);
        mse1_1 = mse1_1 + (s - s_est1)^2; mse2_1 = mse2_1 + (g - g_est1)^2;
    end
    rmse = [sqrt(mse1_1/rep) sqrt(mse2_1/rep)];
    d = sum(etas==0)*sum(etas==1)/s/(1-s)/g/(1-g);
    I = [(N-n0)/s/(1-s) n0/g/(1-g)];
    RMSE = [RMSE; rmse];
    D = [D; d];
    Is = [Is; I];
end

plot(K,RMSE(:,1))
hold on 
plot(K,RMSE(:,2))
title([s,g])
