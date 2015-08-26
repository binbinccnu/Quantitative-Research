function [a_hat,b_hat,c_hat,flag]=EM(U,a_prior,b_prior,c_prior,index_cali,start)
%this function does the OEM calculation
%index_cali is the items needed to be calibrated

n_cali=length(index_cali);
mu_a = 0; ssq_a = .25; 
mu_b = 0; ssq_b = 1  ;
alp  = 5; bet   = 17 ;  

itemparam = [log(a_prior),b_prior,c_prior];%random pick priors
flag=0;                          %how many items have been successfully estimated
flagiter=0;
outeriter=0;                     %how many cycles of outer iteration
%%
while length(flag) < n_cali && outeriter <= 10
    outeriter = outeriter + 1;
    for i = 1:n_cali             %estimate items one by one
        %%
        i
        new    = itemparam(index_cali(i),:); %the starting values of the ith item
        change = 1;              %wanna this change reduce to converge
        iter   = 0;              %how many inner iteration for estimating this item
       %%
        %This is where the Fisher scoring procedure happens.maximum is 120
        while change > 10^-7 && iter < 120  
            %%
            iter   = iter + 1;
            [L,F]  = FisherScoreonline(new,itemparam,U,index_cali(i),index_cali(i),mu_a,ssq_a,mu_b,ssq_b,alp,bet,start);
            s      = F\-L;
            change = norm(s);
            new    = new + s';
        end
        % Here, we keep only plausible item parameter values.
        if iter < 120 && (new(1) >= -2 && new(1) <= 1) && (new(2) >= -3 && new(2) <= 3) && (new(3) >= 0 && new(3) <= 1)
            itemparam(index_cali(i),:) = real(new);
            % This shows all items that have ever converged.
            if ~any(flag == i)
                flagiter = flagiter + 1;
                flag(flagiter) = i;
                flag = sort(flag);
            end
        end
    end
    % Here, we choose all items that have never converged, give them new
    % random starting values, and then let the algorithm start all over
    % again.
    flagn = 1:size(U,2);
    flagn(flag) = [];
    lf = length(flagn);
    itemparam(flagn,:) = [normrnd(0,.25,lf,1),normrnd(0,1,lf,1),betarnd(5,17,lf,1)];
end
a_hat=exp(itemparam(:,1));
b_hat=itemparam(:,2);
c_hat=itemparam(:,3);
a_hat=a_hat(index_cali);
b_hat=b_hat(index_cali);
c_hat=c_hat(index_cali);