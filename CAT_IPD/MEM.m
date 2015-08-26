%
'MEM'

start=1; 
%this means using all the items to estimate parameters

%generate priors for estimating items
% a_cat=normrnd(0,.25,n_cali,1);
% a_cat=exp(a_cat);
% b_cat=normrnd(0,1,n_cali,1);
% c_cat=betarnd(5,17,n_cali,1);
a_prior = a_1'; 
b_prior = b_1'; 
c_prior = c_1'; 
a_stra=normrnd(0,.25,length(flag_sib_stra),1);
a_stra=exp(a_stra);
b_stra=normrnd(0,0.7,length(flag_sib_stra),1);
c_stra=betarnd(5,17,length(flag_sib_stra),1);   

%%
% 'For normal CAT'
% 
% diff=1;
% iteration=0;
% while diff>0.05 & iteration<=50
%     iteration=iteration+1;
%     a_prior = [a_cat;a(n_cali+1:n)'];
%     b_prior = [b_cat;b(n_cali+1:n)'];
%     c_prior = [c_cat;c(n_cali+1:n)'];
%     [a_cat,b_cat,c_cat,flag_cat] = EM(sparse_matrix_cat,a_prior,b_prior,c_prior,n_cali,start);  
%     %check difference between a_cat and a_prior
%     diff = sum((a_cat(flag_cat)-a_prior(flag_cat)).^2 + ...
%                (b_cat(flag_cat)-b_prior(flag_cat)).^2 + ...
%                (c_cat(flag_cat)-c_prior(flag_cat)).^2 )
% end
% 
% rmse_cali_cat_a_MEM = rmse_cali_cat_a_MEM + RMSE(a(flag_cat),a_cat(flag_cat)');
% rmse_cali_cat_b_MEM = rmse_cali_cat_b_MEM + RMSE(b(flag_cat),b_cat(flag_cat)');
% rmse_cali_cat_c_MEM = rmse_cali_cat_c_MEM + RMSE(c(flag_cat),c_cat(flag_cat)');
%    
% bias_cali_cat_a_MEM = bias_cali_cat_a_MEM + BIAS(a(flag_cat),a_cat(flag_cat)');
% bias_cali_cat_b_MEM = bias_cali_cat_b_MEM + BIAS(b(flag_cat),b_cat(flag_cat)');
% bias_cali_cat_c_MEM = bias_cali_cat_c_MEM + BIAS(c(flag_cat),c_cat(flag_cat)'); 




%%

'For stratification CAT'

diff=1;
iteration=0;
%%
while diff>0.05 & iteration<=20
    %%
    iteration=iteration+1
    a_prior(flag_sib_stra)=a_stra;
    b_prior(flag_sib_stra)=b_stra;
    c_prior(flag_sib_stra)=c_stra;
    %%
    [a_stra,b_stra,c_stra,flag_stra] = EM(sparse_matrix_stra_2,a_prior,b_prior,c_prior,flag_sib_stra,start);  
    %% check difference between a_cat and a_prior
    diff = sum((a_stra(flag_stra)-a_prior(flag_stra)).^2 + ...
               (b_stra(flag_stra)-b_prior(flag_stra)).^2 + ...
               (c_stra(flag_stra)-c_prior(flag_stra)).^2 )
end
%%
rmse_cali_stra_a_MEM = RMSE(a_2(flag_stra),a_stra(flag_stra)');
rmse_cali_stra_b_MEM = RMSE(b_2(flag_stra),b_stra(flag_stra)');
rmse_cali_stra_c_MEM = RMSE(c_2(flag_stra),c_stra(flag_stra)');

bias_cali_stra_a_MEM = BIAS(a_2(flag_stra),a_stra(flag_stra)');
bias_cali_stra_b_MEM = BIAS(b_2(flag_stra),b_stra(flag_stra)');
bias_cali_stra_c_MEM = BIAS(c_2(flag_stra),c_stra(flag_stra)');     