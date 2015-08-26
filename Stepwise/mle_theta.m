function [theta_mle]=mle_theta(a,b,c,D,u)
%% compute the maximum likelihood estimation for a single examinee
%input u is a vector containing responses of an examinee for several items 
%input a b c is a vector containig parameters 
%input theta is the prior value of theta

for epsilo=[1 .5 .1 .05 .01 .005 .001]; %shrink the iterval as the location gets more accurate
    %get the search points
    if epsilo==1
        jtheta=(-3:epsilo:3)';
    else
        jtheta=(max(-3,theta_mle-epsilo):epsilo:min(3,theta_mle+epsilo))';
    end
    
    %set the threshold
    f_max=-length(u);
    
    %compute probabilities for each point each item
    pp=P_Computation(jtheta,a,b,c,D);
    
    %compute loglikeliihod for each point each item 
    temp=ones(length(jtheta),1)*u.*log(pp)+(1-ones(length(jtheta),1)*u).*log(1-pp);
    f=sum(temp,2); 
    
    %get the maximum likelihood value and corresponding estimator
    [max_value,index]=max(f);
    
    %update the estimator
    if max_value>f_max
        theta_mle=jtheta(index);
    end
end 
