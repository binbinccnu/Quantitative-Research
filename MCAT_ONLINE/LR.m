% compute p 
p_old    = MIRT_prob2D_matrix(theta(:,1),theta(:,2), a_old(:,1),                   a_old(:,2),                   b_old);
p_pre    = MIRT_prob2D_matrix(theta(:,1),theta(:,2), a_pre(:,1),                   a_pre(:,2),                   b_pre);
p_FQ     = MIRT_prob2D_matrix(theta(:,1),theta(:,2), a1_Method_A_FQ_practical,     a2_Method_A_FQ_practical,     b_Method_A_FQ_practical);
p_sitter = MIRT_prob2D_matrix(theta(:,1),theta(:,2), a1_Method_A_sitter_practical, a2_Method_A_sitter_practical, b_Method_A_sitter_practical);
p_D      = MIRT_prob2D_matrix(theta(:,1),theta(:,2), a1_Method_A_D_practical,      a2_Method_A_D_practical,      b_Method_A_D_practical);
p_random = MIRT_prob2D_matrix(theta(:,1),theta(:,2), a1_Method_A_random_practical, a2_Method_A_random_practical, b_Method_A_random_practical);

%
FQ_i     = (sparse_FQ_practical ~= 9)*1;
sitter_i = (sparse_sitter_practical ~= 9)*1;
D_i      = (sparse_D_practical ~= 9)*1;
random_i = (sparse_random_practical ~= 9)*1;

% compute likelihood 
l_old    = log(p_old.^U_pre    .* (1-p_old).^(1 - U_pre));
l_real   = log(p_pre.^U_pre    .* (1-p_pre).^(1 - U_pre));
l_FQ     = log(p_FQ.^U_pre     .* (1-p_FQ).^(1 - U_pre));
l_sitter = log(p_sitter.^U_pre .* (1-p_sitter).^(1 - U_pre));
l_D      = log(p_D.^U_pre      .* (1-p_D).^(1 - U_pre));
l_random = log(p_random.^U_pre .* (1-p_random).^(1 - U_pre));

%% likelihood ratio
LR_FQ     = sum( -2 * (l_old.*FQ_i     - l_FQ.*FQ_i));
LR_sitter = sum( -2 * (l_old.*sitter_i - l_sitter.*sitter_i));
LR_D      = sum( -2 * (l_old.*D_i      - l_D.*D_i));
LR_random = sum( -2 * (l_old.*random_i - l_random.*random_i));

LN_FQ     = sum( -2 * (l_real.*FQ_i    - l_FQ.*FQ_i));
LN_sitter = sum( -2 * (l_real.*sitter_i- l_sitter.*sitter_i));
LN_D      = sum( -2 * (l_real.*D_i     - l_D.*D_i));
LN_random = sum( -2 * (l_real.*random_i- l_random.*random_i));

%% p value
P_FQ      = chi2cdf(LR_FQ,3,'upper');
P_sitter  = chi2cdf(LR_sitter,3,'upper');
P_D       = chi2cdf(LR_D,3,'upper');
P_random  = chi2cdf(LR_random,3,'upper');

N_FQ      = chi2cdf(LN_FQ,3,'upper');
N_sitter  = chi2cdf(LN_sitter,3,'upper');
N_D       = chi2cdf(LN_D,3,'upper');
N_random  = chi2cdf(LN_random,3,'upper');

%% power
pow_FQ    = sum(P_FQ < .05)    /length(index_cali);
pow_sitter= sum(P_sitter < .05)/length(index_cali);
pow_D     = sum(P_D < .05)     /length(index_cali);
pow_random= sum(P_random < .05)/length(index_cali);

%% type I error
Nul_FQ    = sum(N_FQ < .05)    /length(index_cali);
Nul_sitter= sum(N_sitter < .05)/length(index_cali);
Nul_D     = sum(N_D < .05)     /length(index_cali);
Nul_random= sum(N_random < .05)/length(index_cali);
