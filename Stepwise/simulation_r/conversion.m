function [scaled_score] = conversion(raw_score,a1,b1,c1,a2,b2,c2,D,test1_test2_switch)
%goal is to construct conversion table
%raw_score is the true score for the first year
%a1 b1 c1 are first year parameters

if test1_test2_switch == 1
    % first get the corresponding theta value
    diff_min=9999;
    for epsilo=[1 .5 .1 .05 .01 .005 .001]   %shrink the interval step by step   
        %get the quadrature points    
        if epsilo==1;        
            jtheta=(-4:epsilo:4)'; 
        else           
            jtheta=(max(-4,theta-1):epsilo:min(4,theta+1))';  
        end        
        
        %compute total score    
        t=tcc(jtheta,a1,b1,c1,D);
        %compute difference between current total score and raw_score    
        diffs=abs(t-ones(length(jtheta),1)*raw_score);    
        [min_value,index]=min(diffs);   
        %get the corresponding theta estimate   
        if min_value<diff_min     
            diff_min=min_value;      
            theta=jtheta(index);    
        end
    end
elseif test1_test2_switch ==2
    diff_min=9999;
    for epsilo=[1 .5 .1 .05 .01 .005 .001]   %shrink the interval step by step   
        %get the quadrature points    
        if epsilo==1;        
            jtheta=(-4:epsilo:4)'; 
        else           
            jtheta=(max(-4,theta-1):epsilo:min(4,theta+1))';  
        end        
        
        %compute total score    
        t=tcc(jtheta,a2,b2,c2,D);
        %compute difference between current total score and raw_score    
        diffs=abs(t-ones(length(jtheta),1)*raw_score);    
        [min_value,index]=min(diffs);   
        %get the corresponding theta estimate   
        if min_value<diff_min     
            diff_min=min_value;      
            theta=jtheta(index);    
        end
    end
end

%% convert back to second administration true score
scaled_score=round(tcc(theta,a2,b2,c2,D));
end